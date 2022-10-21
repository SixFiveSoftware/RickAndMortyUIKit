//
//  CharacterService.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

func fetchCharacters() async throws -> [RAMCharacter] {
    let url = URL(string: "https://rickandmortyapi.com/api/character")!
    let config = URLSessionConfiguration.ephemeral
    let (data, _) = try await URLSession(configuration: config).asyncData(from: url)
    return try JSONDecoder().decode(CharacterServiceResult.self, from: data).results
}

struct CharacterService: Service {
    typealias ResponseType = RAMCharacter

    var path: String { "character" }
    var method: ServiceMethod { .get }
}
