//
//  CustomSortService.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 31/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import Foundation


typealias ArtistName = String

/**
This class encapsulates the shuffle logic. As it has some states to be handled, it was prefered to create this class instead of adding these states in ViewModel (or where else place this is called)
*/
class CustomShuffle {

    var songsDictionary: [ArtistName: [Song]] = [:]
    private let receivedSongs: [Song]
    
    init(from songs: [Song]) {
        self.receivedSongs = songs
        
        // this shuffled ensures that CustomShuffle.shuffled() will not return a list that begins always with the same artist.
        let shuffledSongs = songs.shuffled()
        
        // add songs into dictionary, keyed by artist name
        for song in shuffledSongs {
            if songsDictionary[song.artistName] == nil {
                songsDictionary[song.artistName] = [song]
            } else {
                songsDictionary[song.artistName]?.append(song)
            }
        }
    }
    
    /** Uses a priorityQueue to guarantee that, if possible, two songs from same artist will never be next each other in returned list. If it is not possible, the algorithm will separate artist the best it can, and the last songs will be from same artist.
     - Postcondition:
        - result.count = self.receivedSongs
    */
    func shuffled() -> [Song] {
        
        // songs returned. Songs are added during each iteration of algorithm below
        var resultSongs: [Song] = []
    
        var lastArtistAdded = ""
    
        // songs still not added to resultSongs
        var leftSongs = songsDictionary
        
        // priorityQueue to first add artists that have more music, as their musics have greater possibility of being next each other.
        var artistPriorityQueue: [(artist: ArtistName, priority: Int)] = songsDictionary.keys.compactMap { artistName -> (artist: ArtistName, priority: Int) in
            return (artist: artistName, priority: (songsDictionary[artistName] ?? []).count)
        }

        // should iterate if there are songs left (priority is the number of songs left from each artist)
        var shouldIterate: Bool {
            return artistPriorityQueue.first(where:{ $0.priority > 0 }) != nil
        }
        
        // iterations
        
        while shouldIterate {
            // get priorityQueue desconsidering last added artist
            let artistQueueWithoutLastArtistAdded = artistPriorityQueue.filter { $0.artist != lastArtistAdded }
            
            // if there is no artist different than lastone added, add all left songs then break.
            if artistQueueWithoutLastArtistAdded.isEmpty {
                let lastSongs = leftSongs.values.flatMap { songs -> [Song] in
                    return songs
                }
                resultSongs.append(contentsOf: lastSongs)
                break
            }
            
            // get left artist with most musics left
            let maxPriorityArtist = artistQueueWithoutLastArtistAdded.max { (a1, a2) -> Bool in
                return a1.priority < a2.priority
            }
            
            // guard let just to not force unwrap. This way, if something weird happens, return the already shuffled songs in production.
            guard let artist = maxPriorityArtist?.artist, var leftArtistSongs = leftSongs[artist] else {
                assertionFailure("[Warning] should never reach this state during algorithm")
                return resultSongs
            }

            let nextSong = leftArtistSongs.popLast()! // get next song
            leftSongs[artist] = leftArtistSongs // remove song from left songs
            
            resultSongs.append(nextSong)
            lastArtistAdded = artist
            
            // decrease priority from added artist
            for i in 0 ..< artistPriorityQueue.count {
                if artistPriorityQueue[i].artist == artist {
                   artistPriorityQueue[i].priority -= 1
                    break
                }
            }
        }
        
        return resultSongs
    }
}
