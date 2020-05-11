import UIKit

class SessionQuestionsOverviewNavigationBarTitleView: UIView {
  static let nibName = "SessionQuestionsOverviewNavigationBarTitleView"
  static let contentSize = CGSize(width: 250, height: 60)
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var timeRemainingLabel: UILabel!
  @IBOutlet weak var linkLabel: UILabel!
  
  var tapGestureRecognizer: UITapGestureRecognizer?
  weak var delegate: SessionQuestionsOverviewNavigationBarTitleViewDelegate? {
    didSet {
      if delegate != nil {
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(tapped(_:)))
        
        addGestureRecognizer(tapGestureRecognizer!)
      } else {
        removeGestureRecognizer(tapGestureRecognizer!)
      }
      
      isUserInteractionEnabled = delegate != nil
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }
  
  private func sharedInit() {
    Bundle.main.loadNibNamed(SessionQuestionsOverviewNavigationBarTitleView.nibName,
                             owner: self,
                             options: nil)
    
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    translatesAutoresizingMaskIntoConstraints = false
    isUserInteractionEnabled = true
  }
  
  override var intrinsicContentSize: CGSize {
    return SessionQuestionsOverviewNavigationBarTitleView.contentSize
  }
  
  @objc func tapped(_ gestureRecognizer: UIGestureRecognizer) {
    delegate!.titleViewSelected(self)
  }
  
  func startAnimating() {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
      UIView.animate(withDuration: 1.50, animations: {
        self.timeRemainingLabel.alpha = 0
      }) { _ in
        UIView.animate(withDuration: 1.50, animations: {
          self.linkLabel.alpha = 1
        }) { _ in
          DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            UIView.animate(withDuration: 1.50, animations: {
              self.linkLabel.alpha = 0
            }) { _ in
              UIView.animate(withDuration: 1.50, animations: {
                self.timeRemainingLabel.alpha = 1
              })
            }
          }
        }
      }
    }
  }
}

protocol SessionQuestionsOverviewNavigationBarTitleViewDelegate : class {
  func titleViewSelected(_ titleView: SessionQuestionsOverviewNavigationBarTitleView)
}
