//
//  Question.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 30.04.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import Foundation

class Question: Equatable {
    class Option: Equatable {
        var id: Int
        var content: FormattedContent
        
        init(id: Int, content: FormattedContent) {
            self.id = id
            self.content = content
        }
        
        static func == (lhs: Option, rhs: Option) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    var id: Int
    var content: FormattedContent
    var options: [Option]
    
    init(id: Int, content: FormattedContent, options: [Option]) {
        self.id = id
        self.content = content
        self.options = options
    }
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }
}
