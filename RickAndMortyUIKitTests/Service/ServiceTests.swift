//
//  ServiceTests.swift
//  RickAndMortyUIKitTests
//
//  Created by BJ Miller on 10/21/22.
//

@testable import RickAndMortyUIKit
import XCTest

final class ServiceTests: XCTestCase {

    // MARK: private mock structs
    private struct MockService: Service {
        typealias ResponseType = RAMCharacter
        var baseURL: String { "https://rickandmortyapi.com" }
        var path: String { "api/character" }
        var method: RickAndMortyUIKit.ServiceMethod { .get }
    }

    private struct MockServiceWithParams: Service {
        typealias ResponseType = RAMCharacter
        var baseURL: String { "https://rickandmortyapi.com" }
        var path: String { "api/character" }
        var method: RickAndMortyUIKit.ServiceMethod { .get }
        var parameters: [String : Any]? { ["name": "Rick Sanchez", "status": "alive"] }
    }

    // MARK: system under test
    private var sut: (any Service)!

    // MARK: setup
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockService()
    }

    // MARK: tear down
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: tests
    func testFormattedPath() {
        guard let url = sut.urlRequest.url else { XCTFail("URL should be created from service object"); return }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertNil(components?.queryItems)
        XCTAssertEqual(components?.path, "/api/character/")
        XCTAssertEqual(url.absoluteString, "https://rickandmortyapi.com/api/character/")
    }

    func testQueryParameters() {
        sut = MockServiceWithParams()
        guard let url = sut.urlRequest.url else { XCTFail("URL should be created from service object"); return }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = components?.queryItems else { XCTFail("queryItems should not be nil"); return }
        XCTAssertEqual(queryItems.count, 2)

        let nameQueryItem = URLQueryItem(name: "name", value: "Rick Sanchez")
        let statusQueryItem = URLQueryItem(name: "status", value: "alive")
        XCTAssertTrue(queryItems.contains(nameQueryItem))
        XCTAssertTrue(queryItems.contains(statusQueryItem))
    }
}
