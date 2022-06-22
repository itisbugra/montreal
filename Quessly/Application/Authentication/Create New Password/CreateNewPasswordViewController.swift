import UIKit

class CreateNewPasswordViewController : UITableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    assert(self.tableView == tableView)
    
    switch indexPath.section {
    case 0:
      self.tableView.deselectRow(at: indexPath, animated: true)
      
    case 1:
      switch indexPath.row {
      case 0:
        self.performSegue(withIdentifier: "exitToSignIn", sender: self.tableView)
        
      default:
        break
      }
      
    default:
      break
    }
  }
}
