//
//  Song.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

// It's class instead of struct because artworkData is something that should be reference type, so it can be easily cached when fetched from API.
final class Song: Decodable {
    
    let artistName: String
    let trackName: String
    let artworkUrl: String
    var artworkData: Data? // data is fetched only when artwork is displayed to user, avoiding to make unecessary url requests.
    
    init(artistName: String, trackName: String, artworkURL: String) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl = artworkURL
        self.artworkData = nil
    }
    
    /// Used for unit testing
    init(fromAttributes attributes: [String: Any]) {
        self.artistName = attributes["artistName"] as! String
        self.trackName = attributes["trackName"] as! String
        self.artworkUrl = attributes["artworkUrl"] as! String
        self.artworkData = attributes["artworkData"] as? Data
    }
}

extension Song: Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.artistName == rhs.artistName && lhs.trackName == rhs.trackName
    }
}
