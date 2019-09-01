//
//  ShuffleListViewModelTests.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import XCTest
@testable import Shuffle_Songs

class ShuffleListViewModelTests: XCTestCase {
    
    var viewModel: ShuffleListViewModel!
    var mockedAPIService: SongsServiceMock!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let lookupResponseData = self.loadStubFromBundle(withName: "lookupResponse", extension: "json")
        let lookupResponse = try! JSONDecoder().decode(LookupResponse.self, from: lookupResponseData)

        mockedAPIService = SongsServiceMock(lookupResponse: lookupResponse)
        viewModel = ShuffleListViewModel(artistsIDs: ["909253", "1171421960", "358714030", "1419227", "264111789"], service: mockedAPIService)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetShuffled() {
        // Given
        let viewModel = self.viewModel
        var songs = [
            Song(artistName: "Artist1", trackName: "Track1", artworkURL: "url"),
            Song(artistName: "Artist1", trackName: "Track2", artworkURL: "url"),
            Song(artistName: "Artist1", trackName: "Track3", artworkURL: "url"),
            Song(artistName: "Artist2", trackName: "Track4", artworkURL: "url")
        ]
        var shuffledSongs = [Song]()

        // When
        shuffledSongs = viewModel?.getShuffled(songs) ?? []
        
        // Then
        XCTAssertEqual(shuffledSongs.count, songs.count)
        
    }

    func testFetchSongs() {
        
        // Given
        let artistsIDs = viewModel.artistsIDs
        var fetchedSongs: [Song] = []
        var shuffledSongs: [Song]?
        let expectation = self.expectation(description: "Did receive response")

        // When
        mockedAPIService.fetchSongs(artistsIds: artistsIDs) { result in
            guard case .success(let songs) = result else {
                XCTFail("mock failed")
                return
            }
            
            fetchedSongs = songs
            shuffledSongs = viewModel.getShuffled(fetchedSongs)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(shuffledSongs)
        
        fetchedSongs.forEach { song in
            XCTAssertTrue(shuffledSongs!.contains(song))
        }
    }
    
}
