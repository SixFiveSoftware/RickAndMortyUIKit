//
//  RAMCharacter.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

struct RAMCharacter: Decodable, Identifiable {
    let id: Int
    let name: String
    let imageURLString: String

    enum CodingKeys: String, CodingKey {
        case imageURLString = "image"
        case id, name
    }

    var imageURL: URL { URL(string: imageURLString) ?? URL(string: "https://google.com")! }
}

struct CharacterServiceResult: Decodable {
    let results: [RAMCharacter]
}
