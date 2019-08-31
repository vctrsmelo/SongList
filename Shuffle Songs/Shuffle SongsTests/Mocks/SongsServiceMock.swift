//
//  SongsServiceMock.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation
@testable import Shuffle_Songs

class SongsServiceMock: SongsService {
    
    let lookupResponse: LookupResponse

    init(lookupResponse: LookupResponse) {
        self.lookupResponse = lookupResponse
    }
    
    func fetchSongs(artistsIds: [String]) -> [Song] {
        
    }
}
