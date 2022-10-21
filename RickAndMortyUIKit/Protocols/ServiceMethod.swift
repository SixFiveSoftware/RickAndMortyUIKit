//
//  ServiceMethod.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/21/22.
//

import Foundation

enum ServiceMethod: String {
    case get
    case post
    case put
    case delete
    case patch
    case options
    case head
    case trace
    case connect

    var methodName: String { rawValue.uppercased() }
}
