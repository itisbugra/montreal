import Foundation

public final class FontConfiguration {
  public let regularFontName: String
  public let emphasizedFontName: String?
  public let obliqueFontName: String?
  
  public init(regularFontName: String,
              emphasizedFontName: String? = nil,
              obliqueFontName: String? = nil) {
    self.regularFontName = regularFontName
    self.emphasizedFontName = emphasizedFontName
    self.obliqueFontName = obliqueFontName
  }
}
