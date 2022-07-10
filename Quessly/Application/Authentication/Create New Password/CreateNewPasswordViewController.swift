import UIKit
import Amplify
import NSLogger

class CreateNewPasswordViewController : UITableViewController {
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  
  var username: String!
  var code: String!
  
  lazy var passwordPredicate: NSPredicate = {
    let regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{10,}$"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  var loading = false
  
  enum ValidationError: Error {
    case invalidPassword(password: String)
    case nonMatchingPasswords
  }
  
  func validateFields() throws {
    func validatePassword(password: String) -> Bool {
      let length = password.count
    
      return length >= 10 && length <= 40 && passwordPredicate.evaluate(with: password)
    }
    
    func validateMatchingPasswords(password: String,
                                   confirmingPassword: String) -> Bool {
      return password == confirmingPassword && passwordPredicate.evaluate(with: password)
    }
    
    let password = passwordTextField.text!
    let confirmPassword = confirmPasswordTextField.text!
    
    guard validatePassword(password: password) else {
      throw ValidationError.invalidPassword(password: password)
    }
    
    guard validateMatchingPasswords(password: password, confirmingPassword: confirmPassword) else {
      throw ValidationError.nonMatchingPasswords
    }
  }
  
  func performChangePassword() {
    do {
      try validateFields()
      
      presentLoadingAlert {
        self.loading = true
        
        Amplify.Auth
          .confirmResetPassword(for: self.username,
                                with: self.passwordTextField.text!,
                                confirmationCode: self.code) { result in
            switch result {
            case .success:
              DispatchQueue.main.async {
                self.dismiss(animated: true) {
                  self.presentResetPasswordSuccessfulAlert {
                    self.dismiss(animated: true) {
                      self.performSegue(withIdentifier: "exitToSignIn", sender: self.tableView)
                    }
                  }
                }
              }
              Logger.shared.log(.controller, .info, "Resetting password was successful.")
              
            case .failure(let error):
              Logger.shared.log(.controller, .error, "Password does not match.")
              Logger.shared.log(.controller, .important, error.errorDescription)
              break
            }
          }
      }
    } catch ValidationError.invalidPassword(_) {
      presentInvalidPasswordAlert(completion: nil)
    } catch ValidationError.nonMatchingPasswords {
      presentNonMatchingPasswordsAlert(completion: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    assert(self.tableView == tableView)
    
    switch indexPath.section {
    case 0:
      self.tableView.deselectRow(at: indexPath, animated: true)
      
    case 1:
      switch indexPath.row {
      case 0:
        self.tableView.deselectRow(at: indexPath, animated: true)
                
        performChangePassword()
        
      default:
        break
      }
      
    default:
      break
    }
  }
}
