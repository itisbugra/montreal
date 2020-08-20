import UIKit

class OngoingSessionDetailTableViewCell: UITableViewCell {
  //  MARK: - Interface builder outlets
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var downloadButton: UIButton!
  
  //  MARK: - Instance variables
  
  enum State {
    case loading
    case downloadPrompt
  }
  
  
  var delegate: OngoingSessionDetailTableViewCellDelegate? = nil
  
  var state: State = .loading {
    didSet {
      switch state {
      case .loading:
        startAnimating()
      case .downloadPrompt:
        stopAnimating()
      }
    }
  }
  
  //  MARK: - Actions
  
  @IBAction func downloadStartTouchUpInside(_ sender: UIButton) {
    delegate?.ongoingSessionDetailTableViewCellReceivedDownloadAction(self)
  }
  
  //  MARK: - UI effects
  
  private func startAnimating() {
    activityIndicatorView.startAnimating()
    downloadButton.isHidden = true
  }
  
  private func stopAnimating() {
    activityIndicatorView.stopAnimating()
    downloadButton.isHidden = false
  }
}

protocol OngoingSessionDetailTableViewCellDelegate {
  func ongoingSessionDetailTableViewCellReceivedDownloadAction(_ cell: OngoingSessionDetailTableViewCell)
}
