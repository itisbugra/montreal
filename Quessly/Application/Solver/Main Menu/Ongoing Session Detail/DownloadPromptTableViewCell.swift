import UIKit

class OngoingSessionLoadingTableViewCell: UITableViewCell {
  var delegate: DownloadPromptTableViewCellDelegate? = nil
  
  @IBAction func downloadStartTouchUpInside(_ sender: UIButton) {
    delegate?.downloadPromptTableViewCellReceivedDownloadAction(self)
  }
}

protocol DownloadPromptTableViewCellDelegate {
  func downloadPromptTableViewCellReceivedDownloadAction(_ cell: OngoingSessionLoadingTableViewCell)
}
