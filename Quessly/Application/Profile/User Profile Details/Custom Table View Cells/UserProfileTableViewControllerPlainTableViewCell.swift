import UIKit

class UserProfileTableViewControllerPlainTableViewCell: UITableViewCell {
  static let identifier = "Plain"
  static let height: CGFloat = 43.50
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override var textLabel: UILabel? {
    return titleLabel
  }
}
