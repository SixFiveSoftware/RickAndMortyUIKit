//
//  CharacterService.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

func fetchCharacters() async throws -> [RAMCharacter] {
    let url = URL(string: "https://rickandmortyapi.com/api/character")!
    let config = URLSessionConfiguration.ephemeral
    let (data, _) = try await URLSession(configuration: config).asyncData(from: url)
    return try JSONDecoder().decode(CharacterServiceResult.self, from: data).results
}

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
