//
//  Shuffle_SongsTests.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import XCTest
@testable import Shuffle_Songs

class Shuffle_SongsTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSongAttributes() {
        let attributes: [String: Any] = ["artistName": "MC Arianne", "trackName": "Amor de Anteontem"]
        
        let song = DictionaryDecoder.decode(Song.self, from: attributes)
        
        XCTAssertEqual(song?.artistName, "MC Arianne")
        XCTAssertEqual(song?.trackName, "Amor de Anteontem")
    }
    
}
