import UIKit

class CenteredLabelTableViewCell: UITableViewCell {
  static let identifier = "CenteredLabel"
  static let nib = UINib(nibName: "CenteredLabelTableViewCell", bundle: nil)
  
  @IBOutlet weak var centeredLabel: UILabel!
  
  override var textLabel: UILabel? {
    return centeredLabel
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
}

extension UITableView {
  func registerCenteredLabelTableViewCell() {
    register(CenteredLabelTableViewCell.nib,
             forCellReuseIdentifier: CenteredLabelTableViewCell.identifier)
  }
}
