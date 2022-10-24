//
//  CharacterService.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

enum CharacterService {
    enum Status: String {
        case alive, dead, unknown
    }

    case allCharacters
    case status(Status)
}

extension CharacterService: Service {
    typealias ResponseType = RAMCharacterResult

    var path: String { "character" }
    var method: ServiceMethod { .get }

    var parameters: [String : Any]? {
        switch self {
        case .allCharacters:
            return nil
        case .status(let status):
            return ["status": status.rawValue]
        }
    }
}
