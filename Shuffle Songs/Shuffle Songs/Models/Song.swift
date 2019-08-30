//
//  Song.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

struct Song: Decodable {
    
    var artistName: String?
    var trackName: String?
    
    /// Used for testing
    init(attributes: [String: Any]) {
        self.artistName = attributes["artistName"] as? String
        self.trackName = attributes["trackName"] as? String
    }
}
