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

    func testGetSongs() {
        
        mockedAPIService.fetchSongs(artistsIds: viewModel.artistsIDs) { result in
            guard case .success(let fetchedSongs) = result else {
                XCTFail("mock failed")
                return
            }
            
            let songs = viewModel.getShuffled(fetchedSongs, length: 5)
            
            print(songs)
            
            XCTAssertNotNil(songs)
            XCTAssertTrue(songs.count <= 5)
            
            songs.forEach { song in
                let isContainedInSelfSongs = fetchedSongs.contains(where: { fetchedSong -> Bool in
                    return fetchedSong == song
                })
                
                XCTAssertTrue(isContainedInSelfSongs)
            }

        }
    }
    
}
