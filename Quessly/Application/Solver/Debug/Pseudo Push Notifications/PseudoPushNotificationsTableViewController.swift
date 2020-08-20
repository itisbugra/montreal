import UIKit

class PseudoPushNotificationsTestTableViewController: UITableViewController {
  //  MARK: - Storyboard outlets
  
  @IBOutlet weak var timeIntervalLabel: UILabel!
  
  //  MARK: - Internal data
  
  let session = try! FakeSessionRepository.shared.one(consolidated: false).wait()
  
  //  MARK: - Internal state
  
  var currentTimeInterval: Float = 5 {
    didSet {
      timeIntervalLabel.text = String(format: NSLocalizedString("%f seconds", comment: "Push notification time interval"),
                                      currentTimeInterval)
    }
  }
  
  //  MARK: - Storyboard actions
  
  @IBAction func timeIntervalValueChanged(_ sender: UISlider) {
    currentTimeInterval = sender.value
  }
  
  //  MARK: - UITableView delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      switch indexPath.row {
      case 0:
        UserNotificationCenterManager.shared.schedulePushNotification(for: .sessionStart(session: session),
                                                                      after: 5)
      default:
        break
      }
    default:
      break
    }
  }
}
