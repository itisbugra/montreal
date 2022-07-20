import UIKit
import Amplify
import AmplifyPlugins
import NSLogger

class ResetPasswordTableViewController: UITableViewController {
//  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var extraAttributeTextField: UITextField!
  
  private var code: String!
  
  enum ValidationError: Error {
    case invalidEmail(email: String)
  }
  
  lazy var emailPredicate: NSPredicate = {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    return NSPredicate(format: "SELF MATCHES %@", regex)
  }()
  
  
  func validateField() throws {
    
    func validaEmail(email: String) -> Bool {
      return emailPredicate.evaluate(with: email)
    }
    let extraAttribute = extraAttributeTextField.text!
    
    guard validaEmail(email: extraAttribute) else {
      throw ValidationError.invalidEmail(email: extraAttribute)
    }
  }
  
  //  MARK: - View controller lifecycle
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.extraAttributeTextField.becomeFirstResponder()
  }
  
  //  MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    assert(self.tableView == tableView)
    
    switch indexPath.section {
    case 0:
      self.tableView.deselectRow(at: indexPath, animated: true)
      
      switch indexPath.row {
      case 0:
        self.extraAttributeTextField.becomeFirstResponder()
        
      default:
        break
      }
      
    case 1:
      switch indexPath.row {
      case 0:
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performResetPassword()
        
      default:
        break
      }
      
    default:
      break
    }
  }
  
  
  //  MARK: - Actions
  
  private func performResetPassword() {
//    DispatchQueue.main.async {
//      let extraAttribute = self.extraAttributeTextField.text!
//
//      if extraAttribute.isEmpty {
//        self.checkExtraAttribute {
//          return
//        }
//      }
//
//      self.performResetPassword(username: extraAttribute)
//    }
    let extraAttribute = self.extraAttributeTextField.text!

    do {
      try self.validateField()
      
    } catch ValidationError.invalidEmail(_) {
      self.checkExtraAttribute(completion: nil)
    } catch {
      Logger.shared.log(.controller, .error, "Unexpected state for resetting password.")
    }
    self.performResetPassword(extraAttribute: extraAttribute)
  }
  
  private func performResetPassword(extraAttribute: String) {
    self.presentSendingIndicatorAlert {
      Amplify.Auth
        .resetPassword(for: extraAttribute) { result in
          do {
            try self.validateField()
            
            let resetResult = try result.get()
            
            switch resetResult.nextStep {
            case .confirmResetPasswordWithCode(let deliveryDetails, _):
              switch deliveryDetails.destination {
              case .email(let emailAddress):
                DispatchQueue.main.async {
                  self.dismiss(animated: true) {
                    self.presentResetPasswordCodeAlert(destination: emailAddress!) { code in
                      guard let code = code else {
                        //  TODO: Show an error that the code was not available at the input field.
                        
                        return
                      }
                      
                      self.code = code
                      
                      self.performSegue(withIdentifier: "showCreatePassword", sender: self.tableView)
                    }
                  }
                }
                
              default:
                Logger.shared.log(.controller, .error, "Password reset code destination not supported.")
              }
              
            default:
              Logger.shared.log(.controller, .error, "Unexpected state for resetting password.")
            }
          } catch {
            Logger.shared.log(.controller, .error, "Reset password failed with error. \(error)")
          }
        }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showCreatePassword":
      let destination = segue.destination as! CreateNewPasswordViewController
      
      destination.extraAttribute = self.extraAttributeTextField.text!
      destination.code = self.code
      
    default:
      break
    }
  }
}

extension ResetPasswordTableViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.text!.isEmpty {
      return false
    }
    
    self.performResetPassword()
    
    return true
  }
}
