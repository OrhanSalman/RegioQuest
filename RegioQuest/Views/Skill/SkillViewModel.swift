//
//  SkillViewModel.swift
//  RegioQuest
//
//  Created by Orhan Salman on 18.12.22.
//
import Foundation
import OSLog
import SwiftUI
import CloudKit

@MainActor final class CreateSkillModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: CreateSkillModel.self)
    )
    @Published var skill: ModelSkill = .init(
        name: "",
        pointsAtLeast: 0,
        maxPoints: 0,
        associatedRecord: CKRecord(recordType: "Skill")
    )
    @Published private(set) var isSaving = false
    
    private let cloudKitService = CloudKitService()
    
    func save() async {
        isSaving = true
        
        do {
            try await cloudKitService.save(skill.record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isSaving = false
    }
}

@MainActor final class FetchSkillModel: ObservableObject {
    private static let logger = Logger(
        subsystem: "de.salman.RegioQuest",
        category: String(describing: FetchSkillModel.self)
    )
    
    @Published private(set) var allSkills: [ModelSkill] = []
    @Published private(set) var userSkills: [ModelSkill] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleting = false
    
    private let cloudKitService = CloudKitService()
    
    func fetch() async {
        isLoading = true
        
        do {
            allSkills = try await cloudKitService.fetchSkillRecords()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isLoading = false
    }
    
    func fetchMySkills(accountID: CKRecord.ID) async {
        isLoading = true
        
        do {
            userSkills = try await cloudKitService.fetchMySkillRecords(accountID: accountID)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
        
        isLoading = false
    }
}

/*
 @MainActor final class DeleteSkillModel: ObservableObject {
 private static let logger = Logger(
 subsystem: "de.salman.RegioQuest",
 category: String(describing: DeleteSkillModel.self)
 )
 
 /*
  @Published var skill: ModelSkill = .init(
  userName: "",
  title: "",
  description: "",
  timestamp: Date.now
  )
  */
 @Published private(set) var isDeleting = false
 
 private let cloudKitService = CloudKitService()
 
 func deleteSelectedSkill(atOffsets: ModelSkill) async {
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
