//
//  Job.swift
//  RegioQuest
//
//  Created by Orhan Salman on 09.11.22.
//

import Foundation
import CoreLocation
import SwiftUI

struct Job: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var company: JobBelongsToCompany
// ToDo    var gameId: Int
    
    private var questCoordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: questCoordinates.latitude,
            longitude: questCoordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    struct JobBelongsToCompany: Hashable, Codable {
        var companyName: String
        var contact: String
        var companyImage: String
        var url: URL
        var image: Image {
            Image(companyImage)
        }
    }
}
