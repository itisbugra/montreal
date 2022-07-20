import UIKit
import Amplify
import AmplifyPlugins
import AWSMobileClient
import libPhoneNumber_iOS
import NSLogger

class SignUpTableViewController: UITableViewController {
  enum SignUpResult {
    case success
    case challengeRequired(challenge: Challenge)
    case failure(error: SignUpError)
  }
  
  enum ChallengeResult {
    case success
    case failure(error: ChallengeError)
  }
  
  enum Challenge {
    case email(_ emailAddress: String)
    case phone(_ phoneNumber: String)
    case sms(_ phoneNumber: String)
  }
  
  enum SignUpError: Error {
    case delivery
    case network
//    case usernameExists
    case lambda
    case unknownChallenge
  }
  
  enum ChallengeError: Error {
    case mismatch
  }
  
  enum TwoFactorAuthenticationMedium {
    case email
    case phoneNumber
  }
  
  @IBOutlet weak var keyboardAccessoryToolbar: UIToolbar!
  @IBOutlet weak var extraAttributeTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
//  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var extraAttributeLabel: UILabel!
  @IBOutlet weak var SignUpToQuessly: UINavigationItem!
  @IBOutlet weak var signUpWithPhoneNumberLabel: UILabel!
  
  private weak var logger = Logger.shared
  
  lazy var asYouTypePhoneNumberFormatter: NBAsYouTypeFormatter = {
    let regionCode = Locale.current.regionCode!.lowercased()
    
    return NBAsYouTypeFormatter(regionCode: regionCode)
  }()
  
  private var currentMedium: TwoFactorAuthenticationMedium = .email {
    didSet {
      self.extraAttributeTextField.text = ""
      
      switch currentMedium {
      case .email:
        self.extraAttributeLabel.text = NSLocalizedString("E-mail", comment: "")
        self.extraAttributeTextField.keyboardType = .emailAddress
        self.extraAttributeTextField.placeholder = NSLocalizedString("example@mail.com", comment: "")
        
      case .phoneNumber:
        self.extraAttributeLabel.text = NSLocalizedString("Phone number", comment: "")
        self.extraAttributeTextField.keyboardType = .phonePad
        self.extraAttributeTextField.placeholder = NSLocalizedString("+1 (234) 789 5614", comment: "")
      }
    }
  }
  
  lazy var emailPredicate: NSPredicate = {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  lazy var usernamePredicate: NSPredicate = {
    let regex = "\\A\\w{4,12}\\z"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  lazy var passwordPredicate: NSPredicate = {
    let regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  private var textFields: [UITextField] {
    return [extraAttributeTextField, passwordTextField, confirmPasswordTextField]
  }
  
  private var hasMatchingPasswords: Bool {
    return passwordTextField.text! == confirmPasswordTextField.text!
  }
  
  //  MARK: - UIViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //  Set input accessory of each text field
    textFields.forEach { $0.inputAccessoryView = keyboardAccessoryToolbar }
    
    //  Register nib for the custom section header
    let sectionHeaderNib = UINib(nibName: "ChangeAttributeHeaderFooterView", bundle: nil)
    tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "ChangeAttribute")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.extraAttributeTextField.becomeFirstResponder()
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.resignFirstResponder()
      self.fillInputsWithDebugContent()
    }
  }
  
