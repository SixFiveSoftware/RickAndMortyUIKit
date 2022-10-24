//
//  Interactor.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/24/22.
//

import Foundation

enum ViewState {
    case loading
    case characters([RAMCharacter])
    case aliveCharacters([RAMCharacter])
    case locations
    case error(Error)
}

@MainActor
class Interactor {

    @Published var currentState: ViewState = .loading

    private let client = APIClient()

    func fetchAllCharacters() {
        currentState = .loading
        Task {
            do {
                let characters = try await client.fetch(service: CharacterService.allCharacters).results
                currentState = .characters(characters)
            } catch {
                currentState = .error(error)
            }
        }
    }

    func fetchAliveCharacters() {
        currentState = .loading
        Task {
            do {
                let characters = try await client.fetch(service: CharacterService.status(.alive)).results
                currentState = .aliveCharacters(characters)
            } catch {
                currentState = .error(error)
            }
        }
    }
}
