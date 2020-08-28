import UIKit
import Static

class UserProfileTableViewControllerProfileTableViewCell: UITableViewCell, Cell {
  static func nib() -> UINib? {
    return UINib(nibName: "UserProfileTableViewControllerProfileTableViewCell", bundle: .main)
  }
  
  @IBOutlet weak var profilePictureImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2.00
    profilePictureImageView.clipsToBounds = true
  }
  
  func configure(row: Row) {
    
  }
}
