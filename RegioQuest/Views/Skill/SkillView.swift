//
//  ScoreView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 18.12.22.
//

import SwiftUI

struct SkillView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 30) {
                        ForEach(0..<6, id: \.self) { _ in
                            ZStack {
                                VStack(spacing: 90) {
                                    VStack {
                                        HStack {
                                            StyledGauge()
                                                .frame(width: 70, height: 70)
                                                .clipped()
                                            Spacer()
                                            VStack {
                                                Text("Skill-Fähigkeiten")
                                                    .font(.title3.weight(.bold))
                                                Text("Skill-Fähigkeiten")
                                                    .font(.callout)
                                                    .opacity(0.75)
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 10)
                                        Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
                                            .font(.callout)
                                            .opacity(0.75)
                                            .padding(.top, 10)
                                    }
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(Color(.quaternaryLabel).opacity(0.2))
                                        .scaleEffect(1.1, anchor: .center)
                                        .shadow(color: .orange.opacity(0.5), radius: 8, x: 0, y: 4)
                                }
                            }
                            Divider()
                                .padding(.horizontal, 15)
                                .clipped()
                                .font(.body.weight(.bold))
                        }
                    }
                    .padding()
                    .shadow(color: .secondary, radius: 48, x: 0, y: 4)
                }
                .background {
                    LinearGradient(gradient: Gradient(colors: [.indigo.opacity(0.9), Color(.systemGray2).opacity(0.25), .mint.opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .clipped()
                }
            }
        }
        .navigationTitle("Deine Skills")
        .padding(.bottom, 20)
//        .edgesIgnoringSafeArea(.all)
    }
}

struct StyledGauge: View {
    @State private var current = 67.0
    @State private var minValue = 50.0
    @State private var maxValue = 170.0
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    
    var body: some View {
        Gauge(value: current, in: minValue...maxValue) {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        } currentValueLabel: {
            Text("\(Int(current)) %")
                .foregroundColor(Color.green)
        } minimumValueLabel: {
            Text("\(Int(minValue))")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(Int(maxValue))")
                .foregroundColor(Color.red)
        }
        .gaugeStyle(.accessoryCircular)
        .tint(gradient)
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
