import UIKit

extension UIAlertAction {
  public convenience init(title: String?, style: UIAlertAction.Style, checked: Bool, handler: ((UIAlertAction) -> Void)? = nil) {
    self.init(title: title, style: style, handler: handler)
    
    isChecked = checked
  }
  
  var isChecked: Bool {
    get {
      return (value(forKey: "checked") as! NSNumber).boolValue
    }
    set {
      setValue(NSNumber(booleanLiteral: newValue), forKey: "checked")
    }
  }
}
