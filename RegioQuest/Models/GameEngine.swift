//
//  GameEngine.swift
//  RegioQuest
//
//  Created by Orhan Salman on 09.11.22.
//

import Foundation

struct GameEngine: Hashable, Codable, Identifiable {
    var id: Int
    var gameName: String
    var gameFilePath: String
    var gameMaxPoints: Int
    var gameMaxTimerTime: Int
    
    // User
    var timeConsumed: Int
    var points: Int
    var mistakes: Int
    var userHasFinishedTheGame: Bool
    
    
    struct Rating: Hashable, Codable {
        var stars: Int
        var badge: String
        var ratingPercent: Int
    }
    
    
    // MARK: --------------------------------------------------------------
    var buildRating: Rating

    mutating func Rating() -> Rating {
        
        var count = 0
        
        // First Star
        if (gameMaxPoints == points) {
            count += 1
        }
        // Second Star
        if (mistakes == 0) {
            count += 1
        }
        // Third star
        if (timeConsumed <= (gameMaxTimerTime / 2)) {
            count += 1
        }
        
        if(count == 3) {
            buildRating.ratingPercent = 100
        }
        else {
            // Berechne prozentuales Rating
            
            // 3 values: time, points, mistakes
            // ToDo: For now only default value
            buildRating.ratingPercent = 87
        }
        
        // Now set values to Rating Object
        buildRating.stars = count
        switch count {
        case 3:
            buildRating.badge = "Sehr Gut"
        case 2:
            buildRating.badge = "Gut"
        case 1:
            buildRating.badge = "Befriedigend"
        default:
            break
        }
        
        return buildRating
    }
}


/*
 // Timer
 let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 
 https://www.hackingwithswift.com/books/ios-swiftui/counting-down-with-a-timer
 */
