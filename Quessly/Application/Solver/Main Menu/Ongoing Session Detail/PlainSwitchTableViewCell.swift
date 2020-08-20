import UIKit

@IBDesignable
class PlainSwitchTableViewCell: UITableViewCell {
  static let identifier = "PlainSwitch"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var `switch`: UISwitch!
  
  var delegate: PlainSwitchTableViewCellDelegate? = nil
  
  @IBInspectable var isOn: Bool = true {
    didSet {
      `switch`.isOn = isOn
    }
  }
  
  @IBInspectable var isEnabled: Bool = true {
    didSet {
      `switch`.isEnabled = isEnabled
    }
  }
  
  @IBAction func switchValueDidChange(_ sender: UISwitch) {
    delegate?.plainSwitchTableViewCell(self,
                                       valueDidChange: sender.isOn)
  }
}

protocol PlainSwitchTableViewCellDelegate: class {
  func plainSwitchTableViewCell(_ plainSwitchTableViewCell: PlainSwitchTableViewCell,
                                valueDidChange: Bool)
}
