import UIKit

extension SignUpTableViewController {
  //  MARK: - Alerts
  /// Warning shown when users enter an invalid username
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
  /// Warning shown when users enter an invalid email address
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
  
  /// Warning shown when users enter an invalid password
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
  
  /// User's password non matching alert
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
  
  /// Users entered wrong confirmation code
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
  
  /// Warning displayed to prevent users from accidentally exiting the sign up screen
  func presentDiscardInformationSignUpAlert(completion: ((Bool) -> Void)? = nil) {
    let alertController = UIAlertController(title: nil,
                                            message: NSLocalizedString("Are you sure you want to discard this information?", comment: ""),
                                            preferredStyle: .actionSheet)
    
    [
      UIAlertAction(title: NSLocalizedString("Discard Changes", comment: ""), style: .destructive) { _ in
        completion?(true)
      },
      UIAlertAction(title: NSLocalizedString("Keep Editing", comment: ""), style: .cancel) { _ in
        completion?(false)
      }
    ].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  /// Username exist alert
  func presentUsernameExistsAlert(completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Username exists.",
                                                                       comment: "Alert message shown when confirmation code is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: completion)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: nil)
  }
  
  /// Email exist alert
  func presentEmailExistsAlert(completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Email exists.",
                                                                       comment: "Alert message shown when confirmation code is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: completion)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: nil)
  }
  
  /// Users have 3 attempts, if they try more than 3 times they will get an error
  func presentOutOfTriesAlert(completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                            message: NSLocalizedString("Out of tries, you have 3 attempts",
                                                                       comment: "Alert message shown when confirmation code is invalid during sign up."),
                                            preferredStyle: .alert)
    
    [UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
      self.dismiss(animated: true, completion: completion)
    }].forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: nil)
  }
  
  enum ConfirmationCodeAlertActionResult {
    case code(_ code: String)
    case resend
    case cancel
  }
  
  func presentConfirmationCodeAlert(for challenge: Challenge, completion: ((ConfirmationCodeAlertActionResult) -> Void)?) {
    switch challenge {
    case .email(let emailAddress):
      self.presentConfirmationCodeAlert(destination: emailAddress,
                                        message: NSLocalizedString("Enter the verification code you have received with the e-mail.", comment: ""),
                                        completion: completion)
      
    case .phone(let phoneNumber):
      self.presentConfirmationCodeAlert(destination: phoneNumber,
                                        message: NSLocalizedString("Enter the verification code you have received with the call.", comment: ""),
                                        completion: completion)
      
    case .sms(let phoneNumber):
      self.presentConfirmationCodeAlert(destination: phoneNumber,
                                        message: NSLocalizedString("Enter the verification code you have received with the SMS message.", comment: ""),
                                        completion: completion)
    }
  }
  
  fileprivate func presentConfirmationCodeAlert(destination: String, message: String, completion: ((ConfirmationCodeAlertActionResult) -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Verification Code", comment: ""),
                                            message: message,
                                            preferredStyle: .alert)
    
    let codeTextField = alertController.addTextField {
      $0.keyboardType = .numberPad
      $0.font = .monospacedSystemFont(ofSize: 11.0, weight: .regular)
      $0.textAlignment = .center
      $0.clearButtonMode = .whileEditing
      $0.textContentType = .oneTimeCode
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
