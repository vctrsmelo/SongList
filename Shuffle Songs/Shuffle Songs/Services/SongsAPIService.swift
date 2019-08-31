//
//  SongsAPIService.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

protocol SongsService {
    func fetchSongs(artistsIds: [String]) -> [Song]
}

class SongsAPIService: SongsService {
    
    func fetchSongs(artistsIds: [String]) -> [Song] {
        return []
    }

}
