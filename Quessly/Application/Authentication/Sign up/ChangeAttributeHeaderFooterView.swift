import UIKit

class ChangeAttributeHeaderFooterView: UITableViewHeaderFooterView {
  enum AttributeType {
    case email
    case phoneNumber
  }
  
  static let nibName = "ChangeAttributeHeaderFooterView"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var switchAttributeTypeButton: UIButton!

  var title: String! {
    didSet {
      titleLabel.text = title.uppercased()
    }
  }
  
  var attributeType: AttributeType? = nil {
    didSet {
      guard let attributeType = attributeType else {
        return
      }
      
      delegate?.changeAttributeHeaderFooterView(self,
                                                didSwitchAttributeType: attributeType)
      
      setNeedsDisplay()
    }
  }
  
  weak var delegate: ChangeAttributeHeaderFooterViewDelegate?
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    switchAttributeTypeButton.configuration!.contentInsets = .zero
    
    title = NSLocalizedString("Sign Up", comment: "")
    
    guard let attributeType = attributeType else {
      return
    }
    
    switch attributeType {
    case .email:
      switchAttributeTypeButton.titleLabel!.text = NSLocalizedString("Sign up using phone number instead", comment: "")
      
    case .phoneNumber:
      switchAttributeTypeButton.titleLabel!.text = NSLocalizedString("Sign up using e-mail instead", comment: "")
    }
    
    DispatchQueue.main.async {
      Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.hotfix_redraw), userInfo: nil, repeats: false)
    }
  }
  
  @objc func hotfix_redraw() {
    self.setNeedsDisplay()
  }
  
  @IBAction func switchAttributeType(_ sender: UIButton) {
    guard let attributeType = attributeType else {
      return
    }
    
    switch attributeType {
    case .email:
      self.attributeType = .phoneNumber
      
    case .phoneNumber:
      self.attributeType = .email
    }
  }
}

protocol ChangeAttributeHeaderFooterViewDelegate: AnyObject {
  func changeAttributeHeaderFooterView(_ changeAttributeHeaderFooterView: ChangeAttributeHeaderFooterView,
                                       didSwitchAttributeType attributeType: ChangeAttributeHeaderFooterView.AttributeType)
}
