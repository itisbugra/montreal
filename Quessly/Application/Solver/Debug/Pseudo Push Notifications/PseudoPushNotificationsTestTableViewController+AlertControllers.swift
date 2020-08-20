import UIKit

extension PseudoPushNotificationsTestTableViewController {
  //  MARK: - Alerts
  
  func presentPushNotificationAddedAlert() {
    let alertController = UIAlertController(title: NSLocalizedString("Push Notification Added", comment: "Alert title when push notification is added"),
                                            message: NSLocalizedString("Make the application running in background to observe the push notification.", comment: "Alert message when push notification is added."),
                                            preferredStyle: .alert)
    let actions = [
      UIAlertAction(title: NSLocalizedString("OK", comment: "Default action on alert when push notification is addded"),
                    style: .default) { _ in
                      self.dismiss(animated: true, completion: nil)
      }
    ]
    
    actions.forEach { alertController.addAction($0) }
    
    present(alertController, animated: true, completion: nil)
  }
}
