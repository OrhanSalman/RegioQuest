//
//  BranchenView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 13.11.22.
//

import SwiftUI

struct BranchenList: Identifiable {
    let id: Int
    let name: String
    let gradient: LinearGradient
    let align: Alignment
}

struct BranchenView: View {
    
    @State var branchenList = [
        BranchenList(id: 1, name: "Bankwesen", gradient: LinearGradient(gradient: Gradient(colors: [.indigo, .cyan]), startPoint: .leading, endPoint: .trailing), align: .leading),
        BranchenList(id: 2, name: "Einzelhandel", gradient: LinearGradient(gradient: Gradient(colors: [Color(.systemBrown), Color(.displayP3, red: 183/255, green: 167/255, blue: 149/255)]), startPoint: .leading, endPoint: .trailing), align: .trailing),
        BranchenList(id: 3, name: "Beamte", gradient: LinearGradient(gradient: Gradient(colors: [.secondary, .secondary.opacity(0.25)]), startPoint: .leading, endPoint: .trailing), align: .leading),
        BranchenList(id: 4, name: "Verwaltung", gradient: LinearGradient(gradient: Gradient(colors: [.pink, .black]), startPoint: .leading, endPoint: .trailing), align: .trailing),
        BranchenList(id: 5, name: "Industrie", gradient: LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemFill)]), startPoint: .trailing, endPoint: .leading), align: .leading)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(branchenList) { branche in
                    NavigationLink(destination: QuestView()) {
                        Image("twinlake")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / 1.3, height: UIScreen.main.bounds.height * 0.35)
                            .clipped()
                            .overlay(alignment: .bottomLeading) {
                                HStack {
                                    Text(branche.name)
                                    Spacer()
                                    Image(systemName: "plus")
                                }
                                .padding()
                                .foregroundColor(.white)
                                .font(.title3.weight(.semibold))
                            }
                            .mask {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                            }
                            .padding(3)
                            .background(alignment: .bottom) {
                                branche.gradient
                                    .mask {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    }
                            }
                            .frame(maxWidth: .infinity, alignment: branche.align)
                            .clipped()
                    }
                }
            }
            .padding()
            .padding(.bottom)
            .navigationTitle("Branchen")
        }
        .padding(.top, 0.3)
    }
}

struct BranchenView_Previews: PreviewProvider {
    static var previews: some View {
        BranchenView()
    }
}
