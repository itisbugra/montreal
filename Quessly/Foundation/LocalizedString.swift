import Foundation

struct LocalizedString {
  var localizedValue: String
  var locale: Locale
  var defaultValue: String? = nil
  
  init(localized localizedValue: String,
       locale: Locale,
       default defaultValue: String? = nil) {
    self.localizedValue = localizedValue
    self.locale = locale
    self.defaultValue = defaultValue
  }
}
