//
//  Model.swift
//  Music Player
//
//  Created by Кирилл Романенко on 23/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct Song {
    var albumName: String = ""
    var nameArtist: String
    var nameSong: String
    var imageSong: String
    var indexSong: Int
    var duration: TimeInterval = 0.0
}

struct Album {
    var name: String
    var tracklist: [Song]
    var id: Int
}

protocol SongsServicing: class {
    var songStorage: [Song] { get set }
    var albumStorage: [Album] { get set }
    var userPlaylist: [Song] { get set }
}

//like a networkService, but without json and working with servers

class SongsService: SongsServicing {
    var songStorage = [Song]()
    var albumStorage = [Album]()
    var userPlaylist = [Song]()
    private var getterDuration = AVAudioPlayer()
    
    init() {
        gettingSongName()
        
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "SICKO MODE")
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "Stargazing")
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "CAROUSEL ft Frank Ocean")
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "SKELETONS ft The Weeknd")
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "YOSEMITE ft Gunna & NAV")
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "STOP TRYING TO BE GOD ft James Blake & Kid Cudi")
        addSongToAlbum(albumName: "ASTROWORLD", artistName: "Travis Scott", songName: "BUTTERFLY EFFECT")
        
        addSongToAlbum(albumName: "Beauty Behind the Madness", artistName: "The Weeknd", songName: "The Hills")
        
        addSongToAlbum(albumName: "My Dear Melancholy,", artistName: "The Weeknd", songName: "Call Out My Name")
        
        addSongToAlbum(albumName: "?", artistName: "XXXTENTACION", songName: "SAD!")
        
        addSongToAlbum(albumName: "Music To Be Murdered By", artistName: "Eminem", songName: "You Gon Learn feat Royce Da 5'9, White Gold")
        
        addSongToAlbum(albumName: "Shawn Mendes", artistName: "Shawn Mendes", songName: "In My Blood")
        
        addSongToAlbum(albumName: "Camila", artistName: "Camila Cabello", songName: "Havana feat. Young Thug")
        
        addSongToAlbum(albumName: "Thank U, Next", artistName: "Ariana Grande", songName: "7 Rings")
        
        addSongToAlbum(albumName: "DAMN.", artistName: "Kendrick Lamar", songName: "DNA.")
        
        addSongToAlbum(albumName: "SremmLife 2", artistName: "Rae Sremmurd", songName: "Black Beatles Ft. Gucci Mane")
    }
    
    private func gettingIndex<T> (isEmpty: Bool, array: [T]) -> Int {
        if isEmpty {
            return 0
        } else {
            return array.count
        }
    }
    
    private func getDuration (_ song: Song) -> TimeInterval {
        do{
            if let audioPath = Bundle.main.path(forResource: "\(song.nameArtist) - \(song.nameSong)", ofType: ".mp3") {
                try getterDuration = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            }
        }
        catch{
            print(error)
        }
        return getterDuration.duration
    }
    
    private func gettingSongName() {
        let foulderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: foulderURL,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for song in songPath {
                var mySong = song.absoluteString
                
                if mySong.contains(".mp3"){
                    var findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ") //меняет элементы на другие
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    findString = mySong.components(separatedBy: " - ")
                    let nameArtist = findString[0]
                    let nameSong = findString[1]
                    addingSong(nameArtist: nameArtist, nameSong: nameSong, imageSong: mySong,
                               indexSong: gettingIndex(isEmpty: songStorage.isEmpty, array: songStorage))
                }
            }
        }
        catch {
            print("error")
        }
    }
    
    private func addingSong (nameArtist: String, nameSong: String, imageSong: String, indexSong: Int) {
        var song = Song(nameArtist: nameArtist, nameSong: nameSong, imageSong: imageSong, indexSong: indexSong)
        song.duration = getDuration(song)
        songStorage.append(song)
    }
    
    private func addSongOrCreateAlbum(song: Song, albumName: String) {
        if albumStorage.isEmpty {
            createAlbum(song, albumName: albumName)
        } else {
            if checkAlbumName(name: albumName) {
                for count in 0..<albumStorage.count {
                    if albumStorage[count].name == albumName {
                        albumStorage[count].tracklist.append(song)
                        albumStorage[count].tracklist[albumStorage[count].tracklist.count-1].indexSong = albumStorage[count].tracklist.count - 1
                        continue
                    }
                }
            } else {
                createAlbum(song, albumName: albumName)
            }
        }
    }
    
    private func createAlbum(_ song: Song, albumName: String) {
        var tracklist = [Song]()
        tracklist.append(song)
        tracklist[tracklist.count-1].indexSong = 0
        let album = Album(name: albumName, tracklist: tracklist, id: gettingIndex(isEmpty: albumStorage.isEmpty, array: albumStorage))
        albumStorage.append(album)
    }
    
    private func checkAlbumName(name ofAlbum: String) -> Bool {
        for album in albumStorage {
            if album.name == ofAlbum {
                return true
            }
        }
        return false
    }
    
    private func addSongToAlbum (albumName: String, artistName: String, songName: String ) {
        songStorage.forEach( {
            if $0.nameArtist == artistName {
                if $0.nameSong == songName {
                    var theSong = songStorage[$0.indexSong]
                    theSong.albumName = albumName
                    theSong.imageSong = albumName
                    
                    addSongOrCreateAlbum(song: theSong, albumName: albumName)
                }
            }
        } )
    }
}







