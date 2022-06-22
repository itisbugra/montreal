import UIKit
import Amplify

class ResetPasswordTableViewController: UITableViewController {
  @IBOutlet weak var usernameTextField: UITextField!
  
  //  MARK: - View controller lifecycle
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.usernameTextField.becomeFirstResponder()
  }
  
  //  MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    assert(self.tableView == tableView)

    switch indexPath.section {
    case 0:
      self.tableView.deselectRow(at: indexPath, animated: true)
      
      switch indexPath.row {
      case 0:
        self.usernameTextField.becomeFirstResponder()
        
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
    DispatchQueue.main.async {
      let username = self.usernameTextField.text!
      
      if username.isEmpty {
        return
      }
      
      self.performResetPassword(username: username)
    }
  }
  
  private func performResetPassword(username: String) {
    self.presentSendingIndicatorAlert {
      Amplify.Auth
        .resetPassword(for: username) { result in
          do {
            let resetResult = try result.get()
            
            switch resetResult.nextStep {
            case .confirmResetPasswordWithCode(let deliveryDetails, let info):
              print("confirm reset password with code send to - \(deliveryDetails) \(info)")
              
              DispatchQueue.main.async {
                self.dismiss(animated: true) {
                  self.presentResetPasswordCodeAlert { code in
                    print(code)
                    
                    self.performSegue(withIdentifier: "showCreatePassword",
                                      sender: self.tableView)
                  }
                }
              }
              
            case .done:
              print("Reset completed")
            }
          } catch {
            print("Reset password failed with error \(error)")
          }
        }
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
