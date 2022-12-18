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
        "Erforsche deine Region und die Vielzahl an Möglichkeiten die sie zu bieten hat",
        "mappin.and.ellipse",
        "Ausbildungen",
        "Löse Quests und erhalte eine Einladung von Unternehmen, die deinen Vorstellungen entsprechen. ",
        "sparkle.magnifyingglass",
        "Erhalte vorab Einblicke in Unternehmen",
        "Entdecke Insidereinblicke in Unternehmen und ihren Beschäftigungsmöglichkeiten",
        "arrowshape.turn.up.left.2.fill",
        "Navigation",
        "Tippe auf Kartenmarkierungen und lass dich zum Ziel navigieren"
    ]
    @Published var homeViewContentsOrte: [String] = [
        "building.2.crop.circle",
        "Das wichtigste im Detail",
        "Smarte Funktionen für eine effektive Suche",
        "binoculars.fill",
        "Streetmap",
        "Die Look Around Ansicht ermöglicht es dir bequem von zuhause Unternehmen und ihre Quests zu entdecken.",
        "star.fill",
        "Lege deine Favoriten fest",
        "Favorisiere für dich in Frage kommende Ausbildungsangebote ",
        "bell.fill",
        "Lass dich benachrichten",
        "Erhalte automatische Benachrichtigungen durch die App wenn Du dich in der Nähe einer Quest befindest"
    ]
    @Published var homeViewContentsStories: [String] = [
        "person.wave.2",
        "Was deine Freunde und andere so erzählen",
        "Hast Du Schwierigkeiten mit einer Quest? Frag andere oder lies, was sie zu erzählen haben",
        "person.3.sequence.fill",
        "Kontaktliste",
        "Füge deine Freunde in deine Kontaktliste ein",
        "map",
        "Sharing",
        "Teile deinen Score mit deinen Freunden",
        "square.and.arrow.up.fill",
        "Test",
        "Test"
    ]
    @Published var homeViewContentsInfo: [String] = [
        "info.square",
        "Unser Ziel",
        "Alles, was die RegioQuest App für dich bereithält",
        "flag.2.crossed.fill",
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


// Multiplayer game, ar, location tracking, pokemon
