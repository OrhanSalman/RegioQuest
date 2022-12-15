//
//  JobListing.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.12.22.
//

import Foundation
import CloudKit

struct JobListing {
    
    var recordId: CKRecord.ID?
    let name: String
    let title: String
    init(recordId: CKRecord.ID? = nil, name: String, title: String) {
        self.recordId = recordId
        self.name = name
        self.title = title
    }
    
    func toDictionary() -> [String: Any] {
        return ["name": name, "title": title]
    }
}
