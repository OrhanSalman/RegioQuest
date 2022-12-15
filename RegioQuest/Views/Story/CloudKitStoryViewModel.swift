//
//  StoryViewModel.swift
//  RegioQuest
//
//  Created by Orhan Salman on 12.12.22.
//
import Foundation
import OSLog
import SwiftUI

@MainActor final class CreateStoryModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: CreateStoryModel.self)
    )
    
    @Published var story: ModelStory = .init(
        userName: "",
        title: "",
        description: "",
        timestamp: Date.now
    )
    @Published private(set) var isSaving = false
    
    private let cloudKitService = CloudKitService()
    
    func save() async {
        isSaving = true
        
        do {
            try await cloudKitService.save(story.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isSaving = false
    }
}

@MainActor final class FetchStoryModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: FetchStoryModel.self)
    )

    @Published private(set) var allStories: [ModelStory] = []
    @Published private(set) var isLoading = false

    private let cloudKitService = CloudKitService()

//    @AppStorage("userName") var userNameForOwnOrNotFilter: String?
    
    func fetch() async {
        isLoading = true

        do {
            allStories = try await cloudKitService.fetchStoryRecords()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }

        isLoading = false
    }
    /*
    func fetchMyStories() async {
        isLoading = true

        do {
            allStories = try await cloudKitService.fetchMyStoryRecords(in: userNameForOwnOrNotFilter ?? "")
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }

        isLoading = false
    }
     */
}


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
            try await cloudKitService.delete(atOffsets.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isDeleting = false
    }
}
