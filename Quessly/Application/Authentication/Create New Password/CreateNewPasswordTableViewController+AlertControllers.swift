import UIKit

extension CreateNewPasswordViewController {
  func presentLoadingAlert(completion: (() -> Void)?) {
    DispatchQueue.main.async {
      if !self.loading {
        let alertController = UIAlertController(title: NSLocalizedString("Resetting password...", comment: ""),
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addActivityIndicator()

        self.present(alertController, animated: true, completion: completion)
      } else {
        completion?()
      }
    }
  }
  
  func presentResetPasswordSuccessfulAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Reset Password", comment: ""),
                                            message: "Your password has been successfully reset, now you can sign in with your new credentials.",
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: completion)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true)
  }
  
  func presentInvalidPasswordAlert(completion: (() -> Void)?) {
    DispatchQueue.main.async {
      self.dismissLoadingAlert {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                                message: NSLocalizedString("Invalid password.",
                                                                           comment: "Alert message shown when password is invalid during sign up."),
                                                preferredStyle: .alert)
        
        [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
          self.dismiss(animated: true, completion: nil)
        }].forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true, completion: completion)
      }
    }
  }
  
  func presentNonMatchingPasswordsAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Passwords do not match.",
                                                                       comment: "Alert message shown when passwords do not match during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: completion)
  }
  
  func dismissLoadingAlert(completion: (() -> Void)?) {
    if loading {
      self.dismiss(animated: true) {
        self.loading = false
        
        completion?()
      }
    } else {
      completion?()
    }
  }
}
