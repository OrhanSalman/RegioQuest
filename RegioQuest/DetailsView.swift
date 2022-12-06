//
//  DetailsView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 16.11.22.
//

import SwiftUI
import CloudKit
import CoreData

struct DetailsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    
    @Namespace var topID
    @Namespace var bottomID
    
    var body: some View {
        
        
        
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation {
                                proxy.scrollTo(topID)
                            }
                        } label: {
                            Image(systemName: "chevron.down.square")
                                .imageScale(.large)
                                .symbolRenderingMode(.hierarchical)
                                .scaleEffect(1.4, anchor: .center)
                                .padding(.trailing, 20)
                        }
                        .id(bottomID)
                        
                        
                        
                    }
                }
                
                VStack {
                    ForEach(1..<100) { i in
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(.systemBackground))
                            .overlay {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "info.square.fill")
                                            .imageScale(.medium)
                                            .symbolRenderingMode(.monochrome)
                                            .foregroundColor(.indigo)
                                    }
                                    Divider()
                                        .opacity(1)
                                    Spacer()
                                    HStack {
                                        Text("@Storyteller")
                                            .font(.subheadline.weight(.thin))
                                        Spacer()
                                    }
                                }
                                .padding()
                            }
                            .frame(height: 200)
                            .clipped()
                            .shadow(color: .primary.opacity(0.5), radius: 14, x: 0, y: 14)
                            .padding(20)
                    }
                }

                
                
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                proxy.scrollTo(bottomID)
                            }
                        } label: {
                            Image(systemName: "chevron.up.square")
                                .imageScale(.large)
                                .symbolRenderingMode(.hierarchical)
                                .scaleEffect(1.4, anchor: .center)
                                .padding(.trailing, 20)
                        }
                        .id(topID)
                    }
                }
            }
            .scrollDisabled(true)

            
        }
        

    }
    
    func color(fraction: Double) -> Color {
        Color(red: fraction, green: 1 - fraction, blue: 0.5)
    }
    
    private func myUserFunc() async -> FetchedResults<User> {
        viewContext.performAndWait {
            @FetchRequest(
                sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
                animation: .default) var user: FetchedResults<User>
        }
        return user
    }
    
    
    func processFetchUser() async {
        Task { @MainActor in
            await myUserFunc()
//            await fetchUser(viewContext: viewContext)
        }
    }
    func fetchUser(viewContext: NSManagedObjectContext) async -> [User] {

        let request: NSFetchRequest<User> = User.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        guard let result = try? viewContext.fetch(request) else {
            return []
        }
        return result
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

