//
//  Local.swift
//  RegioQuest
//
//  Created by Orhan Salman on 18.11.22.
//

import Foundation
import SwiftUI

struct Local: Identifiable {
    
    var id: UUID?
    var latitude: Double?
    var longitude: Double?
}

class LocalViewModel: ObservableObject {
    @Published var local : [Local]
    
    init(items: [Local]) {
        self.local = items
    }
}
