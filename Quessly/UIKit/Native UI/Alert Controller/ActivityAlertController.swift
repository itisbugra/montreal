import UIKit

class ActivityAlertController: UIViewController {
  static private let nibName = "ActivityAlertController"
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
  @IBOutlet weak var titleLabel: UILabel?
  @IBOutlet weak var subtitleLabel: UILabel?
  
  init(title: String, subtitle: String) {
    super.init(nibName: Self.nibName, bundle: nil)
    
    self.title = title
    self.subtitle = subtitle
    self.transitioningDelegate = self
    self.modalPresentationStyle = .custom
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override var title: String? {
    didSet {
      guard let label = titleLabel else {
        return
      }
      
      label.text = title
    }
  }
  
  var subtitle: String? {
    didSet {
      guard let label = subtitleLabel else {
        return
      }
      
      label.text = title
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let constraint = contentView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.6)
    
    constraint.priority = .required
    constraint.isActive = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    titleLabel?.text = title
    subtitleLabel?.text = subtitle
  }
}

extension ActivityAlertController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return ActivityAlertControllerPresentationController(presentedViewController: presented,
                                                         presenting: presenting)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ActivityAlertControllerPresentAnimatedTransitioning()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ActivityAlertControllerDismissAnimatedTransitioning()
  }
}
