//
//  LocationService.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/24/22.
//

import Foundation

enum LocationService {
    case allLocations
}

extension LocationService: Service {
    typealias ResponseType = RAMLocationResult

    var path: String { "location" }
    var method: ServiceMethod { .get }
}
