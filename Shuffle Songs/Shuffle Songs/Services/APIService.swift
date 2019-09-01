//
//  APIService.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 31/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

class APIService {

    func request(_ urlRequest: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard error == nil else {
                completion(.failure(SongsServiceError.fetchSongsFailure(description: error!.localizedDescription)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(SongsServiceError.fetchSongsFailure(description: "responseData is nil")))
                return
            }

            completion(.success(responseData))
            
        }).resume()
    }
}
