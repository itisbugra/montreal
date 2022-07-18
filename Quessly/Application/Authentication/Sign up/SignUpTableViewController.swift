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
    case usernameExists
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
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var extraAttributeLabel: UILabel!
  @IBOutlet weak var SignUpToQuessly: UINavigationItem!
  
  private weak var logger = Logger.shared
  
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
  
  override func viewDidAppear(_ animated: Bool) {
    self.usernameTextField.becomeFirstResponder()
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
    return [usernameTextField, extraAttributeTextField, passwordTextField, confirmPasswordTextField]
  }
  
  private var hasMatchingPasswords: Bool {
    return passwordTextField.text! == confirmPasswordTextField.text!
  }
  
  //  MARK: - UIViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //  Set input accessory of each text field
    textFields.forEach { $0.inputAccessoryView = keyboardAccessoryToolbar }
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.resignFirstResponder()
      self.fillInputsWithDebugContent()
    }
  }
  
  //  MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      usernameTextField.becomeFirstResponder()
      
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
    
    let username = usernameTextField.text!
    let email = extraAttributeTextField.text!
    let password = passwordTextField.text!
    let confirmingPassword = confirmPasswordTextField.text!
    
    guard validateUsername(username: username) else {
      throw ValidationError.invalidUsername(username: username)
    }
    
    switch currentMedium {
    case .email:
      guard validateEmail(email: email) else {
        throw ValidationError.invalidEmail(email: email)
      }
      
    case .phoneNumber:
      //  TODO: Handle validation of phone number
      break
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
        DispatchQueue.main.async {
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
                //  TODO: Code delivery
                break
                
              case .failure(error: .usernameExists):
                self.presentUsernameExistsAlert()
                
              case .failure(error: .network):
                //  TODO: Network error
                break
                
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
    }catch ValidationError.invalidUsername(_) {
      presentUsernameAlert(completion: nil)
    } catch ValidationError.invalidEmail(_) {
      presentInvalidEmailAlert(completion: nil)
    } catch ValidationError.invalidPassword(_) {
      presentInvalidPasswordAlert(completion: nil)
    } catch ValidationError.nonMatchingPasswords {
      presentNonMatchingPasswordsAlert(completion: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  func performCompletion(for challenge: Challenge, tries: UInt = 3, completion: ((Bool) -> Void)? = nil) {
    guard tries != 0 else {
      logger?.log(.controller, .warning, "Out of tries, will not performing completion.")
      self.dismiss(animated: true) {
        self.presentOutOfTriesAlert()
      }
      return
    }
    
    DispatchQueue.main.async {
      self.presentConfirmationCodeAlert(for: challenge) { result in
        switch result {
        case .code(let code):
          self.completeChallenge(code: code) { result in
            self.dismiss(animated: true) {
              switch result {
              case .success:
                completion?(true)
                
              case .failure(.mismatch):
                self.dismiss(animated: true) {
                  self.presentInvalidConfirmationCodeAlert() {
                    self.dismiss(animated: true) {
                      self.performCompletion(for: challenge, tries: tries - 1, completion: completion)
                    }
//                    self.performCompletion(for: challenge, tries: tries - 1, completion: completion)
                }
              }
            }
          }
        }
          
        case .resend:
          self.resendCode() { _ in
            self.dismiss(animated: true) {
              self.performCompletion(for: challenge, tries: tries - 1, completion: completion)
            }
          }
          
          
        case .cancel:
          self.dismiss(animated: true) {
            completion?(false)
          }
        }
      }
    }
  }
  
  //  MARK: - Remote procedure calls
  
  /// Performs sign up with the data found in the user interface elements. As the callback, invokes given completion function.
  private func signUp(completion: ((SignUpResult) -> Void)? = nil) {
    signUp(username: self.usernameTextField.text!,
           extraAttribute: self.extraAttributeTextField.text!,
           password: self.passwordTextField.text!,
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
              
            case .usernameExists:
              completion?(.failure(error: .usernameExists))
              
            case .lambda:
              completion?(.failure(error: .lambda))
              break
              
            default:
              fatalError()
            }
            
          default:
            fatalError()
          }
        }
      }
  }
  /// Completes challenge with the given code with the username found in the user interface elements. As the callback, invokes given completion function.
  private func completeChallenge(code: String, completion: ((ChallengeResult) -> Void)? = nil) {
    completeChallenge(username: self.usernameTextField.text!,
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
    resendCode(username: self.usernameTextField.text!,
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
  
  func phoneNumber() {
    guard
      let phoneUtil = NBPhoneNumberUtil.sharedInstance(),
      let locale = Locale.current.regionCode else {
      return
    }
    
    do {
      let phoneNumber: NBPhoneNumber = try phoneUtil.parse("[^0-9]", defaultRegion: locale)
      let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .INTERNATIONAL)
      
      NSLog("[%@]", formattedString)
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  //  MARK: - Navigation
  
  private func presentMainMenu(sender: Any?) {
    performSegue(withIdentifier: "exitToSignInWithSuccess", sender: sender)
  }
  
  private func exitToSignInMenu(sender: Any?, withDirtyValuesCheck dirtyValuesChecked: Bool = true) {
    guard
      let username = usernameTextField.text,
      let attribute = extraAttributeTextField.text,
      let password = passwordTextField.text,
      let passwordConfirmation = confirmPasswordTextField.text else {
      return
    }
    
    guard
      (username == "" && attribute == "" && password == "" && passwordConfirmation == "") || !dirtyValuesChecked else {
      self.dismiss(animated: true) {
        self.presentDiscardInformationSignUpAlert()
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
    exitToSignInMenu(sender: nil)
//    let username = usernameTextField.text
//    let attribute = extraAttributeTextField.text
//    let password = passwordTextField.text
//    let passwordConfirmation = confirmPasswordTextField.text
//
//    if username == "" && attribute == "" && password == "" && passwordConfirmation == "" {
//      self.dismiss(animated: true) {
//        self.presentDiscardInformationSignUpAlert()
//      }
//    }
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
    self.usernameTextField.text = generateUsername()
    self.passwordTextField.text = "ersinANKARA123."
    self.confirmPasswordTextField.text = "ersinANKARA123."
    
    switch currentMedium {
    case .email:
      self.extraAttributeTextField.text = generateEmailAddress()
      
    case .phoneNumber:
      self.extraAttributeTextField.text = "00447551787784"
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
  
  func rightToLeft() {
    let lang = Locale.current.languageCode
    if lang == "sa" {
      self.usernameTextField.textAlignment = NSTextAlignment.right
      self.extraAttributeTextField.textAlignment = NSTextAlignment.right
      self.passwordTextField.textAlignment = NSTextAlignment.right
      self.confirmPasswordTextField.textAlignment = NSTextAlignment.right
      UIView.appearance().semanticContentAttribute = .forceRightToLeft
      
    }
  }
}

extension SignUpTableViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case usernameTextField:
      extraAttributeTextField.becomeFirstResponder()
      
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
}
