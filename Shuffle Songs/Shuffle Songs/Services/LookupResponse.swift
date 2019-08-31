//
//  LookupResponse.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

// MARK: - LookupResponse
struct LookupResponse {
    let resultCount: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result {
    let artistName: String?
    let id: Int?
    let wrapperType: String?
    let artistType: String?
    let primaryGenreName: String?
    let trackTimeMillis: Int?
    let collectionName: String?
    let trackExplicitness: String?
    let trackCensoredName: String?
    let collectionID: Int?
    let trackName: String?
    let country: String?
    let artworkURL: String?
    let releaseDate: Date?
    let artistID: Int?
}
