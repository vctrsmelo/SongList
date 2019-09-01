//
//  SongTableViewCellTests.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 01/09/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import XCTest
@testable import Shuffle_Songs

class SongTableViewCellTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetupUI() {
        // Given
        let cell: SongTableViewCell
        
        // When
        cell = SongTableViewCell(style: .default, reuseIdentifier: "")
        cell.configure(songName: "songName", artistName: "artistName", artworkImage: UIImage())
        
        // Then
        XCTAssertEqual(cell.songName, "songName")
        XCTAssertEqual(cell.artistName, "artistName")
        XCTAssertNotNil(cell.artworkImage)
        
    }


}
