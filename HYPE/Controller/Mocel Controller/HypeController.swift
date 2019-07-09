//
//  HypeController.swift
//  HYPE
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    //Mark - Hype
    
    //Sinlgeton
    static let shared = HypeController()
    
    //Source of Truth
    var hypes:[Hype] = []
    
    //Define our Database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //CRUD Functions
    //For this app - we only need save and fetch
    
    //Save
    func saveHype(text: String, completion: @escaping (Bool) -> Void) {
        //creating a Hype object
        let hype = Hype(hypeText: text)
        //creating a hype record but we need a Hype object (^ created above)
        let hypeRecord = CKRecord(hype: hype)
        //saving to the database but we need a record (^ created above)
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            self.hypes.insert(hype, at: 0)
            completion(true)
        }
    }
    
    //Fetch
    func fetchHype(completion: @escaping (Bool) -> Void) {
        //creating a predicate for our query for our .perform
        let predicate = NSPredicate(value: true)
        //creating our query but we need a predicate (^ created above)
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: Constants.recordTimestampKey, ascending: false)]
        //in order to create our perform fetch from the DB - we need a query (^ createdabove)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else {completion(false); return}
            let hypes = records.compactMap({Hype (ckRecord: $0)})
            self.hypes = hypes
            completion(true)
        }
    }
    
    //Subscription
    func subscribeToRemoteNotifications(completion: @escaping (Error?)-> Void) {
        
    }
}
