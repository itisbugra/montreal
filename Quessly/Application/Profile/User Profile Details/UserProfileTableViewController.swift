import UIKit
import FontAwesome_swift

/**
 Shows details of the user profile.
 
 - SeeAlso: MainMenuTableViewController
 */
class UserProfileTableViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UserProfileTableViewControllerVersionCopyrightFooterView.self,
                       forHeaderFooterViewReuseIdentifier: UserProfileTableViewControllerVersionCopyrightFooterView.identifier)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
  }
  
  //  MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 1
    case 2:
      return 2
    case 3:
      return 2
    default:
      fatalError("Section is not supported.")
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewControllerProfileTableViewCell.identifier, for: indexPath)
      
      return cell
    case (1, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewControllerImageTableViewCell.identifier, for: indexPath)
      
      cell.textLabel!.text = "Manage Devices"
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = .systemGreen
      cell.imageView?.image = UIImage(systemName: "desktopcomputer")
      
      return cell
    case (2, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewControllerImageTableViewCell.identifier, for: indexPath)
      
      cell.textLabel!.text = "Account"
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = .systemBlue
      cell.imageView?.image = .fontAwesomeIcon(name: .key, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))
      
      return cell
    case (2, 1):
      let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewControllerImageTableViewCell.identifier, for: indexPath)
      
      cell.textLabel!.text = "Notifications"
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = .systemRed
      cell.imageView?.image = UIImage(systemName: "app.badge")
      
      return cell
    case (3, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewControllerImageTableViewCell.identifier, for: indexPath)
      
      cell.textLabel!.text = "Help"
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = .systemBlue
      cell.imageView?.image = UIImage(systemName: "info")
      
      return cell
    case (3, 1):
      let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewControllerImageTableViewCell.identifier, for: indexPath)
      
      cell.textLabel!.text = "Suggest To Your Friend"
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = .systemRed
      cell.imageView?.image = UIImage(systemName: "heart.fill")
      
      return cell
    default:
      fatalError("Index path is not supported.")
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let sectionCount = tableView.numberOfSections
    
    switch section {
    case sectionCount - 1:
      let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserProfileTableViewControllerVersionCopyrightFooterView.identifier) as! UserProfileTableViewControllerVersionCopyrightFooterView
      
      return headerFooterView
    default:
      return nil
    }
  }
  
  //  MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      return UserProfileTableViewControllerProfileTableViewCell.height
    case (1, 0):
      fallthrough
    case (2, 0):
      fallthrough
    case (2, 1):
      fallthrough
    case (3, 0):
      fallthrough
    case (3, 1):
      return UserProfileTableViewControllerImageTableViewCell.height
    default:
      fatalError("Index path is not supported.")
    }
  }
}
