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

    var isSuccess = true
    let lookupResponse: LookupResponse

    init(lookupResponse: LookupResponse) {
        self.lookupResponse = lookupResponse
    }
    
    func fetchSongs(artistsIds: [String], completion: ((Result<[Song], SongsServiceError>) -> Void)) {
        guard let results = lookupResponse.results else {
            completion(.failure(SongsServiceError.fetchSongsFailure(description:
                "lookupResponse results are empty")))
            return
        }
        
        if isSuccess {
            
            let songs: [Song] = results.compactMap {
                guard let artistName = $0.artistName, let trackName = $0.trackName, let artistID = $0.artistID else {
                    return nil
                }
                
                guard artistsIds.contains(artistID) else { return nil }
                
                return Song(artistName: artistName, trackName: trackName)
            }
            
            completion(.success(songs))
        } else {
            completion(.failure(SongsServiceError.fetchSongsFailure(description: "forced mock failure")))
        }
    }
}
