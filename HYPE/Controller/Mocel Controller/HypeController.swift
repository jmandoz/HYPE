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
            self.hypes.append(hype)
            completion(true)
        }
    }
    
    //Fetch
    func fetchHype(completion: @escaping (Bool) -> Void) {
        
    }
    
    //Subscription
    func subscribeToRemoteNotifications(completion: @escaping (Error?)-> Void) {
        
    }
}
