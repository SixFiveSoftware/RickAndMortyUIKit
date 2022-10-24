//
//  RAMLocation.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/24/22.
//

import Foundation

struct RAMLocation {
    let id: Int
    let name: String
    let type: String
    let dimension: String
}

extension RAMLocation: ResponseDecodable {
    static var sampleJSON: String {
        """
        {
            "id": 1,
            "name": "Earth",
            "type": "Planet",
            "dimension": "Dimension C-137"
        }
        """
    }

    var displayText: String { [name, type, dimension].joined(separator: ", ") }
}

struct RAMLocationResult {
    let results: [RAMLocation]
}

extension RAMLocationResult: ResponseDecodable {
    static var sampleJSON: String {
        """
        {
            "results": [\(RAMLocation.sampleJSON)]
        }
        """
    }
}
