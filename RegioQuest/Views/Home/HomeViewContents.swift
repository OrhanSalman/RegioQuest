//
//  HomeViewContents.swift
//  RegioQuest
//
//  Created by Orhan Salman on 16.12.22.
//

import Foundation

final class HomeViewContents: ObservableObject {
    
    @Published var homeViewContentsMap: [String] = [
        "map",
        "Entdecke deine Stadt",
        "Erforsche deine Region und die Vielzahl an Möglichkeiten, die sie bietet ",
        "mappin.and.ellipse",
        "Test",
        "Test",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test"
    ]
    @Published var homeViewContentsOrte: [String] = [
        "building.2.crop.circle",
        "Das wichtigste im Detail",
        "Entdecke interessante Quests von Unternehmen durch die Look Around Ansicht.",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test"
    ]
    @Published var homeViewContentsStories: [String] = [
        "person.wave.2",
        "Was deine Freunde und andere so erzählen",
        "Hast Du Schwierigkeiten mit einer Quest? Frag andere, oder informiere dich vorab.",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test"
    ]
    @Published var homeViewContentsInfo: [String] = [
        "info.square",
        "Unser Ziel",
        "Alles, was die RegioQuest App für dich bereithält",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test",
        "map",
        "Test",
        "Test"
    ]
}
