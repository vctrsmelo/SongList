//
//  SongsAPIService.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol SongsService {
    func fetchSongs(artistsIds: [String], completion: @escaping ((Result<[Song],SongsServiceError>) -> Void))
    func fetchAlbumImageData(imageURL: String, completion: @escaping ((Result<Data, SongsServiceError>) -> Void))
}

// MARK: - Implementation

class SongsAPIService {
    
    enum Endpoints: String {
        case lookup = "lookup"
    }
   
    private let mainURL = "https://us-central1-tw-exercicio-mobile.cloudfunctions.net"
    private let limit = 5
    
    
    private func getLookupURLString(_ artistsIds: [String], limit: Int) -> String {
        var idsString = artistsIds.first!
        
        artistsIds.forEach { idStr in
            if idStr == artistsIds.first {
                return
            }
            
            idsString = "\(idsString),\(idStr)"
        }
        
        
        let urlString = "\(mainURL)/\(Endpoints.lookup)?id=\(idsString)&limit=\(limit)"
        
        return urlString
    }
    
    private func getSongsFrom(_ results: [LookupResult]) -> [Song] {
        let songs: [Song] = results.compactMap {
            guard let artistName = $0.artistName, let trackName = $0.trackName, let artworkURL = $0.artworkUrl else { return nil }
            return Song(artistName: artistName, trackName: trackName, artworkURL: artworkURL)
        }
        return songs
    }
}

extension SongsAPIService: SongsService {
    
    /**
     - Precondition:
        - artistisIds.count > 0
    */
    func fetchSongs(artistsIds: [String], completion: @escaping ((Result<[Song],SongsServiceError>) -> Void)) {
        
        let urlString = getLookupURLString(artistsIds, limit: 5)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(SongsServiceError.fetchSongsFailure(description: "error while trying to create URL")))
            return
        }
        
        let request = URLRequest(url: url)
        
        APIService().request(request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(SongsServiceError.fetchSongsFailure(description: error.localizedDescription)))
                
            case .success(let data):
                // parsing
                do {
                    let response = try JSONDecoder().decode(LookupResponse.self, from: data)
                    
                    guard let results = response.results else {
                        completion(.failure(SongsServiceError.fetchSongsFailure(description: "results is nil")))
                        return
                    }
                    
                    let songs = self.getSongsFrom(results)
                    
                    completion(.success(songs))
                } catch {
                    completion(.failure(SongsServiceError.fetchSongsFailure(description: error.localizedDescription)))
                }
            }
        }
    }
    
    func fetchAlbumImageData(imageURL: String, completion: @escaping ((Result<Data, SongsServiceError>) -> Void)) {
        
        guard let url = URL(string: imageURL) else {
            completion(.failure(SongsServiceError.fetchImageFailure(description: "undefined url: \(imageURL)")))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        APIService().request(urlRequest) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(SongsServiceError.fetchImageFailure(description: error.localizedDescription)))
            }
        }
        
    }
}

// MARK: - Errors

enum SongsServiceError: LocalizedError {
    case fetchSongsFailure(description: String)
    case fetchImageFailure(description: String)
    
    var localizedDescription: String {
        switch self {
        case .fetchSongsFailure(let description):
            return "error while fetching songs: \(description)"
        case .fetchImageFailure(let description):
            return "error while fetching image: \(description)"
        }
    }
}
