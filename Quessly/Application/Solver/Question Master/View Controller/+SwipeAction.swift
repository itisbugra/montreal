import UIKit

/**
 Adds a swipe action hiding the options of the questions temporarily.
 */
extension QuestionMasterTableViewController {
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    switch indexPath.section {
    case 0:
      return nil
    case 1:
      if visibleOptions.count == 1 {
        return nil
      }
      
      let hideAction = UIContextualAction(style: .destructive, title: "Hide") { (action, view, completion) in
        let (_, option) = self.visibleOptions[indexPath.row]
        
        self.eliminatedOptions.append(option)
        
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        completion(true)
      }
      
      hideAction.image = UIImage(systemName: "eye.slash")
      
      return UISwipeActionsConfiguration(actions: [hideAction])
    default:
      return nil
    }
  }
}