  //  MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard tableView == self.tableView else {
      return nil
    }
    
    guard section == 0 else {
      return nil
    }
    
    let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChangeAttribute") as! ChangeAttributeHeaderFooterView
    
    headerFooterView.delegate = self
    
    if headerFooterView.attributeType == nil {
      switch currentMedium {
      case .email:
        headerFooterView.attributeType = .email
        
      case .phoneNumber:
        headerFooterView.attributeType = .phoneNumber
      }
    }
    
    return headerFooterView
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard tableView == self.tableView else {
      return 0
    }
    
    return 43.0
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    guard tableView == self.tableView else {
      return
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch (indexPath.section, indexPath.row) {
//    case (0, 0):
//      usernameTextField.becomeFirstResponder()
      
    case (0, 1):
      extraAttributeTextField.becomeFirstResponder()
      
    case (0, 2):
      passwordTextField.becomeFirstResponder()
      
    case (0, 3):
      confirmPasswordTextField.becomeFirstResponder()
      
    default:
      break
    }
  }
  
  private func showMainMenu(sender: Any?) {
    self.performSegue(withIdentifier: "showMainMenu", sender: self.tableView)
  }
  
  //  MARK: - Operations
  
  enum ValidationError: Error {
    case invalidUsername(username: String)
    case invalidEmail(email: String)
    case invalidPhoneNumber(phoneNumber: String)
    case invalidPassword(password: String)
    case nonMatchingPasswords
  }
  
  func validateFields() throws {
    /// Validates username with a regular expression.
    func validateUsername(username: String) -> Bool {
      return usernamePredicate.evaluate(with: username)
    }
    
    /// Validates email address with a regular expression.
    func validateEmail(email: String) -> Bool {
      return emailPredicate.evaluate(with: email)
    }
    
    /// Validates phone number with an external library.
    func validatePhoneNumber(phoneNumber: String) -> Bool {
      return PhoneNumberFormatter().isValid(string: phoneNumber)
    }
    
    /// Validates the password if it has a proper length.
    func validatePassword(password: String) -> Bool {
      let length = password.count
      
      //  TODO: Perform more intense password checking
      return length >= 10 && length <= 40
    }
    
    /// Validates that two passwords entered by the user does match.
    func validateMatchingPasswords(password: String,
                                   confirmingPassword: String) -> Bool {
      return password == confirmingPassword
    }
    
//    let username = usernameTextField.text!
    let extraAttribute = extraAttributeTextField.text!
    let password = passwordTextField.text!
    let confirmingPassword = confirmPasswordTextField.text!
    
//    guard validateUsername(username: username) else {
//      throw ValidationError.invalidUsername(username: username)
//    }
    
    switch currentMedium {
    case .email:
      guard validateEmail(email: extraAttribute) else {
        throw ValidationError.invalidEmail(email: extraAttribute)
      }
      
    case .phoneNumber:
      guard validatePhoneNumber(phoneNumber: extraAttribute) else {
        throw ValidationError.invalidPhoneNumber(phoneNumber: extraAttribute)
      }
    }
    
    guard validatePassword(password: password) else {
      throw ValidationError.invalidPassword(password: password)
    }
    
    guard validateMatchingPasswords(password: password, confirmingPassword: confirmingPassword) else {
      throw ValidationError.nonMatchingPasswords
    }
  }
  
  //  MARK: - User interface actions
  
  func performSignUp(completion: ((Bool) -> Void)? = nil) {
    do {
      try validateFields()
      
      self.presentLoadingAlert {
        self.signUp { result in
          self.dismiss(animated: true) {
            switch result {
            case .success:
              self.presentMainMenu(sender: nil)
              
            case .challengeRequired(let challenge):
              self.performCompletion(for: challenge) { success in
                if success {
                  self.presentMainMenu(sender: nil)
                } else {
                  self.exitToSignInMenu(sender: nil, withDirtyValuesCheck: true)
                }
              }
              
            case .failure(error: .delivery):
              self.presentNotDeliveryAlert()
              
//            case .failure(error: .usernameExists):
//              self.presentUsernameExistsAlert()
              
            case .failure(error: .network):
              self.presentNetworkConnectionAlert()
              
            case .failure(error: .unknownChallenge):
              //  TODO: Handle error
              break
            case .failure(error: .lambda):
              break
            }
          }
        }
      }
    }
//    catch ValidationError.invalidUsername(_) {
//      presentUsernameAlert(completion: nil)
//    }
    catch ValidationError.invalidEmail(_) {
      presentInvalidEmailAlert(completion: nil)
    } catch ValidationError.invalidPassword(_) {
      presentInvalidPasswordAlert(completion: nil)
    } catch ValidationError.nonMatchingPasswords {
      presentNonMatchingPasswordsAlert(completion: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  func performCompletion(for challenge: Challenge,
                         withTries tries: UInt = 3,
                         completion: ((Bool) -> Void)? = nil) {
    guard tries > 0 else {
      logger?.log(.controller, .warning, "Out of tries, will not performing completion.")
      
      return
    }
    
    self.presentConfirmationCodeAlert(for: challenge) { result in
      switch result {
      case .code(let code):
        self.completeChallenge(code: code) { result in
          switch result {
          case .success:
            completion?(true)
            
          case .failure(.mismatch):
            if tries - 1 == 0 {
              self.presentOutOfTriesAlert {
                completion?(false)
              }
            } else {
              self.presentInvalidConfirmationCodeAlert() {
                self.performCompletion(for: challenge,
                                       withTries: tries - 1,
                                       completion: completion)
              }
            }
          }
        }
        
      case .resend:
        self.presentSendingResendCodeAlert {
            self.resendCode() { _ in
              self.dismiss(animated: true) {
                self.performCompletion(for: challenge,
                                       withTries: 3,
                                       completion: completion)
              }
            }
          }
        
      case .cancel:
        self.dismiss(animated: true) {
          completion?(false)
        }
      }
    }
  }
  
  //  MARK: - Remote procedure calls
  
  /// Performs sign up with the data found in the user interface elements. As the callback, invokes given completion function.
  private func signUp(completion: ((SignUpResult) -> Void)? = nil) {
    guard
      let extraAttribute = self.extraAttributeTextField.text,
      let password = self.passwordTextField.text,
      var extraAttribute = self.extraAttributeTextField.text else
    {
      fatalError()
    }
    
    if currentMedium == .phoneNumber {
      extraAttribute = try! PhoneNumberFormatter().convert(string: extraAttribute, to: .e164)
    }
    
    signUp(username: extraAttribute,
           extraAttribute: extraAttribute,
           password: password,
           completion: completion)
  }
  
  /// Performs sign up with the given username, e-mail address (or phone number), password. As the callback, invokes given completion function.
  private func signUp(username: String, extraAttribute: String, password: String, completion: ((SignUpResult) -> Void)? = nil) {
    let attributeKey: AuthUserAttributeKey = {
      switch currentMedium {
      case .email:
        return .email
        
      case .phoneNumber:
        return .phoneNumber
      }
    }()
    
    let userAttributes = [AuthUserAttribute(attributeKey, value: extraAttribute)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    
    Amplify.Auth
      .signUp(username: username,
              password: password,
              options: options) { result in
        DispatchQueue.main.async {
          switch result {
          case .success(let signUpResult):
            if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
              Logger.shared.log(.controller, .info, "Delivery details \(String(describing: deliveryDetails))")
              
              switch deliveryDetails!.destination {
              case .email(let emailAddress):
                completion?(.challengeRequired(challenge: .email(emailAddress!)))
                
              case .phone(let phoneNumber):
                completion?(.challengeRequired(challenge: .phone(phoneNumber!)))
                
              case .sms(let phoneNumber):
                completion?(.challengeRequired(challenge: .sms(phoneNumber!)))
                
              case .unknown(_):
                fatalError()
              }
            } else {
              Logger.shared.log(.controller, .info, "Sign up successful but challenge was not needed.")
              
              completion?(.success)
            }
            
          case .failure(.service(_, _, let error)):
            switch error as! AWSCognitoAuthError {
            case .codeDelivery:
              completion?(.failure(error: .delivery))
              
            case .network:
              completion?(.failure(error: .network))
              
//            case .usernameExists:
//              completion?(.failure(error: .usernameExists))
              
            case .lambda:
              completion?(.failure(error: .lambda))
              
            default:
              fatalError()
            }
            
          default:
            fatalError()}
        }
      }
  }
  /// Completes challenge with the given code with the username found in the user interface elements. As the callback, invokes given completion function.
  private func completeChallenge(code: String, completion: ((ChallengeResult) -> Void)? = nil) {
    completeChallenge(username: self.extraAttributeTextField.text!,
                      code: code,
                      completion: completion)
  }
  
  private func completeChallenge(username: String, code: String, completion: ((ChallengeResult) -> Void)? = nil) {
    Amplify.Auth
      .confirmSignUp(for: username,
                     confirmationCode: code) { result in
        DispatchQueue.main.async {
          switch result {
          case .success:
            self.logger?.log(.controller, .info, "Sign up successful with the challenge.")
            completion?(.success)
            
          case .failure(let error):
            self.logger?.log(.controller, .error, "Error occurred while completing sign up challenge.")
            self.logger?.log(.controller, .important, error.debugDescription)
            
            
            switch error {
            case .service(_, _, let error):
              switch error as! AWSCognitoAuthError {
              case .codeMismatch:
                completion?(.failure(error: .mismatch))
                
              default:
                fatalError()
              }
              
            default:
              self.presentInvalidConfirmationCodeAlert()
            }
          }
        }
      }
  }
  
  /// When the users enter the authentication code incorrectly, they can request the code again
  
  private func resendCode(completion: ((ChallengeResult) -> Void)? = nil) {
    resendCode(username: self.extraAttributeTextField.text!,
               completion: completion)
  }
  
  private func resendCode(username: String, completion:((ChallengeResult) -> Void)? = nil) {
    Amplify.Auth
      .resendSignUpCode(for: username) { result in
        DispatchQueue.main.async {
          switch result {
          case .success(let deliveryDetails):
            Logger.shared.log(.controller, .info, "Resend code send to - \(deliveryDetails)")
            completion?(.success)
            
          case .failure(let error):
            Logger.shared.log(.controller, .error, "Resend code failed with error \(error)")
          }
        }
      }
  }
  
  //  MARK: - Navigation
  
  private func presentMainMenu(sender: Any?) {
    performSegue(withIdentifier: "exitToSignInWithSuccess", sender: sender)
  }
  
  private func exitToSignInMenu(sender: Any?, withDirtyValuesCheck dirtyValuesChecked: Bool = true) {
    guard
//      let username = usernameTextField.text,
      let attribute = extraAttributeTextField.text,
      let password = passwordTextField.text,
      let passwordConfirmation = confirmPasswordTextField.text else {
      return
    }
    
    guard
      (attribute == "" && password == "" && passwordConfirmation == "") || !dirtyValuesChecked else {
      self.presentDiscardInformationSignUpAlert() {
        self.exitToSignInMenu(sender: sender, withDirtyValuesCheck: false)
      }
      
      return
    }
    
    performSegue(withIdentifier: "exitToSignInWithoutAction", sender: sender)
  }
  
  //  MARK: - Interface builder actions
  
  @IBAction func submit(_ sender: Any) {
    performSignUp()
  }
  
  
  @IBAction func cancel(_ sender: Any) {
    self.exitToSignInMenu(sender: sender)
  }
  
  @IBAction func switchTwoFactorAuthenticationMedium(_ sender: Any) {
    switch currentMedium {
    case .email:
      currentMedium = .phoneNumber
      
    case .phoneNumber:
      currentMedium = .email
    }
  }
  
  @IBAction func dismissKeyboard(_ sender: UIBarButtonItem) {
    //  Tell all text fields to dismiss their keyboards if open
    textFields.forEach { $0.resignFirstResponder() }
  }
  
  //  MARK: - Debug capabilities
  
  func fillInputsWithDebugContent() {
//    self.usernameTextField.text = generateUsername()
    self.passwordTextField.text = "Ersin1997."
    self.confirmPasswordTextField.text = "Ersin1997."
    
    switch currentMedium {
    case .email:
      self.extraAttributeTextField.text = generateEmailAddress()
      
    case .phoneNumber:
      self.extraAttributeTextField.text = "+447551787784"
    }
  }
  
  private func generateUsername() -> String {
    return "ersin\(Int.random(in: 1000000...9999999))"
  }
  
  private lazy var debugEmailAddressDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyyMMddHHmmss"
    
    return formatter
  }()
  
  private func generateEmailAddress() -> String {
    let postfix = debugEmailAddressDateFormatter.string(from: Date())
    
    return "ersin+\(postfix)@any.academy"
  }
}

extension SignUpTableViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
//    case usernameTextField:
//      extraAttributeTextField.becomeFirstResponder()
      
    case extraAttributeTextField:
      passwordTextField.becomeFirstResponder()
      
    case passwordTextField:
      confirmPasswordTextField.becomeFirstResponder()
      
    case confirmPasswordTextField:
      confirmPasswordTextField.resignFirstResponder()
      performSignUp()
      
    default:
      break
    }
    
    return true
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if textField == self.extraAttributeTextField {
      if !(string.count + range.location > 18) {
        if range.length == 0 {
          self.extraAttributeTextField.text = self.asYouTypePhoneNumberFormatter.inputDigit(string)
        } else if range.length == 1 {
          self.extraAttributeTextField.text = self.asYouTypePhoneNumberFormatter.removeLastDigit()
        } else if range.length == self.extraAttributeTextField.text!.count {
          self.asYouTypePhoneNumberFormatter.clear()
          self.extraAttributeTextField.text = ""
        }
      }
      
      return false
    }
    
    return true
  }
}

extension SignUpTableViewController: ChangeAttributeHeaderFooterViewDelegate {
  func changeAttributeHeaderFooterView(_ changeAttributeHeaderFooterView: ChangeAttributeHeaderFooterView, didSwitchAttributeType attributeType: ChangeAttributeHeaderFooterView.AttributeType) {
    switch attributeType {
    case .email:
      self.currentMedium = .email
      
    case .phoneNumber:
      self.currentMedium = .phoneNumber
    }
    
    self.tableView.reloadData()
  }
}
