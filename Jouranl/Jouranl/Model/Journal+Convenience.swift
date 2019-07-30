//
//  Journal+Convenience.swift
//  Jouranl
//
//  Created by Hayden Hastings on 7/30/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

extension Journal {
    convenience init(title: String, journalText: String, photo: String?, timestamp: Date = Date(), identifier: String? = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.journalText = journalText
        self.photo = photo
        self.timestamp = timestamp
    }
    
    convenience init(journalRepresentation: JournalRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(title: journalRepresentation.title, journalText: journalRepresentation.journalText, photo: journalRepresentation.photo, timestamp: journalRepresentation.timestamp, identifier: journalRepresentation.identifier, context: context)
    }
    
    var journalRepresentation: JournalRepresentation? {
        guard let title = title,
        let journalText = journalText,
        let photo = photo,
            let timestamp = timestamp else { return nil }
        
        if identifier == nil {
            identifier = UUID().uuidString
        }
        
        return JournalRepresentation(title: title, journalText: journalText, photo: photo, timestamp: timestamp, identifier: identifier!)
    }
}
