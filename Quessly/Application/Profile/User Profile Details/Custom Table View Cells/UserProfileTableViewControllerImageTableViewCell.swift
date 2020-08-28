import UIKit
import Static

class UserProfileTableViewControllerImageTableViewCell: UITableViewCell, Cell {
  enum Context: String {
    case tintColor
    case image
  }
  
  static func nib() -> UINib? {
    return UINib(nibName: "UserProfileTableViewControllerImageTableViewCell", bundle: .main)
  }
  
  @IBOutlet weak var iconImageViewContainerView: UIView!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override var textLabel: UILabel? {
    return titleLabel
  }
  
  override var tintColor: UIColor! {
    didSet {
      iconImageViewContainerView.backgroundColor = tintColor
    }
  }
  
  override var imageView: UIImageView? {
    return iconImageView
  }
  
  func configure(row: Row) {
    textLabel?.text = row.text
    tintColor = (row.context![Context.tintColor.rawValue]! as! UIColor)
    iconImageView.image = (row.context![Context.image.rawValue]! as! UIImage)
  }
}
