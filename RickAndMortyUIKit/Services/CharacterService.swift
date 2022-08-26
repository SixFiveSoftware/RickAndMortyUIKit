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
            print("In asyncData, step 1.")
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("In asyncData, step 2. starting completion handler")
                if let error = error {
                    print("In asyncData, encountered an error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("In asyncData, response is httpResponse.")
                    if 200..<300 ~= httpResponse.statusCode {
                        print("In asyncData, status code is good! \(httpResponse.statusCode)")
                        if let data = data {
                            print("In asyncData, data is good. returning!")
                            continuation.resume(returning: (data, httpResponse))
                        } else {
                            print("In asyncData, failed to decode.")
                            continuation.resume(throwing: Errors.CharacterService.failedToDecode)
                        }
                    } else {
                        print("In asyncData, invalid status code (\(httpResponse.statusCode). \(error?.localizedDescription ?? "---")")
                        continuation.resume(throwing: Errors.CharacterService.invalidStatusCode)
                    }
                } else {
                    print("In asyncData, unknown error. \(error?.localizedDescription ?? "---")")
                    continuation.resume(throwing: Errors.CharacterService.failed)
                }
            }.resume()
        }
    }
}
