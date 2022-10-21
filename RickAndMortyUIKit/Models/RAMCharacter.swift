//
//  RAMCharacter.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

struct RAMCharacter: ResponseDecodable, Identifiable {
    static var sampleJSON: String {
        """
        {
            "id": 0,
            "name": "Rick Sanchez",
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        }
        """
    }

    let id: Int
    let name: String
    let imageURLString: String

    enum CodingKeys: String, CodingKey {
        case imageURLString = "image"
        case id, name
    }

    var imageURL: URL { URL(string: imageURLString) ?? URL(string: "https://google.com")! }
}

struct RAMCharacterResult: ResponseDecodable {
    static var sampleJSON: String {
        """
        {
            "results": [\(RAMCharacter.sampleJSON)]
        }
        """
    }

    let results: [RAMCharacter]
}
