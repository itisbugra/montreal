//
//  ClientConfiguration.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 1.05.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import Foundation

class ClientConfiguration {
    static let shared = ClientConfiguration()
    
    private(set) var optionEnumerationSet: OptionEnumeration = .letter(type: .uppercase)
}
