import UIKit
import Amplify
import AWSMobileClient

class SignUpTableViewController: UITableViewController {
  @IBOutlet weak var keyboardAccessoryToolbar: UIToolbar!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var confirmationCode: UITextField!
  
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
  
  var loading = false
  
  var textFields: [UITextField] {
    return [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField, confirmationCode]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //  Set input accessory of each text field
    textFields.forEach { $0.inputAccessoryView = keyboardAccessoryToolbar }
  }
  
  var hasMatchingPasswords: Bool {
    return passwordTextField.text! == confirmPasswordTextField.text!
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
      
    case (0, 4):
      confirmationCode.becomeFirstResponder()
      
    case (1, 0):
      performSignUp()
      
    case (2, 0):
      guard
        let username = usernameTextField.text,
        let confirmationCode = confirmationCode.text else {
        return
      }
//      guard let username = usernameTextField.text else { return }
//      guard let confirmationCode = confirmationCode.text else { return }
      
      confirmationCodeSignUp(for: username, with: confirmationCode)
      
      //        DispatchQueue.main.async {
      //          self.showMainMenu(sender: self.tableView)
      //      }
      performConfirmationCode()
      
    default:
      break
    }
  }
  
  func confirmationCodeSignUp(for username: String, with confirmationCode: String) {
    Amplify.Auth
      .confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
        switch result {
        case .success:
          print("Confirm signUp succeeded")
        case .failure(let error):
          print("An error occurred while confirming sign up \(error)")
        }
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
    case invalidConfirmationCode(confirmationCode: String)
  }
  
  func validateConfirmationCodeField() throws {
    func validateConfirmationCode(confirmationCode: String) -> Bool {
      let length = confirmationCode.count
      
      return length == 6
    }
    
    let confirmationCode = confirmationCode.text!
    
    guard validateConfirmationCode(confirmationCode: confirmationCode) else {
      throw ValidationError.invalidConfirmationCode(confirmationCode: confirmationCode)
    }
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
  
  func performSignUp() {
    do {
      try validateFields()
      
      presentLoadingAlert {
        self.loading = true
        
        Timer.scheduledTimer(withTimeInterval: 3,
                             repeats: false) { _ in
          if self.loading {
            self.dismiss(animated: true)
          }
        }
        
        guard
          let username = self.usernameTextField.text,
          let email = self.emailTextField.text,
          let password = self.passwordTextField.text else {
          return
        }
        
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        Amplify.Auth
          .signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
              if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails))")
              } else {
                // TODO: Delivery not needed.
              }
            case .failure(let error):
              print("An error occurred while registering a user \(error)")
              
              self.presentInvalidPasswordAlert(completion: nil)
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
  
  func performConfirmationCode() {
    do {
      try validateConfirmationCodeField()
      
      presentLoadingAlert {
        self.loading = true
        
        Timer.scheduledTimer(withTimeInterval: 3,
                             repeats: false) { _ in
          if self.loading {
            self.dismiss(animated: true) {
              self.performSegue(withIdentifier: "showMainMenu",
                                sender: self)
            }
          }
        }
      }
    } catch ValidationError.invalidConfirmationCode {
      presentInvalidConfirmationCodeAlert(completion: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
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
