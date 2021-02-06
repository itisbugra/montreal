import UIKit

internal class UIColorMethodSwizzler: SwizzlingApplicable {
  var isStarted: Bool = false
  
  //  MARK: - Method swizzler
  
  func run() {
    
  }
}

extension UIColor {
  //  MARK: - Method overrides
  
  @objc fileprivate class func overriddenDarkText() -> UIColor {
    return .darkText
  }
  
  @objc fileprivate class func overriddenGroupTableViewBackground() -> UIColor {
    return .groupTableViewBackground
  }
  
  @objc fileprivate class func overriddenLabel() -> UIColor {
    return .label
  }
  
  @objc fileprivate class func overriddenLightText() -> UIColor {
    return .lightText
  }
  
  @objc fileprivate class func overriddenLink() -> UIColor {
    return .link
  }
  
  @objc fileprivate class func overriddenOpaqueSeperator() -> UIColor {
    return .opaqueSeparator
  }
  
  @objc fileprivate class func overriddenPlaceholderText() -> UIColor {
    return .placeholderText
  }
  
  @objc fileprivate class func overriddenQuarternaryLabel() -> UIColor {
    return .quaternaryLabel
  }
  
  @objc fileprivate class func overriddenQuarternarySystemFill() -> UIColor {
    return .quaternarySystemFill
  }
  
  @objc fileprivate class func overriddenSecondaryLabel() -> UIColor {
    return .secondaryLabel
  }
  
  @objc fileprivate class func overriddenSecondarySystemBackground() -> UIColor {
    return .secondarySystemBackground
  }
  
  @objc fileprivate class func overriddenSecondarySystemFill() -> UIColor {
    return .secondarySystemFill
  }
  
  @objc fileprivate class func overriddenSecondarySystemGroupedBackground() -> UIColor {
    return .secondarySystemGroupedBackground
  }
  
  @objc fileprivate class func overriddenSeperator() -> UIColor {
    return .separator
  }
  
  @objc fileprivate class func overriddenSystemBackground() -> UIColor {
    return .systemBackground
  }
  
  @objc fileprivate class func overriddenSystemBlue() -> UIColor {
    return .systemBlue
  }
  
  @objc fileprivate class func overriddenSystemFill() -> UIColor {
    return .systemFill
  }
  
  @objc fileprivate class func overriddenSystemGray2() -> UIColor {
    return .systemGray2
  }
  
  @objc fileprivate class func overriddenSystemGray3() -> UIColor {
    return .systemGray3
  }
  
  @objc fileprivate class func overriddenSystemGray4() -> UIColor {
    return .systemGray4
  }
  
  @objc fileprivate class func overriddenSystemGray5() -> UIColor {
    return .systemGray5
  }
  
  @objc fileprivate class func overriddenSystemGray6() -> UIColor {
    return .systemGray6
  }
  
  @objc fileprivate class func overriddenSystemGray() -> UIColor {
    return .systemGray
  }
  
  @objc fileprivate class func overriddenSystemGreen() -> UIColor {
    return .systemGreen
  }
  
  @objc fileprivate class func overriddenSystemGroupedBackground() -> UIColor {
    return .systemGroupedBackground
  }
  
  @objc fileprivate class func overriddenSystemIndigo() -> UIColor {
    return .systemIndigo
  }
  
  @objc fileprivate class func overriddenSystemOrange() -> UIColor {
    return .systemOrange
  }
  
  @objc fileprivate class func overriddenSystemPink() -> UIColor {
    return .systemPink
  }
  
  @objc fileprivate class func overriddenSystemPurple() -> UIColor {
    return .systemPurple
  }
  
  @objc fileprivate class func overriddenSystemRed() -> UIColor {
    return .systemRed
  }
  
  @objc fileprivate class func overriddenSystemTeal() -> UIColor {
    return .systemTeal
  }
  
  @objc fileprivate class func overriddenSystemYellow() -> UIColor {
    return .systemYellow
  }
}
