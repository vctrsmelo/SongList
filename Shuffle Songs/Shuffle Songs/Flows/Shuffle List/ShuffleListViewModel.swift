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
        
        init(song: Song) {
            self.title = song.trackName
            self.subtitle = song.artistName

            guard let data = song.artworkData, let image = UIImage(data: data) else {
                self.image = UIImage()
                return
            }

            self.image = image
        }
    }
    
    // MARK: - Properties
    
    let artistsIDs: [String]
    
    let service: SongsService
    var delegate: ShuffleListViewModelDelegate?
    
    var viewState: ViewState = .empty {
        didSet {
            self.delegate?.updateView(viewState, viewModel: self)
        }
    }
    
    // all songs received from service
    private var cacheSongs: [Song]? = []

    // songs to be displayed to user
    private var shuffledItems: [CellData] = [] {
        didSet {
            self.delegate?.didUpdateSongs(viewModel: self)
        }
    }
    
    var itemLength: Int {
        return shuffledItems.count
    }
    
    // MARK: - Init
    
    init(artistsIDs: [String], service: SongsService) {
        self.service = service
        self.artistsIDs = artistsIDs
        
        self.viewState = .loading
        fetchSongs { [weak self] maybeSongs in
            guard let self = self else { return }
            
            self.fetchArtworks(maybeSongs ?? [], completion: { songs in
                self.cacheSongs = songs
                self.shuffledItems = songs.map { CellData(song: $0) }
                self.viewState = .showing
            })
        }
    }
    
    // MARK: - Service
    
    func fetchSongs(completion: @escaping ([Song]?) -> Void) {
        service.fetchSongs(artistsIds: artistsIDs) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let songs):
                self.cacheSongs = songs
                self.syncIfNeeded {
                    completion(songs)
                }
            case .failure(let error):
                print("[ShuffleListViewModel Error] \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    private func fetchArtworks(_ songs: [Song], completion: @escaping ([Song]) -> Void) {
        
        let fetchArtworkGroup = DispatchGroup()
        
        var returnSongs = songs
        
        for i in 0 ..< songs.count {
            
            // should not fetch again previously fetched artworkData
            if songs[i].artworkData != nil {
                continue
            }
            
            fetchArtworkGroup.enter()
            
            service.fetchAlbumImageData(imageURL: songs[i].artworkURL) { result in
                switch result {
                case .failure(let error):
                    print("could not fetch artwork from URL: \(songs[i].artworkURL). Error: \(error.localizedDescription)")
                case .success(let data):
                    returnSongs[i].artworkData = data
                }
                fetchArtworkGroup.leave()
            }
        }
        
        fetchArtworkGroup.notify(queue: .main) {
            completion(returnSongs)
        }
        
        
    }
    
    // MARK: - User Actions
    
    func didTapShuffleButton() {
        guard let cacheSongs = cacheSongs else { return }
        
        viewState = .loading
        
        // async to prevent shuffle algorithm freezing UI
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let items = self.getShuffled(cacheSongs).map { CellData(song: $0) }
            DispatchQueue.main.sync {
                self.shuffledItems = items
                self.viewState = .showing
            }
        }
    }
    
    // MARK: - Others

    /**
     - Returns: Return songs shuffled, where two songs from same artist aren't next each other, if possible.
    */
    public func getShuffled(_ songs: [Song]) -> [Song] {
        let customShuffle = CustomShuffle(from: songs)
        return customShuffle.shuffled()
    }
    
    func getItem(at index: Int) -> CellData {
        return shuffledItems[index]
    }
    
    /// Sync closure to main thread for UI updates.
    /// - Important: This logic is here because it is not Service responsibility to keep it sync, as it is something importante for view update, and ViewController (delegate) should not know that something is being updated in background thread or not.
    func syncIfNeeded(_ closure: () -> Void) {
        // unit tests uses main thread, as service is mocked.
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.sync{
                closure()
            }
        }
    }
    
}
