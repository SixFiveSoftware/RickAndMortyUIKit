//
//  URLSession+Async.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/21/22.
//

import Foundation

extension URLSession {
    func asyncData(from url: URL) async throws -> (Data, HTTPURLResponse) {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, HTTPURLResponse), Error>) in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if 200..<300 ~= httpResponse.statusCode {
                        if let data = data {
                            continuation.resume(returning: (data, httpResponse))
                        } else {
                            continuation.resume(throwing: Errors.CharacterService.failedToDecode)
                        }
                    } else {
                        continuation.resume(throwing: Errors.CharacterService.invalidStatusCode)
                    }
                } else {
                    continuation.resume(throwing: Errors.CharacterService.failed)
                }
            }.resume()
        }
    }

    // BJ: was going to work on a generic async/await fetcher that parses based on the model's ResponseDecodable info

}
