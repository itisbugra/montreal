import UIKit

extension UpcomingSessionTableViewController {
  //  MARK: - Alerts
  
  func presentEnrollSessionAlert(animated: Bool,
                                 completion: @escaping () -> Void) {
    let alertController = UIAlertController(title: NSLocalizedString("Are you sure you want to enroll this session?",
                                                                     comment: "Prompt title for enrolling to the session."),
                                            message: NSLocalizedString("When you enroll to a session, your schedule will be managed accordingly, however you will not be able to join consecutive sessions in that time slice.",
                                                                       comment: "Prompt subtitle for enrolling to the session."),
                                            preferredStyle: .actionSheet)
    let actions = [
      UIAlertAction(title: NSLocalizedString("Enroll Session", comment: "Alert button."), style: .default) { _ in
        completion()
      },
      UIAlertAction(title: NSLocalizedString("Cancel", comment: "Alert button."), style: .cancel)
    ]
    
    actions.forEach { alertController.addAction($0) }
    
    present(alertController,
            animated: animated,
            completion: nil)
  }
}
