//
//  Errors.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

enum Errors {
    enum CharacterService: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
}
