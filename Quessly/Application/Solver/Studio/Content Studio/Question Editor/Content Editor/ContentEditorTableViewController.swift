import UIKit

class ContentEditorTableViewController: UITableViewController {
  enum Context {
    case question
    case option(index: UInt)
  }
  
  @IBOutlet weak var textView: UITextView!
  
  var context: Context! {
    didSet {
      switch context! {
      case .question:
        navigationItem.title = "Question Content"
      case .option(let index):
        navigationItem.title = "\(index)th Option Content"
      }
    }
  }
  
  //  MARK: - UIView lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 200
    
    textView.inputAccessoryView = toolbarInputAccessoryViewForContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    textView.becomeFirstResponder()
  }
  
  //  MARK: - Actions
  
  @objc func didPressCamera(_ sender: UIBarButtonItem) {
    presentPhotoSourceAlert(animated: true) { source in
      switch source {
      case .some(let source):
        self.presentImagePickerController(photoSource: source,
                                          animated: true,
                                          completion: nil)
      case nil:
        break
      }
    }
  }
  
  @objc func shouldResignFirstResponder(_ sender: Any) {
    textView.resignFirstResponder()
  }
}
