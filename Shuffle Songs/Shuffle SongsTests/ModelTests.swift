//
//  ModelTests.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import XCTest
@testable import Shuffle_Songs

class ModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSongAttributes() {
        let attributes: [String: Any] = ["artistName": "MC Arianne", "trackName": "Amor de Anteontem", "artworkUrl": "https://url.com"]
        
        let song = Song(fromAttributes: attributes)
        
        XCTAssertEqual(song.artistName, "MC Arianne")
        XCTAssertEqual(song.trackName, "Amor de Anteontem")
        XCTAssertEqual(song.artworkUrl, "https://url.com")
        XCTAssertNil(song.artworkData)
    }

}
