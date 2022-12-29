//
//  StoryViewModel.swift
//  RegioQuest
//
//  Created by Orhan Salman on 12.12.22.
//
import Foundation
import OSLog
import SwiftUI
import CloudKit

@MainActor final class CreateStoryModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: CreateStoryModel.self)
    )
    @Published var story: ModelStory = .init(
        userName: "",
        title: "",
        description: "",
        timestamp: Date.now,
        associatedRecord: CKRecord(recordType: "Story")
    )
    @Published private(set) var isSaving = false
    
    private let cloudKitService = CloudKitService()
    
    @StateObject private var pushService = PushNotificationService()
    
    func save() async {
        isSaving = true
        
        do {
            try await cloudKitService.save(story.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        print("WICHTIG: \(story.title)")
        pushService.subscribeToNotifications(body: story.title)
        isSaving = false
    }
}

@MainActor final class FetchStoryModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: FetchStoryModel.self)
    )
    
    @Published private(set) var allStories: [ModelStory] = []
    @Published private(set) var userStories: [ModelStory] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleting = false
    
    private let cloudKitService = CloudKitService()
    
    func fetch() async {
        isLoading = true
        
        do {
            allStories = try await cloudKitService.fetchStoryRecords()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isLoading = false
    }
    
    func fetchMyStories(accountID: CKRecord.ID) async {
        isLoading = true
        
        do {
            userStories = try await cloudKitService.fetchMyStoryRecords(accountID: accountID)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isLoading = false
    }
    
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
