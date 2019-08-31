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
    var songs: [Song]!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        songs = []
        
        let lookupResponseData = self.loadStubFromBundle(withName: "lookupResponse", extension: "json")
        let lookupResponse = try! JSONDecoder().decode(LookupResponse.self, from: lookupResponseData)
        
        let mockedAPIService = SongsServiceMock(lookupResponse: lookupResponse)
        
        viewModel = ShuffleListViewModel(service: mockedAPIService)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func getSongsTest() {
        let songs = viewModel.getSongsShuffled()
        
        XCTAssertNotNil(songs)
        XCTAssertEqual(songs.sorted(), inputSongs.sorted())
    }
    
}
