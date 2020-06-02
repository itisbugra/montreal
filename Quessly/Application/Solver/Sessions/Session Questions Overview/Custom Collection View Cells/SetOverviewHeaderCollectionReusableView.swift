import UIKit

class SetOverviewHeaderCollectionReusableView: UICollectionReusableView {
  enum ExpansionState {
    case expanded
    case narrowed
    
    var negated: ExpansionState {
      switch self {
      case .expanded:
        return .narrowed
      case .narrowed:
        return .expanded
      }
    }
  }
  
  static let identifier = "SetOverviewHeader"
  
  @IBOutlet weak var setNameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var chevronButton: UIButton!
  
  var delegate: SetOverviewHeaderCollectionReusableViewDelegate? = nil
  
  private(set) var expansionState: ExpansionState = .expanded
  
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
  
  func setExpansionState(expansionState: ExpansionState, animated: Bool) {
    if expansionState == self.expansionState {
      return
    }
    
    self.expansionState = expansionState
    
    UIView.animate(withDuration: animated ? 0.5 : 0.001) {
      switch expansionState {
      case .expanded:
        self.chevronButton.transform = .init(rotationAngle: 0)
      case .narrowed:
        self.chevronButton.transform = .init(rotationAngle: .pi)
      }
    }
  }
  
  //  MARK: - UICollectionViewReusableView lifecycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    setExpansionState(expansionState: .expanded, animated: false)
  }
  
  @IBAction func didPressExpandOrNarrow(_ sender: UIButton) {
    delegate?.sectionShouldChangeExpensionState(self,
                                                currentState: expansionState)
  }
}

protocol SetOverviewHeaderCollectionReusableViewDelegate : class {
  func sectionShouldChangeExpensionState(_ setOverviewHeaderCollectionReusableView: SetOverviewHeaderCollectionReusableView,
                                         currentState state: SetOverviewHeaderCollectionReusableView.ExpansionState)
}
