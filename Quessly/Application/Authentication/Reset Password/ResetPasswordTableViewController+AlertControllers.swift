import UIKit

extension ResetPasswordTableViewController {
  func presentResetPasswordCodeAlert(completion: ((String?) -> Void)?) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Verification Code",
                                              message: "Enter the verification code you have received with the e-mail.",
                                              preferredStyle: .alert)
      
      let codeTextField = alertController.addTextField {
        $0.keyboardType = .numberPad
        $0.font = UIFont(name: "Menlo", size: 11.0)
        $0.textAlignment = .center
      }
      
      [UIAlertAction(title: "Continue", style: .default) { _ in
        print(alertController.textFields!.first!.text!)
      }, UIAlertAction(title: "Cancel", style: .cancel) { _ in
        self.dismiss(animated: true, completion: nil)
      }].forEach { alertController.addAction($0) }
      
      self.present(alertController, animated: true) {
        if let completion = completion {
          if let code = codeTextField.text, code != "" {
            completion(code)
          } else {
            completion(nil)
          }
        }
      }
    }
  }
  
  func presentSendingIndicatorAlert(completion: (() -> Void)?) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Please wait...",
                                              message: nil,
                                              preferredStyle: .alert)
      
      alertController.addActivityIndicator()
      
      [UIAlertAction(title: "Cancel", style: .cancel)].forEach { alertController.addAction($0) }
      
      self.present(alertController, animated: true, completion: completion)
    }
  }
}
