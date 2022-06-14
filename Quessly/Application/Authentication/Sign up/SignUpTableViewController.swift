import UIKit
import Amplify

class SignUpTableViewController: UITableViewController {
  @IBOutlet weak var keyboardAccessoryToolbar: UIToolbar!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  
  lazy var emailPredicate: NSPredicate = {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  var loading = false
  
  var textFields: [UITextField] {
    return [emailTextField, passwordTextField, confirmPasswordTextField]
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
      emailTextField.becomeFirstResponder()
    case (0, 1):
      passwordTextField.becomeFirstResponder()
    case (0, 2):
      confirmPasswordTextField.becomeFirstResponder()
    case (1, 0):
      performSignUp()
    default:
      break
    }
  }
  
  //  MARK: - Operations
  
  enum ValidationError: Error {
    case invalidEmail(email: String)
    case invalidPassword(password: String)
    case nonMatchingPasswords
  }
  
  func validateFields() throws {
    /// Validates email address with a regular expression.
    func validateEmail(email: String) -> Bool {
      return emailPredicate.evaluate(with: email)
    }
    
    /// Validates the password if it has a proper length.
    func validatePassword(password: String) -> Bool {
      let length = password.count
      
      //  TODO: Perform more intense password checking
      return length >= 8 && length <= 40
    }
    
    /// Validates that two passwords entered by the user does match.
    func validateMatchingPasswords(password: String,
                                   confirmingPassword: String) -> Bool {
      return password == confirmingPassword
    }
    
    let email = emailTextField.text!
    let password = passwordTextField.text!
    let confirmingPassword = confirmPasswordTextField.text!
    
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
            self.dismiss(animated: true) {
              self.performSegue(withIdentifier: "showMainMenu",
                                sender: self)
            }
          }
        }
      }
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
