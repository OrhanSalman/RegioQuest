//
//  Quest.swift
//  RegioQuest
//
//  Created by Orhan Salman on 20.12.22.
//

import CloudKit
import Foundation

struct ModelQuest: Hashable {
    var title: String
    var description: String
    var latitude: Double
    var longitude: Double
    var branche: String
    var timestamp: Date
    let associatedRecord: CKRecord
}

enum QuestRecordKeys: String {
    case type = "Quest"
    case title
    case description
    case latitude
    case longitude
    case branche
    case timestamp
}

// Converter for save
extension ModelQuest {
    var record: CKRecord {
        let record = CKRecord(recordType: QuestRecordKeys.type.rawValue)
        record[QuestRecordKeys.title.rawValue] = title
        record[QuestRecordKeys.description.rawValue] = description
        record[QuestRecordKeys.latitude.rawValue] = latitude
        record[QuestRecordKeys.longitude.rawValue] = longitude
        record[QuestRecordKeys.branche.rawValue] = branche
        record[QuestRecordKeys.timestamp.rawValue] = timestamp
        return record
    }
}
// Converter for Fetch
extension ModelQuest {
    init?(from record: CKRecord) {
        guard
            let title = record[QuestRecordKeys.title.rawValue] as? String,
            let description = record[QuestRecordKeys.description.rawValue] as? String,
            let latitude = record[QuestRecordKeys.latitude.rawValue] as? Double,
            let longitude = record[QuestRecordKeys.longitude.rawValue] as? Double,
            let branche = record[QuestRecordKeys.branche.rawValue] as? String,
            let timestamp = record[QuestRecordKeys.timestamp.rawValue] as? Date,
            let associatedRecord = record as? CKRecord
        else { return nil }
        self = .init(title: title, description: description, latitude: latitude, longitude: longitude, branche: branche, timestamp: timestamp, associatedRecord: associatedRecord)
    }
}
