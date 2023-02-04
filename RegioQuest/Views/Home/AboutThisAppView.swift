//
//  AboutThisAppView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 08.12.22.
//

import SwiftUI
import UIKit
import WebKit

struct AboutThisAppView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    var youtubeId = "lacJwWZn5Ek"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        YouTubeView(videoId: youtubeId)
                            .padding()
                            .frame(height: UIScreen.main.bounds.height * 0.35)
                        Text("Erfahre mehr über diese App")
                            .font(.headline)
                    }
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .background {
                    Rectangle()
                        .stroke(Color(.tertiaryLabel), lineWidth: 2)
                        .shadow(color: .primary, radius: 15, x: 0, y: 0)
                        .clipped()
                        .padding(.horizontal, 10)
                        .scaleEffect(1, anchor: .center)
                }
                VStack(spacing: 15) {
                    Text("Spielerisch zum Ausbildungsplatz")
                        .font(.headline.weight(.bold))
                        .padding(.bottom)
                    HStack(spacing: 50) {
                        Button("An Umfrage teilnehmen") {
                            print("Pressed")
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    HStack {
                        HStack {
                            Divider()
                                .padding(.horizontal, 15)
                            
                            VStack(spacing: 5) {
                                Text("Um was geht es?")
                                    .font(.footnote.weight(.bold))
                                Text("Ziel von RegioQuest ist es die nachhaltige Entwicklung eines auf spielerischen und ortsbasierten Ansätzen basierenden Systems, um das Matching von Ausbildungsinhalten und -plätzen zwischen Jugendlichen und Unternehmen zu unterstützen. Dadurch soll die Eingliederung von jungen Menschen in das Erwerbsleben vereinfacht werden. Das System umfasst eine mobile Applikation, welche für jugendliche Nutzerinnen und Nutzer konzipiert ist, sowie eine Webanwendung, welche den Unternehmen Möglichkeiten zur Erstellung von Aufgaben (s.g. Quests) und dadurch die subtile Vermittlung von Ausbildungsangeboten sowie erste Kontaktmöglichkeiten auf eine spielerische Art und Weise bietet. Innerhalb des Entwicklungsprozesses werden alle relevanten Akteure gemeinsam im Sinne des partizipativen Ansatzes an der Fragestellung arbeiten wie der Zugang zum Ausbildungsmarkt in Südwestfalen, als exemplarische Modellregion für ganz Nordrhein-Westfalen, digital gedacht werden kann, um langfristig den Bedarf an Fachkräften in NRW zu sichern.")
                                    .font(.footnote.weight(.light))
                                Link("Mehr",
                                     destination: URL(string: "https://www.uni-siegen.de/start/news/oeffentlichkeit/952848.html")!)
                                
                                Spacer(minLength: 25)
                                
                                Text("Gamification")
                                    .font(.footnote.weight(.bold))
                                Text("Gamification ist ein Ansatz, bei dem spielerische Designelemente im nicht-spielerischen Kontext verwendet werden. ...")
                                    .font(.footnote.weight(.light))
                                
                                Spacer(minLength: 25)
                                
                                Text("Deine Meinung zählt")
                                    .font(.footnote.weight(.bold))
                                Text("Bei dieser RegioQuest App handelt es sich um einen Prototypen, der nicht die finale App repräsentiert. ... Funktionalitäten zeigen ... Interaktionen ... Design ... Daher sind wir auf euer Feedback angewiesen. Was gefällt euch bisher, und was eher weniger? Was möchtet Ihr in der fertigen App haben? Wie soll das Design aussehen? ... Nehmt bitte an der anonymisierten Umfrage teil und helft uns, euch und eure Freunde bei der Suche nach einem Ausbildungsplatz zu helfen.")
                                    .font(.footnote.weight(.light))
                            }
                            Divider()
                                .padding(.horizontal, 15)
                        }
                    }
                    Divider()
                        .padding(.horizontal, 30)

                }
                .padding(.horizontal, 10)
                .clipped()
            }
        }
        /*
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("An Umfrage teilnehmen") {
                    print("Pressed")
                }
                
                Link("Mehr",
                     destination: URL(string: "https://www.uni-siegen.de/start/news/oeffentlichkeit/952848.html")!)
            }
        }
        */
    }
}

struct YouTubeView: UIViewRepresentable {
    let videoId: String
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: "https://www.youtube-nocookie.com/embed/\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}

struct AboutThisAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutThisAppView()
    }
}
