//
//  ThumbnailImageActor.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/21/22.
//

import UIKit

actor ThumbnailImageActor {
    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }

    private enum FetcherError: Error {
        case badImageData
    }

    private var images: [URLRequest: LoaderStatus] = [:]

    func fetch(_ url: URL) async throws -> UIImage? {
        try await fetch(URLRequest(url: url))
    }

    func fetch(_ request: URLRequest) async throws -> UIImage {
        if let status = images[request] {
            switch status {
            case .fetched(let image): return image
            case .inProgress(let task): return try await task.value
            }
        }

        let task: Task<UIImage, Error> = Task {
            let imageData = try await URLSession.asyncDataRequest(from: request)
            if let image = UIImage(data: imageData) {
                return image
            } else {
                throw FetcherError.badImageData
            }
        }

        images[request] = .inProgress(task)
        let image = try await task.value
        images[request] = .fetched(image)
        return image
    }
}
