import UIKit

extension UIFontDescriptor.AttributeName {
  static fileprivate let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
  static fileprivate var isOverridden: Bool = false
  
  @objc fileprivate class func overriddenFont(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: ThemeProvider.ChangedFontNames.regular, size: size)!
  }
  
  @objc fileprivate class func overriddenFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
    return UIFont(name: ThemeProvider.ChangedFontNames.regular, size: size)!
  }
  
  @objc fileprivate class func overriddenBoldFont(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: ThemeProvider.ChangedFontNames.emphasized, size: size)!
  }
  
  @objc fileprivate class func overriddenItalicFont(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: ThemeProvider.ChangedFontNames.oblique, size: size)!
  }
  
  @objc fileprivate class func overriddenPreferredFont(forTextStyle: UIFont.TextStyle) -> UIFont {
    return UIFont(name: ThemeProvider.ChangedFontNames.regular, size: 8.0)!
  }
  
  @objc fileprivate class func overriddenPreferredFont(forTextStyle: UIFont.TextStyle, compatibleWidth: UITraitCollection?) -> UIFont {
    return UIFont(name: ThemeProvider.ChangedFontNames.regular, size: 8.0)!
  }
  
  @objc fileprivate convenience init(myCoder aDecoder: NSCoder) {
    guard
      let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
      let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
        self.init(myCoder: aDecoder)
        
        return
    }
    
    switch fontAttribute {
    case "CTFontRegularUsage":
      self.init(name: ThemeProvider.ChangedFontNames.regular, size: fontDescriptor.pointSize)!
    case "CTFontEmphasizedUsage", "CTFontBoldUsage":
      self.init(name: ThemeProvider.ChangedFontNames.emphasized, size: fontDescriptor.pointSize)!
    case "CTFontObliqueUsage":
      self.init(name: ThemeProvider.ChangedFontNames.oblique, size: fontDescriptor.pointSize)!
    default:
      self.init(name: ThemeProvider.ChangedFontNames.regular, size: fontDescriptor.pointSize)!
    }
  }
  
  fileprivate class func swizzleMethods() {
    guard self == UIFont.self, !isOverridden else { return }
    
    // Avoid method swizzling run twice and revert to original initialize function
    isOverridden = true
    
    if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
      let overriddenSystemFontMethod = class_getClassMethod(self, #selector(overriddenFont(ofSize:))) {
      method_exchangeImplementations(systemFontMethod, overriddenSystemFontMethod)
    }
    
    if let systemFontWithWeightMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
      let overriddenSystemFontWithWeightMethod = class_getClassMethod(self, #selector(overriddenFont(ofSize:weight:))) {
      method_exchangeImplementations(systemFontWithWeightMethod, overriddenSystemFontWithWeightMethod)
    }
    
    if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
      let overriddenBoldSystemFontMethod = class_getClassMethod(self, #selector(overriddenBoldFont(ofSize:))) {
      method_exchangeImplementations(boldSystemFontMethod, overriddenBoldSystemFontMethod)
    }
    
    if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
      let overriddenItalicSystemFontMethod = class_getClassMethod(self, #selector(overriddenItalicFont(ofSize:))) {
      method_exchangeImplementations(italicSystemFontMethod, overriddenItalicSystemFontMethod)
    }
    
    if let preferredFontMethod = class_getClassMethod(self, #selector(preferredFont(forTextStyle:))),
      let overriddenPreferredFontMethod = class_getClassMethod(self, #selector(overriddenPreferredFont(forTextStyle:))) {
      method_exchangeImplementations(preferredFontMethod, overriddenPreferredFontMethod)
    }
    
    if let preferredFontWithCompatibleWidthMethod = class_getClassMethod(self, #selector(preferredFont(forTextStyle:compatibleWith:))),
      let overriddenPreferredFontWithCompatibleWidthMethod = class_getClassMethod(self, #selector(overriddenPreferredFont(forTextStyle:compatibleWidth:))) {
      method_exchangeImplementations(preferredFontWithCompatibleWidthMethod, overriddenPreferredFontWithCompatibleWidthMethod)
    }
    
    // Trick to get over the lack of UIFont.init(coder:))
    if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
      let overriddenInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
      method_exchangeImplementations(initCoderMethod, overriddenInitCoderMethod)
    }
  }
}

extension UILabel {
  static fileprivate var isOverridden: Bool = false
  
  @objc fileprivate func overriddenSetFont(font: UIFont) {
    if font.familyName != "Lato" {
      overriddenSetFont(font: UIFont(name: ThemeProvider.ChangedFontNames.regular, size: font.pointSize > 0.0 ? font.pointSize : 13.0)!)
    }
  }
  
  @objc fileprivate convenience init?(overriddenCoder aDecoder: NSCoder) {
    self.init(overriddenCoder: aDecoder)
    
    self.font = UIFont(name: ThemeProvider.ChangedFontNames.regular, size: font.pointSize > 0.0 ? font.pointSize : 13.0)!
  }
  
  fileprivate class func swizzleMethods() {
    guard self == UILabel.self, !isOverridden else { return }
    
    // Avoid method swizzling run twice and revert to original initialize function
    isOverridden = true
    
    if let setFontMethod = class_getInstanceMethod(self, #selector(setter: self.font)),
      let overriddenSetFontMethod = class_getInstanceMethod(self, #selector(overriddenSetFont(font:))) {
      method_exchangeImplementations(setFontMethod, overriddenSetFontMethod)
    }
    
    if let initCoderMethod = class_getInstanceMethod(self, #selector(UILabel.init(coder:))),
      let overriddenInitCoderMethod = class_getInstanceMethod(self, #selector(UILabel.init(overriddenCoder:))) {
      method_exchangeImplementations(initCoderMethod, overriddenInitCoderMethod)
    }
  }
}



public final class ThemeProvider {
  fileprivate struct ChangedFontNames {
    static var regular = "Helvetica"
    static var emphasized = "Helvetica"
    static var oblique = "Helvetica"
  }
  
  public let fontConfiguration: FontConfiguration?
  
  public init(fontConfiguration: FontConfiguration? = nil) {
    self.fontConfiguration = fontConfiguration
  }
  
  public func decorateApplication() {
    if let fontConfiguration = fontConfiguration {
      ChangedFontNames.regular = fontConfiguration.regularFontName
      ChangedFontNames.emphasized = fontConfiguration.emphasizedFontName ?? fontConfiguration.regularFontName
      ChangedFontNames.oblique = fontConfiguration.obliqueFontName ?? fontConfiguration.regularFontName
      
      UIFont.swizzleMethods()
      UILabel.swizzleMethods()
      changeNavigationBarFont()
    }
  }
  
  private func changeNavigationBarFont() {
    let fontName = ChangedFontNames.regular
    let smallFont = UIFont(name: fontName, size: 17.0)!
    let largeFont = UIFont(name: fontName, size: 34.0)!
    
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: smallFont]
    UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: largeFont]
  }
}
