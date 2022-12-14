//
//  StoryView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 14.11.22.
//

import SwiftUI

enum Filter {
    case all, friends, own
}

struct StoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: Filter = .all
    @State private var addStory: Bool = false
    @StateObject private var vm = FetchStoryModel()
    @State private var presentStory: Bool = false
    @AppStorage("userName") var userNameForOwnOrNotFilter: String?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                
                if vm.allStories.isEmpty {
                    Text("Lade Daten")
                        .onAppear {
                            Task {
                                await vm.fetch()
                            }
                        }
                }
                else {
                    switch self.selectedFilter {
                    case .all:
                        ShowStoryView(dataset: vm.allStories)
                    case .friends:
                        Text("Not implemented yet")
                    case .own:
                        ShowStoryView(dataset: vm.allStories.filter({ ($0.userName.contains(userNameForOwnOrNotFilter!))
                        }))
                    }
                }
            }
        }
        .redacted(reason: vm.isLoading ? .placeholder : [])
        .refreshable {
            await vm.fetch()
        }
        .task {
            await vm.fetch()
        }
        /*
         .sheet(isPresented: $addStory, content: {
         AddStoryView()
         })
         */
        .toolbar {
            /*
             ToolbarItem(placement: .navigationBarTrailing, content: {
             Menu("Filter") {
             Picker("Filter", selection: $selectedFilter) {
             Text("Alle").tag(Filter.all)
             Text("Freunde").tag(Filter.friends)
             Text("Eigene").tag(Filter.own)
             }
             }
             })
             */
            /*
             ToolbarItem(placement: .navigationBarTrailing) {
             EditButton()
             }
             */
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Menu {
                        Picker("Filter", selection: $selectedFilter) {
                            Text("Alle").tag(Filter.all)
                            Text("Freunde").tag(Filter.friends)
                            Text("Eigene").tag(Filter.own)
                        }
                        .pickerStyle(InlinePickerStyle())
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    
                    
                    Button(action: {
                        Task {
                            await vm.fetch()
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                    
                    NavigationLink(destination: {
                        AddStoryView()
                    }, label: {
                        Label("Filter", systemImage: "plus")
                    })
                }
                
            }
            /*
             ToolbarItem(placement: .navigationBarTrailing) {
             NavigationLink(destination: {
             AddStoryView()
             }, label: {
             Label("Filter", systemImage: "plus")
             })
             }
             */
        }
    }
}

struct AddStoryView: View {
    @StateObject private var vm = CreateStoryModel()
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("userId") var userId: UUID?
    @AppStorage("userName") var userName: String?
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Überschrift", text: $vm.story.title)
                TextField("Deine Story", text: $vm.story.description, axis: .vertical)
                    .cornerRadius(6.0)
                    .multilineTextAlignment(.leading)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle("Neue Story erzählen", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Speichern", action: {
                    Task {
                        vm.story.userName = userName ?? "Kein Username"
                        await vm.save()
                        dismiss()
                    }
                })
                .disabled(vm.story.title.isEmpty || vm.story.description.isEmpty)
            }
        }
    }
}

struct DetailsStoryView: View {
    @State var content: ModelStory
    var body: some View {
        VStack {
            Text(content.title)
            Text(content.description)
            Text(content.userName)
            Text(content.timestamp, style: .date)
            Text(content.timestamp, style: .time)
        }
    }
}

struct ShowStoryView: View {
    @StateObject private var vm = FetchStoryModel()
    @State private var presentStory: Bool = false
    @State private var showDetailScreen: Bool = false
    @State var dataset: [ModelStory]
    
    var body: some View {
        if dataset.isEmpty {
            Text("Es gibt noch keine Stories")
        }
        else {
            ForEach(dataset, id: \.self) { data in
                withAnimation {
                    VStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(.systemBackground))
                            .overlay {
                                VStack {
                                    HStack {
                                        Text(data.title)
                                            .clipped()
                                            .font(.headline.weight(.bold))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .lineLimit(1)
                                        Spacer()
                                        Image(systemName: "eye.fill")
                                            .imageScale(.medium)
                                            .symbolRenderingMode(.monochrome)
                                            .foregroundColor(.indigo)
                                    }
                                    Divider()
                                        .opacity(1)
                                    HStack {
                                        ScrollView(.vertical, showsIndicators: true) {
                                            VStack {
                                                Text(data.description)
                                                    .font(.footnote.weight(.regular))
                                            }
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                    
                                    HStack {
                                        Text("@\(data.userName)")
                                            .font(.caption.weight(.light))
                                        Spacer()
                                        Text(data.timestamp, style: .date)
                                            .font(.caption.weight(.thin))
                                        Text(data.timestamp, style: .time)
                                            .font(.caption.weight(.thin))
                                    }
                                }
                                .padding()
                                .onTapGesture {
                                    showDetailScreen.toggle()
                                }
                                .sheet(isPresented: $showDetailScreen, content: {
                                    DetailsStoryView(content: data)
                                })
                            }
                            .frame(height: 200)
                            .clipped()
                            .shadow(color: .primary.opacity(0.5), radius: 14, x: 0, y: 14)
                            .padding(20)
                        
                    }
                    .transition(.scale)
                    .onTapGesture {
                        presentStory.toggle()
                    }
                    .sheet(isPresented: $presentStory, content: {
                        StorytellerSheet()
                    })
                }
            }
        }
    }
}

struct StorytellerSheet: View {
    var body: some View {
        VStack {
            Text("StorytellerSheet")
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
