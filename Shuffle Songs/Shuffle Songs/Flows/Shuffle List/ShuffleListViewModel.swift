//
//  ShuffleListViewModel.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation
import UIKit //only imported for UIImage CellData

protocol ShuffleListViewModelDelegate {
    func didUpdateSongs(viewModel: ShuffleListViewModel)
    func updateView(_ state: ViewState, viewModel: ShuffleListViewModel)
}

class ShuffleListViewModel {
    
    // MARK: - Subelements
    
    struct CellData {
        let title: String
        let subtitle: String
        let image: UIImage
    }
    
    // MARK: - Properties
    
    let artistsIDs: [String]
    
    private let limitSongs = 5
    
    let service: SongsService
    var delegate: ShuffleListViewModelDelegate?
    
    // all songs received from service
    private var cacheSongs: [Song]? = []

    // songs to be displayed to user
    private var shuffledSongs: [Song] = [] {
        didSet {
            self.delegate?.didUpdateSongs(viewModel: self)
        }
    }
    
    var itemLength: Int {
        return shuffledSongs.count
    }
    
    // MARK: - Init
    
    init(artistsIDs: [String], service: SongsService) {
        self.service = service
        self.artistsIDs = artistsIDs

        fetchSongsShuffled { maybeSongs in
            self.shuffledSongs = maybeSongs ?? []
        }
    }
    
    // MARK: - Service
    
    func fetchSongsShuffled(completion: @escaping ([Song]?) -> Void) {

        service.fetchSongs(artistsIds: artistsIDs) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let songs):
                self.cacheSongs = songs
                
                DispatchQueue.main.sync {
                    completion(self.getShuffled(songs, length: self.limitSongs))
                }
            case .failure(let error):
                print("[ShuffleListViewModel Error] \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    // MARK: - User Actions
    
    func didTapShuffleButton() {
        guard let cacheSongs = cacheSongs else {
            self.fetchSongsShuffled { maybeSongs in
                self.shuffledSongs = maybeSongs ?? []
            }
            
            return
        }
        
        self.shuffledSongs = self.getShuffled(cacheSongs, length: limitSongs)
    }
    
    // MARK: - Others

    /**
     
     - Returns: Return list with max size of `length` elements, from songs parameter, where for every two songs from same artists, they aren't next each other.
     - Precondition:
        - songs.count >= length
        - length > 0
     - Postcondition:
        - return.count <= length
        - return.count > 0
     - Important:
        it is not guaranteed that return will have length elements. The rule of two artists songs should not be next each other is always respected. If it is not possible to return a list of `length` elements, without breaking this rule, an smaller list will be returned.
    */
    public func getShuffled(_ songs: [Song], length: Int) -> [Song] {
        
        // these guards are related to precondition. Important: return [] in these cases does not break postcondition of "return.count > 0", as precondition are not being respected here.
        guard songs.count >= length else {
            assertionFailure("[ShuffleListViewModel] length parameter should be greater than songs.count")
            return []
        }
        
        guard length > 0 else {
            assertionFailure("[ShuffleListViewModel] length should not be zero")
            return []
        }
        
        var inputSongs = songs.shuffled()
        var outputSongs: [Song] = [inputSongs.first!]

        var i = 1
        while outputSongs.count < length && i < inputSongs.count {
            
            // get next song from different artist.
            if inputSongs[i].artistName != outputSongs[outputSongs.count-1].artistName {
                outputSongs.append(inputSongs[i])
            }
            
            i += 1
        }
        
        return outputSongs
    }
    
    func getItem(at index: Int) -> CellData {
        return CellData(title: shuffledSongs[index].trackName, subtitle: shuffledSongs[index].artistName, image: UIImage())
    }
    
}
