//
//  Array+Extensions.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/21/22.
//

import Foundation

extension Array: ResponseDecodable where Element: ResponseDecodable {
    static var sampleJSON: String {
        "[]"
    }
}
