//
//  User.swift
//  RegioQuest
//
//  Created by Orhan Salman on 09.11.22.
//
/*
import Foundation
import CoreLocation
import SwiftUI


struct User: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var email: String
    var region: String
    var userScore: UserScore?
    var education: String
    var job: String
    var preferences: UserPreferences
    var skills: UserSkills?
    
    
    private var userImage: String
    var image: Image {
        Image(userImage)
    }
    
    private var userLocation: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    struct UserScore: Hashable, Codable {
        var gameId: Int
        var gameName: String
        var game: GameEngine
    }
    
    struct UserSkills: Hashable, Codable {
        var id: Int
        var skill: Skill
        var userHasThisSkill: Bool
        var userHasProvedThisSkill: Bool
        
        mutating func proveSkill() {
            if(userHasThisSkill) {
                // ToDo: Default
                userHasProvedThisSkill = true
            } else {
                userHasProvedThisSkill = false
            }
        }
    }
    
    struct UserPreferences: Codable, Hashable {
        var contactOption: String
        var contactMyMail: Bool
        var contactMyPhone: Bool
    }
}
*/
