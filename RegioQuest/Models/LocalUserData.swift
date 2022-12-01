//
//  LocalUserData.swift
//  RegioQuest
//
//  Created by Orhan Salman on 25.11.22.
//

import Foundation

struct LocalUserData: Codable, Hashable, Identifiable {
    let id: UUID
    var latitude: Double?
    var longitude: Double?
    
    init(id: UUID, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    /*
    private var userLocation: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude)
    }
     */
}
