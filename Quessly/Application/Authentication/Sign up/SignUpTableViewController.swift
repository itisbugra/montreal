import UIKit
import Amplify
import AmplifyPlugins
import AWSMobileClient
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
    case email(emailAddress: String)
    case phone(phoneNumber: String)
    case sms(phoneNumber: String)
  }
  
  enum SignUpError: Error {
    case delivery
    case network
    case usernameExists
    case unknownChallenge
  }
  
  enum ChallengeError: Error {
    case mismatch
  }
  
  

  
  @IBOutlet weak var keyboardAccessoryToolbar: UIToolbar!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  
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
    let regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{10,}$"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  private var textFields: [UITextField] {
    return [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
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
  
  //  MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      usernameTextField.becomeFirstResponder()
      
    case (0, 1):
      emailTextField.becomeFirstResponder()
      
    case (0, 2):
      passwordTextField.becomeFirstResponder()
      
    case (0, 3):
      confirmPasswordTextField.becomeFirstResponder()
      
    case (1, 0):
      performSignUp()
      
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
    let email = emailTextField.text!
    let password = passwordTextField.text!
    let confirmingPassword = confirmPasswordTextField.text!
    
    guard validateUsername(username: username) else {
      throw ValidationError.invalidUsername(username: username)
    }
    
    guard validateEmail(email: email) else {
      throw ValidationError.invalidEmail(email: email)
    }
    
    guard validatePassword(password: password) else {
      throw ValidationError.invalidPassword(password: password)
    }
    
    guard validateMatchingPasswords(password: password, confirmingPassword: confirmingPassword) else {
      throw ValidationError.nonMatchingPasswords
    }
  }
  
  //  MARK: - User interface actions
  
  func performSignUp() {
    do {
      try validateFields()
      
      self.presentLoadingAlert {
        self.signUp { result in
          self.dismiss(animated: true) {
            switch result {
            case .success:
              self.presentMainMenu(sender: nil)
              
            case .challengeRequired(.email(let emailAddress)):
              self.presentConfirmationCodeAlert(destination: emailAddress) { result in
                switch result {
                case .code(let code):
                  self.completeChallenge(code: code) { result in
                    self.dismiss(animated: true) {
                      switch result {
                      case .success:
                        self.presentMainMenu(sender: nil)
                        
                      case .failure(.mismatch):
                        self.presentInvalidConfirmationCodeAlert() {
                            //  TODO: Show code input alert controller
                          self.dismiss(animated: true) {
                            self.presentConfirmationCodeAlert(destination: emailAddress, completion: nil)
                          }
                        }
                      }
                    }
                  }
                  
                case .resend:
                  self.resendCode()
                  
                case .cancel:
                  self.dismiss(animated: true)
                }
              }
              
            case .challengeRequired(.phone(let phoneNumber)):
              //  TODO: Call handling
              break
              
            case .challengeRequired(.sms(let phoneNumber)):
              //  TODO: SMS handling
              break
              
            case .failure(error: .delivery):
              //  TODO: Code delivery
              break
              
            case .failure(error: .usernameExists):
              //  TODO: Username exists
              break
              
            case .failure(error: .network):
              //  TODO: Network error
              break
            
            case .failure(error: .unknownChallenge):
              //  TODO: Handle error
              break
            }
          }
        }
      }
    } catch ValidationError.invalidUsername(_) {
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
  
  //  MARK: - Remote procedure calls
  
  /// Performs sign up with the data found in the user interface elements. As the callback, invokes given completion function.
  private func signUp(completion: ((SignUpResult) -> Void)? = nil) {
    signUp(username: self.usernameTextField.text!,
           email: self.emailTextField.text!,
           password: self.passwordTextField.text!,
           completion: completion)
  }
  
  /// Performs sign up with the given username, e-mail address, password. As the callback, invokes given completion function.
  private func signUp(username: String, email: String, password: String, completion: ((SignUpResult) -> Void)? = nil) {
    let userAttributes = [AuthUserAttribute(.email, value: email)]
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
                completion?(.challengeRequired(challenge: .email(emailAddress: emailAddress!)))
                
              case .phone(let phoneNumber):
                completion?(.challengeRequired(challenge: .phone(phoneNumber: phoneNumber!)))
                
              case .sms(let phoneNumber):
                completion?(.challengeRequired(challenge: .sms(phoneNumber: phoneNumber!)))
                
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
              // TODO: Handle e-mail collision case
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
            Logger.shared.log(.controller, .info, "Sign up successful with the challenge.")
            
            completion?(.success)
            
          case .failure(let error):
            Logger.shared.log(.controller, .error, "Error occurred while completing sign up challenge.")
            Logger.shared.log(.controller, .important, error.debugDescription)
            
            switch error {
            case .service(_, _, let error):
              switch error as! AWSCognitoAuthError {
              case .codeMismatch:
                completion?(.failure(error: .mismatch))
                
              default:
                fatalError()
              }
              
            default:
              fatalError()
            }
          }
        }
      }
  }
  
  /// When the users enter the authentication code incorrectly, they can request the code again
  private func resendCode() {
    let username = usernameTextField.text!
    Amplify.Auth.resendSignUpCode(for: username) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let deliveryDetails):
          Logger.shared.log(.controller, .info, "Resend code send to - \(deliveryDetails)")
        case .failure(let error):
          Logger.shared.log(.controller, .error, "Resend code failed with error \(error)")
        }
      }
    }
  }
  
  //  MARK: - Navigation
  
  private func presentMainMenu(sender: Any?) {
    performSegue(withIdentifier: "showMainMenu", sender: sender)
  }
  
  //  MARK: - Interface builder actions
  
  @IBAction func dismissKeyboard(_ sender: UIBarButtonItem) {
    //  Tell all text fields to dismiss their keyboards if open
    textFields.forEach { $0.resignFirstResponder() }
  }
}

extension SignUpTableViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case emailTextField:
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
