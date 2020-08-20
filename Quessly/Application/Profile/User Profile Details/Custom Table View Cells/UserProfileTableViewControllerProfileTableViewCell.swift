import UIKit

class UserProfileTableViewControllerProfileTableViewCell: UITableViewCell {
  static let identifier = "Profile"
  static let height: CGFloat = 80.00
  
  @IBOutlet weak var profilePictureImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2.00
    profilePictureImageView.clipsToBounds = true
  }
}
