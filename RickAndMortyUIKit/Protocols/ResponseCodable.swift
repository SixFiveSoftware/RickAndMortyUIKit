//
//  ResponseCodable.swift
//  RickAndMortyUIKit
//
//  Created by BJ Miller on 8/26/22.
//

import Foundation

protocol ResponseCodable: ResponseEncodable & ResponseDecodable {}

/// Useful for converting an Encodable response object to encoded data for a mock response
protocol ResponseEncodable: Encodable {}

protocol ResponseDecodable: Decodable {
  static var sampleJSON: String { get }
  static var decoder: JSONDecoder { get }
}

extension ResponseDecodable {
  static var sampleData: Data {
    return sampleJSON.data(using: String.Encoding.utf8)!
  }

  static func sampleInstance() -> Self? {
    return try? decoder.decode(Self.self, from: sampleData)
  }

  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(customDateDecodingStrategy)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }

  private static var customDateDecodingStrategy: (Decoder) throws -> Date {
    return { decoder in
      let container = try decoder.singleValueContainer()
      let secondsSinceEpoch = try container.decode(Int.self)
      return Date(timeIntervalSince1970: Double(secondsSinceEpoch))
    }
  }
}

extension ResponseEncodable {

  var encoder: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
  }

  func asData() -> Data? {
    return try? encoder.encode(self)
  }

}

extension Array where Element: ResponseEncodable {

  private var encoder: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
  }

  func asData() -> Data? {
    return try? encoder.encode(self)
  }

}
