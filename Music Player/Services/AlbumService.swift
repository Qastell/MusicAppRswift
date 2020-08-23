//
//  AlbumService.swift
//  Music Player
//
//  Created by Кирилл Романенко on 03/06/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit


class AlbumService {
    
    init () {
        addSongToAlbum (albumName: "Astroworld", artistName: "Travis Scott", songName: "SICKO MODE")
    }
    
    func addSongToAlbum (albumName: String, artistName: String ,songName: String ) {
        print("add")
        for songCount in 0..<songsService.songs.count {
            if songsService.songs[songCount].nameArtist == artistName {
                if songsService.songs[songCount].nameSong == songName {
                    songsService.songs[songCount].albumName = albumName
                }
            }
        }
    }
    
}
