import Foundation
import libPhoneNumber_iOS
import UIKit

class PhoneNumberFormatter {
  static private let libPhoneNumber = NBPhoneNumberUtil.sharedInstance()!
  private let façade: NBPhoneNumberUtil
  
  init() {
    façade = PhoneNumberFormatter.libPhoneNumber
  }
  
  enum Format {
    case e164
    case international
  }
  
  public func isValid(string: String) -> Bool {
    do {
      let phoneNumber = try façade.parse(withPhoneCarrierRegion: string)
      
      return façade.isValidNumber(phoneNumber)
    } catch {
      return false
    }
  }
  
  public func convert(string: String, to format: Format) throws -> String {
    do {
      let phoneNumber = try façade.parse(withPhoneCarrierRegion: string)
      
      guard façade.isValidNumber(phoneNumber) else {
        throw PhoneNumberFormattingError.invalidPhoneNumber
      }
      
      let numberFormat: NBEPhoneNumberFormat = ({
        switch format {
        case .e164:
          return .E164
          
        case .international:
          return .INTERNATIONAL
        }
      })()
      
      return try façade.format(phoneNumber, numberFormat: numberFormat)
    }
  }
  
  public func convert(string: String, region: Locale, to format: Format) throws -> String {
    let regionCode = region.regionCode!.lowercased()
    
    do {
      let phoneNumber = try façade.parse(string, defaultRegion: regionCode)
      
      guard façade.isValidNumber(phoneNumber) else {
        throw PhoneNumberFormattingError.invalidPhoneNumber
      }
      
      let numberFormat: NBEPhoneNumberFormat = ({
        switch format {
        case .e164:
          return .E164
          
        case .international:
          return .INTERNATIONAL
        }
      })()
      
      return try façade.format(phoneNumber, numberFormat: numberFormat)
    }
  }
}

enum PhoneNumberFormattingError: Error {
  case invalidPhoneNumber
}
