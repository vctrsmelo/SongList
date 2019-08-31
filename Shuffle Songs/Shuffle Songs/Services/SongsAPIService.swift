//
//  SongsAPIService.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

enum SongsServiceError: LocalizedError {
    case fetchSongsFailure(description: String)
    
    var localizedDescription: String {
        switch self {
        case .fetchSongsFailure(let description):
            return "error while fetching songs: \(description)"
         }
    }
}

protocol SongsService {
    func fetchSongs(artistsIds: [String], completion: @escaping ((Result<[Song],SongsServiceError>) -> Void))
}

class SongsAPIService {
    
    enum Endpoints: String {
        case lookup = "lookup"
    }
   
    private let mainURL = "https://us-central1-tw-exercicio-mobile.cloudfunctions.net"
    
    private func getLookupURLString(_ artistsIds: [String], limit: Int) -> String {
        var idsString = artistsIds.first!
        let limit = 5
        
        artistsIds.forEach { idStr in
            if idStr == artistsIds.first {
                return
            }
            
            idsString = "\(idsString),\(idStr)"
        }
        
        
        let urlString = "\(mainURL)/\(Endpoints.lookup)?id=\(idsString)&limit=\(limit)"
        
        return urlString
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
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) { (data, response, error) in
            
            // error checking
            
            guard error == nil else {
                completion(.failure(SongsServiceError.fetchSongsFailure(description: error!.localizedDescription)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(SongsServiceError.fetchSongsFailure(description: "responseData is nil")))
                return
            }
            
            // parsing
            
            do {
                let response = try JSONDecoder().decode(LookupResponse.self, from: responseData)
                
                guard let results = response.results else {
                    completion(.failure(SongsServiceError.fetchSongsFailure(description: "results is nil")))
                    return
                }
                
                let songs: [Song] = results.compactMap {
                    guard let artistName = $0.artistName, let trackName = $0.trackName else {
                        return nil
                    }

                    return Song(artistName: artistName, trackName: trackName)
                }

                completion(.success(songs))
            } catch {
                completion(.failure(SongsServiceError.fetchSongsFailure(description: error.localizedDescription)))
            }
        }
        task.resume()
        
    }
}
