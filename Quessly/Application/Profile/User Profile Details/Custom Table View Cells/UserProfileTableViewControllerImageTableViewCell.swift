import UIKit

class UserProfileTableViewControllerImageTableViewCell: UITableViewCell {
  static let identifier = "Image"
  static let height: CGFloat = 43.50
  
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
}
