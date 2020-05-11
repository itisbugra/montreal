import UIKit

class SessionInformationTableViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.clearsSelectionOnViewWillAppear = true
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 2:
      switch indexPath.row {
      case 0:
        presentLeaveSessionAlert(animated: true) {
          self.performSegue(withIdentifier: "exitToMainMenu",
                            sender: self.tableView)
        }
      default:
        break
      }
    case 3:
      switch indexPath.row {
      case 0:
        dismiss(animated: true, completion: nil)
      default:
        break
      }
    default:
      break
    }
  }
}
