//
//  APIClient.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/21/22.
//

import Foundation

struct APIClient {
    func fetch<S: Service>(service: S) async throws -> S.ResponseType {
        do {
            let data = try await URLSession.asyncDataRequest(from: service.urlRequest)
            let decoded = try S.ResponseType.decode(from: data)
            return decoded
        } catch {
            throw error
        }
    }
}
