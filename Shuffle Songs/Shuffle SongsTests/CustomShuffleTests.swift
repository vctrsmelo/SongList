//
//  CustomShuffleTests.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 01/09/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import XCTest
@testable import Shuffle_Songs

class CustomShuffleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShufflePossibleToSeparateArtists() {
        
        // Given
        let songs = [
            Song(artistName: "Artist1", trackName: "Track1", artworkURL: "url"),
            Song(artistName: "Artist1", trackName: "Track2", artworkURL: "url"),
            Song(artistName: "Artist2", trackName: "Track3", artworkURL: "url"),
            Song(artistName: "Artist2", trackName: "Track4", artworkURL: "url")
        ]
        
        // When
        let shuffler = CustomShuffle(from: songs)
        let songsShuffled = shuffler.shuffled()
        
        // Then
        XCTAssertEqual(songs.count, songsShuffled.count)
        
        for i in 0 ..< songsShuffled.count-1 {
            XCTAssertNotEqual(songsShuffled[i].artistName, songsShuffled[i+1].artistName)
        }
    }
    
    func testShuffleImpossibleToSeparateArtists() {
        
        // Given
        let songs = [
            Song(artistName: "Artist1", trackName: "Track1", artworkURL: "url"),
            Song(artistName: "Artist1", trackName: "Track2", artworkURL: "url"),
            Song(artistName: "Artist1", trackName: "Track3", artworkURL: "url"),
            Song(artistName: "Artist2", trackName: "Track4", artworkURL: "url")
        ]
        
        // When
        let shuffler = CustomShuffle(from: songs)
        let songsShuffled = shuffler.shuffled()
        
        // Then
        XCTAssertEqual(songs.count, songsShuffled.count)
        XCTAssertNotEqual(songsShuffled[0].artistName, songsShuffled[1].artistName)
        XCTAssertEqual(songsShuffled[2].artistName, songsShuffled[3].artistName)
    }
}
