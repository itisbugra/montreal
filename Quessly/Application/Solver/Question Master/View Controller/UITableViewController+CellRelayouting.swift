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
    questionHeight = height
    
    squashUpdates()
  }
}

extension QuestionMasterTableViewController : OptionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: OptionContentTableViewCell,
                                 height: CGFloat) {
    optionHeights[cell.option] = height
    
    squashUpdates()
  }
}
