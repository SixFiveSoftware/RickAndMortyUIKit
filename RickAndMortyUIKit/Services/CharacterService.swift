//
//  CharacterService.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

enum CharacterService {
    case allCharacters
}

extension CharacterService: Service {
    typealias ResponseType = RAMCharacterResult

    var path: String { "character" }
    var method: ServiceMethod { .get }
}
