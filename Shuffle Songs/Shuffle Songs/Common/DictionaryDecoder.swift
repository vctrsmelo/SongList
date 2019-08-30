//
//  DictionaryDecoder.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation

class DictionaryDecoder {
    
    static func decode<T: Decodable>(_ decodable: T.Type, from dictionary: [String: Any]) -> T? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let result = try JSONDecoder().decode(T.self, from: jsonData)
            return result
        } catch {
            print("[DictionaryDecoder] Failed decoding object \(T.self) from dictionary \(dictionary)")
            return nil
        }
            
    }
    
}
