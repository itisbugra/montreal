import UIKit

extension UpcomingSessionTableViewController {
  //  MARK: - Alerts
  
  func presentEnrollSessionAlert(animated: Bool,
                                 completion: @escaping () -> Void) {
    let alertController = UIAlertController(title: "Are you sure you want to enroll this session?",
                                            message: "When you enroll to a session, your schedule will be managed accordingly, however you will not be able to join consecutive sessions in that time slice.",
                                            preferredStyle: .actionSheet)
    let actions = [
      UIAlertAction(title: "Enroll Session", style: .default) { _ in
        completion()
      },
      UIAlertAction(title: "Cancel", style: .cancel)
    ]
    
    actions.forEach { alertController.addAction($0) }
    
    present(alertController,
            animated: animated,
            completion: nil)
  }
}
