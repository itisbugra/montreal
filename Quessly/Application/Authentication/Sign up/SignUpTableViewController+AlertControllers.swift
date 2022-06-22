import UIKit

extension SignUpTableViewController {
  //  MARK: - Alerts
  func presentUsernameAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Invalid username.",
                                                                       comment: "Alert message shown when username is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: completion)
  }
  
  func presentInvalidEmailAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Invalid email address.",
                                                                       comment: "Alert message shown when email address is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: completion)
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
  
  func presentInvalidConfirmationCodeAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Invalid confirmation code.",
                                                                       comment: "Alert message shown when confirmation code is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: completion)
  }
  
  func presentLoadingAlert(completion: (() -> Void)?) {
    DispatchQueue.main.async {
      if !self.loading {
        let alertController = UIAlertController(title: NSLocalizedString("Signing you up...",
                                                                         comment: "Alert title shown when network event is occuring during sign up."),
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addActivityIndicator()
        
        [UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
          self.loading = false
          
          self.dismiss(animated: true, completion: nil)
        }].forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true, completion: completion)
      } else {
        completion?()
      }
    }
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
