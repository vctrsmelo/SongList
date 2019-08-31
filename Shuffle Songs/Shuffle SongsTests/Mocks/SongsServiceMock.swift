//
//  SongsServiceMock.swift
//  Shuffle SongsTests
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation
@testable import Shuffle_Songs

enum SongsServiceMockError: Error {
    case emptyResults
    case forcedError
}

class SongsServiceMock: SongsService {

    var isSuccess = true
    let lookupResponse: LookupResponse

    init(lookupResponse: LookupResponse) {
        self.lookupResponse = lookupResponse
    }
    
    func fetchSongs(artistsIds: [String], completion: ((Result<[Song], SongsServiceError>) -> Void)) {
        guard let results = lookupResponse.results else {
            completion(.failure(SongsServiceError.fetchSongsFailure(error: SongsServiceMockError.emptyResults)))
            return
        }
        
        if isSuccess {
            completion(.success(results.map { Song(fromResult: $0) }))
        } else {
            completion(.failure(SongsServiceError.fetchSongsFailure(error: SongsServiceMockError.forcedError)))
        }
    }
}
