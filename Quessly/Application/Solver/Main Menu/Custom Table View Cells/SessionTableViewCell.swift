import UIKit

class SessionTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var tintCircleImageView: UIImageView!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var upperDescriptionLabel: UILabel!
  @IBOutlet weak var lowerDescriptionLabel: UILabel!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  static let identifier = "SessionTableViewCell"
  private static let nib = UINib(nibName: identifier, bundle: nil)
  
  var downloadPromptDelegate: SessionTableViewCellDownloadPromptDelegate? = nil
  
  static func registerForReuse(in tableView: UITableView) {
    tableView.register(nib, forCellReuseIdentifier: identifier)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    sharedInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    sharedInit()
  }
  
  private func sharedInit() {
    contentView.frame = frame
    addSubview(contentView)
  }
  
  var session: Session! = nil {
    didSet {
      titleLabel.text = session.name.localizedValue
//      subtitleLabel.text = String(format: NSLocalizedString("%llu users in session",
//                                                            comment: "Number of users joined to the live session shown in main menu"),
//                                  session.participantCount)
      subtitleLabel.text = String(format: NSLocalizedString("%llu users in session",
                                                            comment: "Number of users joined to the live session shown in main menu"),
                                  5000)
      sessionState = session.state
    }
  }
  
  /// The view state of the table view cell.
  enum State {
    /// Shows the starting information of the session.
    case regular
    
    /// Shows an activity indicator, regarding the content is about to be available.
    case loading
    
    /// Shows that content is available.
    case downloadPrompt
  }
  
  var state: State = .regular {
    didSet {
      switch state {
      case .regular:
        actionButton.isHidden = true
        activityIndicatorView.stopAnimating()
        upperDescriptionLabel.isHidden = false
        lowerDescriptionLabel.isHidden = false
      case .loading:
        actionButton.isHidden = true
        activityIndicatorView.startAnimating()
        upperDescriptionLabel.isHidden = true
        lowerDescriptionLabel.isHidden = true
      case .downloadPrompt:
        actionButton.isHidden = false
        activityIndicatorView.stopAnimating()
        upperDescriptionLabel.isHidden = true
        lowerDescriptionLabel.isHidden = true
      }
    }
  }
  
  var isEnabled: Bool = true {
    didSet {
      actionButton.isEnabled = isEnabled
    }
  }
  
  //  MARK: - Internal state
  
  private var sessionState: Session.State? = nil {
    didSet {
      switch sessionState {
      case .awaiting:
        fallthrough
      case .contentAvailable:
        fallthrough
      case .contentFetched:
        tintCircleImageView.isHidden = false
        tintCircleImageView.tintColor = .systemOrange
        
        stopAnimating()
      case .started:
        fallthrough
      case .running:
        tintCircleImageView.isHidden = false
        tintCircleImageView.tintColor = .systemRed
        
        startAnimating()
      case .ended:
        fatalError("Ended session cannot be included as ongoing session.")
      case .none:
        tintCircleImageView.isHidden = true
      }
    }
  }
  
  var isAnimating: Bool = false {
    didSet {
      if isAnimating == oldValue {
        return
      }
      
      if isAnimating {
        startAnimating()
      } else {
        stopAnimating()
      }
    }
  }
  
  func startAnimating() {
    func animate() {
      UIView.animate(withDuration: 1, animations: {
        self.tintCircleImageView.alpha = 1.00
      }) { success in
        guard success else {
          return
        }
        
        UIView.animate(withDuration: 1, delay: 1, animations: {
          self.tintCircleImageView.alpha = 0.00
        }) { success  in
          guard success else {
            return
          }
          
          if self.isAnimating {
            animate()
          }
        }
      }
    }
    
    isAnimating = true
    
    animate()
  }
  
  func stopAnimating() {
    isAnimating = false
  }
  
  @IBAction func actionButtonTouchUpInside(_ sender: UIButton) {
    downloadPromptDelegate?.sessionTableViewCellReceivedDownloadAction(self)
  }
}

protocol SessionTableViewCellDownloadPromptDelegate: class {
  func sessionTableViewCellReceivedDownloadAction(_ cell: SessionTableViewCell)
}
