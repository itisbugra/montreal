import UIKit

extension SignUpTableViewController {
  //  MARK: - Alerts
  
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
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Invalid password.",
                                                                       comment: "Alert message shown when password is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: nil)
      }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: completion)
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
  
  func presentLoadingAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Signing you in...",
                                                                     comment: "Alert title shown when network event is occuring during sign up."),
                                            message: nil,
                                            preferredStyle: .alert)
    
    alertController.addActivityIndicator()
    
    [UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
      self.loading = false
      self.dismiss(animated: true, completion: nil)
      }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: completion)
  }
}
