import UIKit

extension QuestionMasterTableViewController {
  fileprivate func squashUpdates() {
    tableView.layoutIfNeeded()
    tableView.beginUpdates()
    tableView.endUpdates()
  }
}

extension QuestionMasterTableViewController : QuestionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: QuestionContentTableViewCell,
                                 height: CGFloat) {
    squashUpdates()
  }
}

extension QuestionMasterTableViewController : OptionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: OptionContentTableViewCell,
                                 height: CGFloat) {
    squashUpdates()
  }
}
