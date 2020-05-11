import UIKit

class SmoothButton: UIButton {
  static private let cornerRadius: CGFloat = 8.00
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    sharedInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    sharedInit()
  }
  
  private func sharedInit() {
    layer.cornerRadius = SmoothButton.cornerRadius
    maskAllCorners = true
    clipsToBounds = true
  }
  
  @objc var maskAllCorners: Bool = true {
    didSet {
      let allCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
      let optionalCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
      
      layer.maskedCorners = maskAllCorners ? allCorners : optionalCorners
    }
  }
}
