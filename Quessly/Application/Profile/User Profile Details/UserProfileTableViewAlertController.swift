import UIKit

extension UserProfileTableViewController {
  // MARK: - Alerts
  
  func presentSignOutAlert(completion: ((Bool) -> Void)? = nil) {
    let alertController = UIAlertController(title: nil,
                                            message: NSLocalizedString("Sign out of this device?", comment: ""),
                                            preferredStyle: .actionSheet)
    
    [
      UIAlertAction(title: NSLocalizedString("Sign Out", comment: ""), style: .destructive) { _ in
        completion?(true)
      },
      UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        completion?(false)
      }
    ].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func presentRememberDeviceAlert(completion: ((Bool) -> Void)? = nil) {
    let alertController = UIAlertController(title: nil,
                                            message: NSLocalizedString("Remember this device?", comment: ""),
                                            preferredStyle: .actionSheet)
    
    [
      UIAlertAction(title: NSLocalizedString("Remember", comment: ""), style: .default) { _ in
        completion?(true)
      },
      UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        completion?(false)
      }
    ].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func presentForgetDeviceAlert(completion: ((Bool) -> Void)? = nil) {
    let alertController = UIAlertController(title: nil,
                                            message: NSLocalizedString("Forget this device?", comment: ""),
                                            preferredStyle: .actionSheet)
    
    [
      UIAlertAction(title: NSLocalizedString("Forget", comment: ""), style: .destructive) { _ in
        completion?(true)
      },
      UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        completion?(false)
      }
    ].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: nil)
  }
  
}
