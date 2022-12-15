//
//  SkillView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI
import Foundation
struct SkillView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ User.id, ascending: true)], animation: .default) private var skill: FetchedResults<Skill>
    
    @State private var current = 67.0
    @State private var minValue = 0.0
    @State private var maxValue = 100.0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(0..<10, id: \.self) { _ in
//            ForEach(skill) { data in
                Gauge(value: Double.random(in: 1...100), in: minValue...maxValue) {
//                Gauge(value: current, in: minValue...maxValue) {
                    Text("Skill")
                } currentValueLabel: {
                    Text("\(Int(current))")
                } minimumValueLabel: {
                    Text("\(Int(minValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxValue))")
                }
            }
        }
        .padding(.all, 20)
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
