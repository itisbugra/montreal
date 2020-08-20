import UIKit

extension OngoingSessionTableViewController {
  //  MARK: - Alerts
  
  func presentSessionContentDownloadingAlert(animated: Bool, completion: (() -> Void)? = nil) {
    let alertController = ActivityAlertController(title: "Downloading...",
                                                  subtitle: "The session content is being downloaded, it will be ready soon.")
    
    present(alertController, animated: true) {
      if let completion = completion {
        completion()
      }
    }
  }
}
