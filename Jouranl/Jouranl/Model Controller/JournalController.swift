//
//  JournalController.swift
//  Jouranl
//
//  Created by Hayden Hastings on 7/30/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

class JournalController {
    
    init() {
        fetchJournalFromServer()
    }
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://journaldaily-3562d.firebaseio.com/")!
    typealias CompletionError = (Error?) -> Void
    
    // MARK: - CRUD Methods
    
    func create(journal title: String, journalText: String, timestamp: Date, photo: String, identifier: String) {
        let journal = Journal(title: title, journalText: journalText, photo: photo, timestamp: timestamp, identifier: identifier)
        
        saveToPersistantStore()
        put(journal: journal)
    }
    
    func update(journal: Journal, title: String, journalText: String) {
        let journal = journal
        journal.title = title
        journal.journalText = journalText
        journal.timestamp = Date()
        
        saveToPersistantStore()
        put(journal: journal)
    }
    
    func delete(journal: Journal) {
        
        if let moc = journal.managedObjectContext {
            moc.delete(journal)
            saveToPersistantStore()
        }
    }
    
    // MARK: - Core Data Fetching methods
    
    func update(journal: Journal, with representation: JournalRepresentation) {
        journal.title = representation.title
        journal.journalText = representation.journalText
        journal.timestamp = representation.timestamp
        journal.photo = representation.photo
    }
    
    func saveToPersistantStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    private func updateJournal(with representations: [JournalRepresentation], context: NSManagedObjectContext) throws {
        var error: Error? = nil
        
        context.performAndWait {
            for journalRep in representations {
                guard let uuid = UUID(uuidString: journalRep.identifier) else { continue }
                
                if let journal = self.fetchingSingleJournalFromPersistentStore(identifier: uuid.uuidString, in: context) {
                    self.update(journal: journal, with: journalRep)
                } else {
                    let _ = Journal(journalRepresentation: journalRep, context: context)
                }
            }
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    func deleteJournalFromServer(journal: Journal, completion: @escaping CompletionError = {_ in }) {
        guard let uuid = journal.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
            }.resume()
    }
    
    func fetchingSingleJournalFromPersistentStore(identifier: String, in context: NSManagedObjectContext) -> Journal? {
        
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: Journal? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with uuid \(identifier): \(error)")
            }
        }
        return result
    }
    
    func fetchJournalFromServer(completion: @escaping CompletionError = {_ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching journals: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            do {
                let journalRepresentation = Array(try JSONDecoder().decode([String: JournalRepresentation].self, from: data).values)
                
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                try self.updateJournal(with: journalRepresentation, context: moc)
                completion(nil)
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func put(journal: Journal, completion: @escaping CompletionError = {_ in}) {
        let uuid = journal.identifier ?? UUID().uuidString
        journal.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = journal.journalRepresentation else {
                completion(NSError())
                return
            }
            
            representation.identifier = uuid
            journal.identifier = uuid
            
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing journal to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
