//
//  JournalRepresentation.swift
//  Jouranl
//
//  Created by Hayden Hastings on 7/30/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation

struct JournalRepresentation: Codable {
    
    let title: String
    let journalText: String
    var photo: String?
    var timestamp: Date
    let identifier: String
    
}

extension JournalRepresentation: Equatable {
    static func ==(lhs: JournalRepresentation, rhs: Journal) -> Bool {
        return lhs.title == rhs.title &&
        lhs.journalText == rhs.journalText &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier
    }
    
    static func ==(lhs: Journal, rhs: JournalRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func !=(lhs: JournalRepresentation, rhs: Journal) -> Bool {
        return !(rhs == lhs)
    }
    
    static func !=(lhs: Journal, rhs: JournalRepresentation) -> Bool {
        return rhs != lhs
    }
}
