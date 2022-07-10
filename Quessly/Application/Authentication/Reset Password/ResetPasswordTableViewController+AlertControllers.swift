import UIKit

extension ResetPasswordTableViewController {
  func presentResetPasswordCodeAlert(destination emailAddress: String, completion: ((String?) -> Void)?) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: NSLocalizedString("Verification Code", comment: ""),
                                              message: NSLocalizedString("Enter the verification code you have received with the e-mail \(emailAddress).", comment: ""),
                                              preferredStyle: .alert)
      
      let codeTextField = alertController.addTextField {
        $0.keyboardType = .numberPad
        $0.font = .monospacedSystemFont(ofSize: 11.0, weight: .regular)
        $0.textAlignment = .center
        $0.clearButtonMode = .whileEditing
      }
      
      [UIAlertAction(title: NSLocalizedString("Continue", comment: ""),
                     style: .default) { _ in
        if let completion = completion {
          if let code = codeTextField.text, code != "" {
            completion(code)
          } else {
            completion(nil)
          }
        }
      }, UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                       style: .cancel) { _ in
        self.dismiss(animated: true, completion: nil)
      }].forEach { alertController.addAction($0) }
      
      self.present(alertController, animated: true)
    }
  }
  
  func checkUsername(completion: (() -> Void)?) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                              message: NSLocalizedString("Wrong username, please enter correct username.", comment: ""),
                                              preferredStyle: .alert)
      
      [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel)].forEach { alertController.addAction($0) }
      
      self.present(alertController, animated: true, completion: completion)
    }
  }
  
  func presentSendingIndicatorAlert(completion: (() -> Void)?) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: NSLocalizedString("Please wait...", comment: ""),
                                              message: NSLocalizedString("Sending a verification code to your e-mail address.", comment: ""),
                                              preferredStyle: .alert)
      
      alertController.addActivityIndicator()
      
      [UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)].forEach { alertController.addAction($0) }
      
      self.present(alertController, animated: true, completion: completion)
    }
  }
  
  func redirectPasswordResetAlert(completion : (() -> Void)?) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: NSLocalizedString("Redirecting to reset password", comment: ""),
                                              message: NSLocalizedString("Redirecting to reset your password", comment: ""),
                                              preferredStyle: .alert)
      
      alertController.addActivityIndicator()
      
      [UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                     style: .cancel)].forEach { alertController.addAction($0) }
      
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
