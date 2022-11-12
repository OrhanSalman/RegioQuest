//
//  ModelData.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var jobsDataStorage: [Job] = load("Job.json")
    @Published var userDataStorage: [User] = load("User.json")
    @Published var skillDataStorage: [Skill] = load("Skill.json")
//    @Published var gameEngineDataStorage: [GameEngine] = load("GameEngine.json")
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
