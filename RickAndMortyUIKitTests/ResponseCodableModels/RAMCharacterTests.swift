//
//  RAMCharacterTests.swift
//  RickAndMortyUIKitTests
//
//  Created by BJ Miller on 10/21/22.
//

@testable import RickAndMortyUIKit
import XCTest

final class RAMCharacterTests: XCTestCase {
    // MARK: system under test
    var sut: RAMCharacter?

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RAMCharacter.decode(from: RAMCharacter.sampleData)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testDecodingResponse() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.name, "Rick Sanchez")
        XCTAssertEqual(sut?.id, 0)
        XCTAssertEqual(sut?.imageURL.absoluteString, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
    }

}
