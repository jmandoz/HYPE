//
//  Hype.swift
//  HYPE
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

//Created a struct of Magic Strings to use throughout our file
struct Constants {
    static let recordTypeKey = "Hype"
    fileprivate static let recordTextKey = "Text"
    fileprivate static let recordTimestampKey = "Timestamp"
}

//Creating the Hype model object
class Hype {
    let hypeText: String
    let timestamp: Date
    //Initializing a Hype - Dedicated Initializer
    init(hypeText: String, timestamp: Date = Date()) {
        self.hypeText = hypeText
        self.timestamp = timestamp
    }
}

//Creating a Hype from a CKRecord
extension Hype {
    //Convenience Initializer (failable because we need to have the data a certain way, if not than return nil
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String,
            let hypeTimestamp = ckRecord[Constants.recordTimestampKey] as? Date else {return nil}
        self.init(hypeText: hypeText, timestamp: hypeTimestamp)
    }
}

//Creating a CKRecord from a Hype
extension CKRecord {
    //Convenience Initializer
    convenience init(hype: Hype) {
        self.init(recordType: Constants.recordTypeKey)
        self.setValue(hype.hypeText, forKey: Constants.recordTextKey)
        self.setValue(hype.timestamp, forKey: Constants.recordTimestampKey)
    }
}
