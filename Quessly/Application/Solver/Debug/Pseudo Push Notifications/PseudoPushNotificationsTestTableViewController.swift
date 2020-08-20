import UIKit

class PseudoPushNotificationsTestTableViewController: UITableViewController {
  //  MARK: - Storyboard outlets
  
  @IBOutlet weak var consentStatusLabel: UILabel!
  @IBOutlet weak var timeIntervalLabel: UILabel!
  
  //  MARK: - Internal data
  
  let session = try! FakeSessionRepository.shared.one(consolidated: false).wait()
  
  //  MARK: - Internal state
  
  var currentTimeInterval: Float = 10 {
    didSet {
      timeIntervalLabel.text = String(format: NSLocalizedString("%.0f seconds", comment: "Push notification time interval"),
                                      currentTimeInterval)
    }
  }
  
  var authorizationStatus: UNAuthorizationStatus? = nil {
    didSet {
      switch authorizationStatus {
      case .authorized:
        consentStatusLabel.text = NSLocalizedString("Authorized", comment: "Authorization status label.")
      case .denied:
        consentStatusLabel.text = NSLocalizedString("Denied", comment: "Authorization status label.")
      case .notDetermined:
        consentStatusLabel.text = NSLocalizedString("Not determined", comment: "Authorization status label.")
      case .provisional:
        consentStatusLabel.text = NSLocalizedString("Provisional", comment: "Authorization status label.")
      case .some(_):
        consentStatusLabel.text = NSLocalizedString("Unknown", comment: "Authorization status label.")
      case .none:
        consentStatusLabel.text = NSLocalizedString("N/A", comment: "Authorization status label.")
      }
    }
  }
  
  //  MARK: - View controller lifecycle methods
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      UserNotificationCenterManager.shared.getAuthorizationStatus { status in
        self.authorizationStatus = status
      }
    }
  }
  
  //  MARK: - Storyboard actions
  
  @IBAction func timeIntervalValueChanged(_ sender: UISlider) {
    currentTimeInterval = sender.value.rounded()
  }
  
  //  MARK: - UITableView delegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 1:
        UserNotificationCenterManager.shared.requestAuthorization()
        
        tableView.deselectRow(at: indexPath, animated: true)
      default:
        break
      }
    case 1:
      switch indexPath.row {
      case 0:
        UserNotificationCenterManager.shared.schedulePushNotification(for: .sessionStart(session: session),
                                                                      after: Double(currentTimeInterval))
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentPushNotificationAddedAlert()
      default:
        break
      }
    default:
      break
    }
  }
}
