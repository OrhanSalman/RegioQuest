//
//  SwiftUIView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 09.12.22.
//

import SwiftUI

struct SwiftUIView: View {
    @State var progressValue: CGFloat = 0.77
    @State var text = "Quote"
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack {
                    VStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.primary, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(.pink.opacity(0.6)))
                            .frame(width: 270, height: 190)
                            .clipped()
                            .shadow(color: .white.opacity(0.5), radius: 20, x: 0, y: 10)
                            .rotation3DEffect(.init(degrees: 13), axis: (x: 0, y: 1, z: 0))
                            .overlay {
                                VStack {
                                    Text("Quote")
                                }
                                .rotation3DEffect(.init(degrees: 13), axis: (x: 0, y: 1, z: 0))
                                .padding(10)
                            }
                    }
                    .offset(x: -30, y: -50)
                    Spacer()
                    VStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.primary, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(.pink.opacity(0.6)))
                            .frame(width: 270, height: 190)
                            .clipped()
                            .shadow(color: .white.opacity(0.5), radius: 20, x: 0, y: 10)
                            .rotation3DEffect(.init(degrees: 13), axis: (x: 0, y: -1, z: 0))
                            .overlay {
                                VStack {
                                    Text("asdasdasdasfasdfsadfsadfasdffasdfasfasfsdfasdfd")
                                }
                                .rotation3DEffect(.init(degrees: 13), axis: (x: 0, y: -1, z: 0))
                                .padding(10)
                            }
                    }
                    .offset(x: 30, y: 50)
                }
                .padding(.vertical, 50)
                Spacer()
            }
            .padding(.vertical, 100)
            .background {
                LinearGradient(gradient: Gradient(colors: [.indigo.opacity(0.9), Color(.systemGray2).opacity(0.25), .mint.opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .frame(width: UIScreen.main.bounds.width)
            
            HStack {
                ProgressBar(progress: 0.77, text: "Quote")
                Spacer()
                ProgressBar(progress: 0.53, text: "Fehler")
                Spacer()
                ProgressBar(progress: 0.26, text: "Erfolg")
            }
            .padding(.horizontal, 50)
        }
        .ignoresSafeArea()
    }
}
// Quest übersicht hier machen
struct ProgressBar: View {
    @State var progress: CGFloat
    @State var text: String
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Circle()
                        .stroke(
                            Color.pink.opacity(0.5),
                            lineWidth: 15
                        )
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.pink,
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                    // 1
                        .animation(.easeOut, value: progress)
                    Text("\(progress * 100, specifier: "%.0f") %")
                        .font(.title3)
                        .bold()
                }
                .frame(width: 80, height: 80)
            }
            Text(text)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            
    }
}
