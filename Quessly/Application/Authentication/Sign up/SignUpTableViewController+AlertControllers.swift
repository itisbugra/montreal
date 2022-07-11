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
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Invalid password.",
                                                                       comment: "Alert message shown when password is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: completion)
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
  
  func presentInvalidConfirmationCodeAlert(completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Invalid confirmation code.",
                                                                       comment: "Alert message shown when confirmation code is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: completion)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: nil)
  }
  
  func presentLoadingAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Signing you up...",
                                                                     comment: "Alert title shown when network event is occuring during sign up."),
                                            message: nil,
                                            preferredStyle: .alert)
    
    alertController.addActivityIndicator()
    
    [UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
      
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: completion)
  }
  
  enum ConfirmationCodeAlertActionResult {
    case code(_ code: String)
    case resend
    case cancel
  }
  
  func presentConfirmationCodeAlert(destination: String, completion: ((ConfirmationCodeAlertActionResult) -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Verification Code", comment: ""),
                                            message: NSLocalizedString("Enter the verification code you have received with the e-mail.", comment: ""),
                                            preferredStyle: .alert)
    
    let codeTextField = alertController.addTextField {
      $0.keyboardType = .numberPad
      $0.font = .monospacedSystemFont(ofSize: 11.0, weight: .regular)
      $0.textAlignment = .center
      $0.clearButtonMode = .whileEditing
    }
    
    [UIAlertAction(title: NSLocalizedString("Continue", comment: ""),
                   style: .default) { _ in
      completion?(.code(codeTextField.text!))
    }, UIAlertAction(title: NSLocalizedString("Resend code", comment: ""),
                     style: .default) { _ in
      completion?(.resend)
    }, UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                     style: .cancel) { _ in
      completion?(.cancel)
    }].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true)
  }
}
