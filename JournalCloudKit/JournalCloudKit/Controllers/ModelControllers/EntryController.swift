//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Trevor Bursach on 10/5/20.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - Properties
    
    var privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - Singleton
    
    static let shared = EntryController()
    
    //MARK: - Source of Truth
    
    var entries: [Entry] = []
    
    
    //MARK: - Crud
    
    func createEntryWith(title: String, body: String, completion: @escaping(_ result: Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        
        saveEntry(entry: newEntry) { (result) in
            switch result {
            
            case .success(let entry):
                
                    self.entries.append(entry)
                completion(.success(entry))
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
        }
    }
    
    func saveEntry(entry: Entry, completion: @escaping (Result<Entry, EntryError>) -> Void) {
        
        let entryRecord = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(entryRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }

            print("Saved Entry successfully")
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping(_ result: Result<[Entry]?, EntryError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordType, predicate: fetchAllPredicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Fetched Entries successfully")
            let fetchedEntries = records.compactMap({Entry(ckRecord: $0) })
            self.entries = fetchedEntries
            completion(.success(fetchedEntries))
        }
    }
    
    
    
    
    
} // END OF CLASS
