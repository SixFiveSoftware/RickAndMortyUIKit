//
//  Service.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 10/20/22.
//

import Foundation

protocol Service {
    /// ResponseType is a type that is provided by a conforming Service as the type to be used when parsing the response
    associatedtype ResponseType: ResponseDecodable

    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: ServiceMethod { get }
    var body: Data? { get }
}

extension Service {
    // MARK: default implementations
    var parameters: [String: Any]? { nil }
    var body: Data? { nil }

    // MARK: computed request
    var urlRequest: URLRequest {
        guard let url = url else { fatalError("URL could not be formed") }
        var request = URLRequest(url: url)
        request.httpBody = body
        request.httpMethod = method.methodName
        return request
    }

    // MARK: private
    private var formattedPath: String {
        let prepended = path.starts(with: "/") ? path : "/" + path
        let formatted = prepended.hasSuffix("/") ? prepended : prepended + "/"
        return formatted
    }

    private var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = formattedPath

        if method == .get, let params = parameters as? [String: String] {
            components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        return components?.url
    }
}
