import UIKit

extension UIAlertController {
  static func loading(title: String?,
                      message: String?,
                      withActivityIndicator: Bool = true) -> UIAlertController {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    
    alertController.addActivityIndicator()
    
    return alertController
  }
}
