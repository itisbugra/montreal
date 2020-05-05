//
//  OptionEnumeration.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 1.05.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import Foundation

class RangeError : Error {
    let given: Int
    let extremity: Int
    
    init(given: Int, extremity: Int) {
        self.given = given
        self.extremity = extremity
    }
}

enum OptionEnumeration {
    enum LetterType {
        case lowercase
        case uppercase
    }
    
    enum NumeralType {
        case arabic
    }
    
    case letter(type: LetterType)
    case numeral(type: NumeralType)
    case custom(provider: OptionEnumerationProvider)
}

class OptionEnumerationProvider {
    func enumerationExtremity() -> Int {
        return 0
    }
    
    @discardableResult
    func symbol(for index: Int) throws -> String {
        let extremity = enumerationExtremity()
        
        if (index > extremity) {
            throw RangeError(given: index, extremity: extremity)
        }
        
        return ""
    }
}

class LowercaseLetterOptionEnumerationProvider : OptionEnumerationProvider {
    private let options = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    
    override func enumerationExtremity() -> Int {
        return options.count
    }
    
    override func symbol(for index: Int) throws -> String {
        try super.symbol(for: index)
        
        return options[index]
    }
}

class UppercaseLetterOptionEnumerationProvider : OptionEnumerationProvider {
    private let options = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    
    override func enumerationExtremity() -> Int {
        return options.count
    }
    
    override func symbol(for index: Int) throws -> String {
        try super.symbol(for: index)
        
        return "\(options[index]))"
    }
}

class ArabicNumeralsOptionEnumerationProvider : OptionEnumerationProvider {
    private let options = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func enumerationExtremity() -> Int {
        return options.count
    }
    
    override func symbol(for index: Int) throws -> String {
        try super.symbol(for: index)
        
        return options[index]
    }
}

func enumeration(for type: OptionEnumeration) -> OptionEnumerationProvider {
    switch type {
    case .letter(type: .lowercase):
        return LowercaseLetterOptionEnumerationProvider()
    case .letter(type: .uppercase):
        return UppercaseLetterOptionEnumerationProvider()
    case .numeral(type: .arabic):
        return ArabicNumeralsOptionEnumerationProvider()
    case .custom(let provider):
        return provider
    }
}
