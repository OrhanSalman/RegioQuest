//
//  JobViewModel.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.12.22.
//

import Foundation
import CloudKit
import SwiftUI

enum RecordType: String {
    case job = "Job"
    case story = "Story"
}

class JobViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    private var database: CKDatabase
    private var container: CKContainer
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    
    func save(recordType: RecordType) {
        let record = CKRecord(recordType: recordType.rawValue)
        let job = Job(context: managedObjectContext)
//        let jobListing = JobListing(name: name, title: title)
        record.setValuesForKeys(job.changedValues())
        
        // saving record in database
        self.database.save(record) { newRecord, error in
            if let error = error {
                print(error)
            }
            else {
                if let _ = newRecord {
                    print("SAVED")
                }
            }
        }
    }
     
}

/* In ContentView, und parent view dann ab 13:50min gucken
@StateObject private var vm: JobViewModel

init(vm: JobViewModel) {
    _vm = StateObject(wrappedValue: vm)
}
*/

