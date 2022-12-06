//
//  SkillView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 19.11.22.
//

import SwiftUI
import Foundation
struct SkillView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ User.id, ascending: true)], animation: .default) private var skill: FetchedResults<Skill>
    
    @State private var current = 67.0
    @State private var minValue = 0.0
    @State private var maxValue = 170.0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(skill) { data in
                Gauge(value: current, in: minValue...maxValue) {
                    Text("BPM")
                } currentValueLabel: {
                    Text("\(Int(current))")
                } minimumValueLabel: {
                    Text("\(Int(minValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxValue))")
                }
                .onAppear {
                    print(data.userSkill ?? "Nein")
                }
            }
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
