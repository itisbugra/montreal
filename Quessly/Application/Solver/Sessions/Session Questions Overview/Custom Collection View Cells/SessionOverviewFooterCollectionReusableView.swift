import UIKit

class SessionOverviewFooterCollectionReusableView: UICollectionReusableView {
  static let identifier = "SessionOverviewFooter"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  var marked: Int = 0 {
    didSet {
      titleLabel.text = title
    }
  }
  
  var inspected: Int = 0 {
    didSet {
      titleLabel.text = title
    }
  }
  
  var notSeen: Int = 0 {
    didSet {
      subtitleLabel.text = subtitle
    }
  }
  
  private var title: String {
    return "\(marked) have been marked, \(inspected) need to be inspected."
  }
  
  private var subtitle: String {
    return "\(notSeen) questions have not been seen."
  }
}
