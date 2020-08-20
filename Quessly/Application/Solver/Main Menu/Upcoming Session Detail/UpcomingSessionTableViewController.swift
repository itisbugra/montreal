import UIKit

class UpcomingSessionTableViewController: UITableViewController {
  //  MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 3:
      switch indexPath.row {
      case 0:
        presentEnrollSessionAlert(animated: true) {
          self.performSegue(withIdentifier: "exitToMainMenuAfterEnrollment",
                            sender: self)
        }
      default:
        break
      }
    default:
      break
    }
  }
}
