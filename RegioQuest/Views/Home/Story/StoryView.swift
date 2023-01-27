//
//  StoryView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 14.11.22.
//

import SwiftUI
import CloudKit

enum Filter {
    case all, friends, own
}

struct StoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFilter: Filter = .all
    @State private var addStory: Bool = false
    @StateObject private var vm = FetchStoryModel()
    //    @State private var presentStory: Bool = false
    @State private var isAddStoryDisabled: Bool = false
    @State private var accountID: CKRecord.ID?
    @State var activate: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                
                switch self.selectedFilter {
                case .all:
                    VStack {
                        if vm.allStories.isEmpty {
                            Text("Keine Stories gefunden. Sei der Erste!")
                                .padding(20)
                        }
                        else {
                            ShowStoryView(dataset: vm.allStories, isDeleteDisabled: true)
                        }
                    }
                    .task {
                        await whichToFetch()
                    }
                case .friends:
                    Text("Not implemented yet")
                case .own:
                    VStack {
                        if vm.userStories.isEmpty {
                            Text("Du hast noch keine Story veröffentlicht.")
                                .padding(20)
                        }
                        else {
                            ShowStoryView(dataset: vm.userStories, isDeleteDisabled: false)
                        }
                    }
                    .task {
                        await whichToFetch()
                    }
                }
            }
        }
        .redacted(reason: vm.isLoading ? .placeholder : [])
        .refreshable {
            Task {
                await whichToFetch()
            }
        }
        .task {
            if (user.isEmpty) {
                isAddStoryDisabled = true
            }
            else if (!user.isEmpty) {
                isAddStoryDisabled = false
            }
            Task {
                await whichToFetch()
            }
        }
        .toolbar {
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
                    .disabled(isAddStoryDisabled)
                    
                    Button(action: {
                        Task {
                            await whichToFetch()
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })

                    NavigationLink(destination: {
                        AddStoryView()
                    }, label: {
                        Label("Filter", systemImage: "plus")
                    }).disabled(isAddStoryDisabled)
                }
            }
        }
    }
    func whichToFetch() async {
        if selectedFilter == .all {
            Task {
                await vm.fetch()
            }
        }
        else if selectedFilter == .own {
            Task {
                iCloudUserIDAsync { (recordID: CKRecord.ID?, error: NSError?) in
                    if let userID = recordID {
                        accountID = userID
                        callMyStoriesFunction()
                    } else {
                        debugPrint(error)
                        print("Fetched iCloudID was nil")
                    }
                }
            }
        }
        else if selectedFilter == .friends {
            print("Friends not implemented")
        }
        else {
            print("Error in selected Filter")
        }
    }
    func callMyStoriesFunction() {
        Task {
            await vm.fetchMyStories(accountID: accountID!)
        }
    }
    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error as NSError?)
                self.accountID = recordID
            } else {
                complete(recordID, nil)
            }
        }
    }
}

struct AddStoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    
    @StateObject private var vm = CreateStoryModel()
    @Environment(\.dismiss) var dismiss
    
    @State var showAlert = false
    
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
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Gespeichert"), message: Text("Es kann ein paar Minuten dauern, bis deine Story sichtbar wird. Aktualisiere die Seite zwischendurch."), dismissButton: .default(Text("Ok")))
        })
        .navigationBarTitle("Neue Story erzählen", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Speichern", action: {
                    Task {
                        vm.story.userName = user[0].name ?? "Kein Username"
                        await vm.save()
                        showAlert = true
                    }
                    dismiss()
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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    @StateObject private var vm = FetchStoryModel()
    @State private var presentStory: Bool = false
    @State private var showDetailScreen: Bool = false
    @State var dataset: [ModelStory]
    @State var isDeleteDisabled: Bool
    
    var body: some View {
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
                .deleteDisabled(isDeleteDisabled)
                .transition(.scale)
                /*
                 .onTapGesture {
                 presentStory.toggle()
                 }
                 */
                .sheet(isPresented: $presentStory, content: {
                    StorytellerSheet()
                })
                .contextMenu {
                    Group(content: {
                        Button("Bearbeiten", action: {
                            
                            print("\(data.description)")
                        })
                        Button(role: .destructive) {
                            // Remove from CloudKit
                            if let index = dataset.firstIndex(of: data) {
                                dataset.remove(at: index)
                            }
                            // Remove from dataset
                            sendToDelete(atOffsets: data)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    })
                    .disabled(isDeleteDisabled)
                }
            }
        }
    }
    func sendToDelete(atOffsets: ModelStory) {
        Task {
            await vm.deleteSelectedStory(atOffsets: atOffsets)
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

// To check an optional string if it's empty
extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
