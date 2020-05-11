import UIKit

extension SessionInformationTableViewController {
  //  MARK: - Alerts
  
  func presentLeaveSessionAlert(animated: Bool,
                                completion: @escaping () -> Void) {
    let alertController = UIAlertController(title: "Are you sure you want to leave the session?",
                                            message: "When you leave a session, you will not be able to join it anymore.",
                                            preferredStyle: .actionSheet)
    
    alertController.addAction(UIAlertAction(title: "Leave Session",
                                            style: .destructive,
                                            handler: { _ in
                                              completion()
    }))
    
    alertController.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
    
    present(alertController,
            animated: animated,
            completion: nil)
  }
}
