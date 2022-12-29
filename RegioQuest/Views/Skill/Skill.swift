//
//  Skill.swift
//  RegioQuest
//
//  Created by Orhan Salman on 18.12.22.
//

import CloudKit
import Foundation

struct ModelSkill: Hashable {
    var name: String
    var pointsAtLeast: Int32
    var maxPoints: Int32
    let associatedRecord: CKRecord
}

enum SkillRecordKeys: String {
    case type = "Skill"
    case name
    case pointsAtLeast
    case maxPoints
}

// Converter for save
extension ModelSkill {
    var record: CKRecord {
        let record = CKRecord(recordType: StoryRecordKeys.type.rawValue)
        record[SkillRecordKeys.name.rawValue] = name
        record[SkillRecordKeys.pointsAtLeast.rawValue] = pointsAtLeast
        record[SkillRecordKeys.maxPoints.rawValue] = maxPoints
        return record
    }
}
// Converter for Fetch
extension ModelSkill {
    init?(from record: CKRecord) {
        guard
            let name = record[StoryRecordKeys.title.rawValue] as? String,
            let pointsAtLeast = record[StoryRecordKeys.userName.rawValue] as? Int32,
            let maxPoints = record[StoryRecordKeys.description.rawValue] as? Int32,
            let associatedRecord = record as? CKRecord
        else { return nil }
        self = .init(name: name, pointsAtLeast: pointsAtLeast, maxPoints: maxPoints, associatedRecord: associatedRecord)
    }
}
