import UIKit

/**
 Shows details of the user profile.
 
 - SeeAlso: MainMenuTableViewController
 */
class UserProfileDetailTableViewController: UITableViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.layer.cornerRadius = imageView.frame.height / 2.00
    imageView.clipsToBounds = true
  }
}
