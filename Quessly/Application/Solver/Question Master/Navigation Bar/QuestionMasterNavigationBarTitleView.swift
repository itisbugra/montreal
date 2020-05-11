import UIKit

class QuestionMasterNavigationBarTitleView: UIView {
  static let nibName = "QuestionMasterNavigationBarTitleView"
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var contextLabel: UILabel!
  @IBOutlet weak var identifierLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    Bundle.main.loadNibNamed(QuestionMasterNavigationBarTitleView.nibName,
                             owner: self,
                             options: nil)
    
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    Bundle.main.loadNibNamed(QuestionMasterNavigationBarTitleView.nibName,
                             owner: self,
                             options: nil)
    
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    translatesAutoresizingMaskIntoConstraints = false
  }
}
