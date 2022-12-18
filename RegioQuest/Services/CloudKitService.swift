//
//  CloudKitService.swift
//  RegioQuestAdminTool
//
//  Created by Orhan Salman on 13.12.22.
//

import CloudKit
import os
import SwiftUI


final class CloudKitService {
    
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: CloudKitService.self)
    )

    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
}

@MainActor final class AccountServiceModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: AccountServiceModel.self)
    )

    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine

    private let cloudKitService = CloudKitService()

    func fetchAccountStatus() async {
        do {
            accountStatus = try await cloudKitService.checkAccountStatus()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
}


extension CloudKitService {
    func save(_ record: CKRecord) async throws {
        try await CKContainer.default().publicCloudDatabase.save(record)
    }
}

extension CloudKitService {
    func delete(_ record: CKRecord) async throws {
        try await CKContainer.default().publicCloudDatabase.deleteRecord(withID: record.recordID)
    }
}

extension CloudKitService {
    func fetchStoryRecords() async throws -> [ModelStory] {
        let predicate = NSPredicate(
            format: "\(StoryRecordKeys.timestamp.rawValue) <= %@", Date.now as NSDate
        )

        let query = CKQuery(
            recordType: StoryRecordKeys.type.rawValue,
            predicate: predicate
        )

        query.sortDescriptors = [.init(key: StoryRecordKeys.timestamp.rawValue, ascending: false)]

        let result = try await CKContainer.default().publicCloudDatabase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(ModelStory.init)
    }
}

extension CloudKitService {
    
    func fetchMyStoryRecords(accountID: CKRecord.ID) async throws -> [ModelStory] {
        
        let predicate = NSPredicate(
            format: "creatorUserRecordID == %@", accountID
        )
        
        let query = CKQuery(
            recordType: StoryRecordKeys.type.rawValue,
            predicate: predicate
        )

        query.sortDescriptors = [.init(key: StoryRecordKeys.timestamp.rawValue, ascending: false)]

        let result = try await CKContainer.default().publicCloudDatabase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(ModelStory.init)
    }
}
