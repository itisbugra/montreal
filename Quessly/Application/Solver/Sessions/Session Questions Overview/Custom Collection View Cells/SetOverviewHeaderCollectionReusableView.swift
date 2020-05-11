import UIKit

class SetOverviewHeaderCollectionReusableView: UICollectionReusableView {
  static let identifier = "SetOverviewHeader"
  
  @IBOutlet weak var setNameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  var questionSet: QuestionSet! {
    didSet {
      setName = questionSet.name
    }
  }
  
  var setName: String = "" {
    didSet {
      setNameLabel.text = setName.uppercased(with: Locale.init(identifier: "en-US"))
    }
  }
  
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
    //  TODO: Needs localization
    return "\(marked) have been marked, \(inspected) need to be inspected."
  }
  
  private var subtitle: String {
    //  TODO: Needs localization
    return "\(notSeen) questions have not been seen."
  }
}
