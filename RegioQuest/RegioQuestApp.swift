//
//  RegioQuestApp.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI

@main
struct RegioQuestApp: App {
    
    let cloudPersistanceController = CoreDataStack.shared
    @AppStorage("userOnboarded") var userOnboarded: Bool = false
    
    var body: some Scene {
        WindowGroup {
            
            if userOnboarded {
                MainView()
                    .environment(\.managedObjectContext, cloudPersistanceController.context)
            }
            else {
                VStack {
                    HStack {
                        Text("Regionale Karriere App")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 76)
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .leading, spacing: 11) {
                        Text("Universitätsstadt Siegen")
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipped()
                        Text("Lerne deine Stadt und ihre vielfältigen Angebote an Karrieremöglichkeiten besser kennen")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.white)
                        
                        ZStack(alignment: .topLeading) {
                            Button(action: {
                                userOnboarded = true
                            }){
                                Text("Loslegen")
                                    .font(.system(.body, design: .serif))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 15)
                                    .background(.green)
                                    .foregroundColor(.black)
                                    .mask { RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    }
                                    .padding(.top, 8)
                                    .shadow(color: .white.opacity(1.0), radius: 20, x: 0, y: 5)
                            }
                            
                        }
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                        .frame(height: 70)
                        .clipped()
                }
                .background {
                    Image("siegenufer")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
