//
//  Story.swift
//  RegioQuest
//
//  Created by Orhan Salman on 14.12.22.
//

import CloudKit
import Foundation

struct ModelStory: Hashable {
    var userName: String
    var title: String
    var description: String
    var timestamp: Date
    let associatedRecord: CKRecord
}

enum StoryRecordKeys: String {
    case type = "Story"
    case userName
    case title
    case description
    case timestamp
}

// Converter for save
extension ModelStory {
    var record: CKRecord {
        let record = CKRecord(recordType: StoryRecordKeys.type.rawValue)
        record[StoryRecordKeys.userName.rawValue] = userName
        record[StoryRecordKeys.title.rawValue] = title
        record[StoryRecordKeys.description.rawValue] = description
        record[StoryRecordKeys.timestamp.rawValue] = timestamp
        return record
    }
}
// Converter for Fetch
extension ModelStory {
    init?(from record: CKRecord) {
        guard
            let title = record[StoryRecordKeys.title.rawValue] as? String,
            let userName = record[StoryRecordKeys.userName.rawValue] as? String,
            let description = record[StoryRecordKeys.description.rawValue] as? String,
            let timestamp = record[StoryRecordKeys.timestamp.rawValue] as? Date,
            let associatedRecord = record as? CKRecord
        else { return nil }
        self = .init(userName: userName, title: title, description: description, timestamp: timestamp, associatedRecord: associatedRecord)
    }
}
