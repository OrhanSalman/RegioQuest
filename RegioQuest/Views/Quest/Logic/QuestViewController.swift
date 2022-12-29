//
//  QuestViewController.swift
//  RegioQuest
//
//  Created by Orhan Salman on 20.12.22.
//

import Foundation
import OSLog
import SwiftUI
import CloudKit

@MainActor final class CreateQuestModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: CreateStoryModel.self)
    )
    @Published var quest: ModelQuest = .init(
        title: "",
        description: "",
        latitude: 0.0,
        longitude: 0.0,
        branche: "",
        timestamp: Date.now,
        associatedRecord: CKRecord(recordType: "Quest")
    )
    @Published private(set) var isSaving = false
    
    private let cloudKitService = CloudKitService()
    
    func save() async {
        isSaving = true
        
        do {
            try await cloudKitService.save(quest.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isSaving = false
    }
}

@MainActor final class FetchQuestModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: FetchQuestModel.self)
    )
    
    @Published private(set) var allQuests: [ModelQuest] = []
    @Published private(set) var userQuests: [ModelQuest] = []
    @Published private(set) var isLoading = false
    
    private let cloudKitService = CloudKitService()
    
    func fetch() async {
        isLoading = true
        
        do {
            allQuests = try await cloudKitService.fetchQuestRecords()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isLoading = false
    }
    
    func fetchMyStories(accountID: CKRecord.ID) async {
        isLoading = true
        
        do {
            userQuests = try await cloudKitService.fetchMyQuestRecords(accountID: accountID)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isLoading = false
    }
}

/*
 @MainActor final class DeleteStoryModel: ObservableObject {
 private static let logger = Logger(
 subsystem: "de.salman.RegioQuest",
 category: String(describing: DeleteStoryModel.self)
 )
 
 /*
  @Published var story: ModelStory = .init(
  userName: "",
  title: "",
  description: "",
  timestamp: Date.now
  )
  */
 @Published private(set) var isDeleting = false
 
 private let cloudKitService = CloudKitService()
 
 func deleteSelectedStory(atOffsets: ModelStory) async {
 isDeleting = true
 
 do {
 try await cloudKitService.delete(atOffsets.associatedRecord)
 } catch {
 Self.logger.error("\(error.localizedDescription, privacy: .public)")
 }
 
 isDeleting = false
 }
 }
 */
