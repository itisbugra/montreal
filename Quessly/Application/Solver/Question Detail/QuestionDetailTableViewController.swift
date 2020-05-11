import UIKit

class QuestionDetailTableViewController: UITableViewController {
  var delegate: QuestionDetailTableViewControllerDelegate? = nil
  
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var authorImageView: UIImageView!
  @IBOutlet weak var authorDisplayNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    authorImageView.layer.cornerRadius = authorImageView.frame.height / 2.00
    authorImageView.clipsToBounds = true
  }
}

protocol QuestionDetailTableViewControllerDelegate : class {
  func willDismiss(_ questionDetailTableViewController: QuestionDetailTableViewController)
}
