import UIKit
import FontAwesome_swift
import Static

/**
 Shows details of the user profile.
 
 - SeeAlso: MainMenuTableViewController
 */
class UserProfileTableViewController: TableViewController {
  convenience init() {
    self.init(style: .grouped)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    
    dataSource.sections = [
      Section(rows: [
        Row(cellClass: UserProfileTableViewControllerProfileTableViewCell.self),
      ]),
      Section(rows: [
        Row(text: "Manage Devices",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemGreen, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "desktopcomputer")!]),
      ]),
      Section(rows: [
        Row(text: "Account",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemBlue, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage.fontAwesomeIcon(name: .key, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))]),
        Row(text: "Notifications",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemRed, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "app.badge")!])
      ]),
      Section(rows: [
        Row(text: "Help",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemBlue, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "info")!]),
        Row(text: "Suggest To Your Friend",
            accessory: .disclosureIndicator,
            cellClass: UserProfileTableViewControllerImageTableViewCell.self,
            context: [UserProfileTableViewControllerImageTableViewCell.Context.tintColor.rawValue: UIColor.systemRed, UserProfileTableViewControllerImageTableViewCell.Context.image.rawValue: UIImage(systemName: "heart.fill")!])
      ])
    ]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    title = "Profile"
    
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
    tableView.backgroundColor = .systemGroupedBackground
  }
}

extension UserProfileTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      return 80
    default:
      return 43.5
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let sectionCount = tableView.numberOfSections
    
    return section == sectionCount - 1 ? (UINib(nibName: "UserProfileTableViewControllerVersionCopyrightFooterView", bundle: .main).instantiate(withOwner: self, options: nil)[0] as! UIView) : nil
  }
}
