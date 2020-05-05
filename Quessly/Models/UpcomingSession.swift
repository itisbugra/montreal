//
//  UpcomingSession.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 27.04.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import Foundation

public class UpcomingSession {
    var untouched: Bool
    var title: String
    var participantCount: UInt
    var timestamp: Date
    
    init(untouched: Bool,
         title: String,
         participantCount: UInt,
         timestamp: Date) {
        self.untouched = untouched
        self.title = title
        self.participantCount = participantCount
        self.timestamp = timestamp
    }
}
