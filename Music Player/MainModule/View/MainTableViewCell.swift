//
//  SongTableViewCell.swift
//  Music Player
//
//  Created by Кирилл Романенко on 23/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import AVFoundation

class MainTableViewCell: SongCell<MainPresenting> {

    static let identifier = "MainTableViewCell"
    var playlist = [Song]()
    
    private let songNotification = NotificationKeys.didChangeCurrentSongKey
    private let playlistNotification = NotificationKeys.favoriteToCurrentKey
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createObservers()
        
        buttonPlay.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    }
    
    @objc private func playButtonAction() {
        
        buttonPlay.flash()
        
        guard var song = song else { return }
        
        //the playlist has been updated, now you need to update the song index
        
        playlist.forEach( {
            if $0.nameSong == song.nameSong {
                song.indexSong = $0.indexSong
            }
        } )
        
        presenter.cellPlayButtonAction(userPlaylist: playlist, cellSong: song)
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: songNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangePlaylist), name: playlistNotification, object: nil)
    }
    
    @objc private func didChangePlaylist(notification: NSNotification) {
        
        playlist = presenter.userPlaylist
        
        //the playlist has been updated, now you need to update the song index
        
        playlist.forEach( {
            if var song = song {
                if $0.nameSong == song.nameSong {
                    song.indexSong = $0.indexSong
                }
            }
        } )
    }
    
    @objc private func didChangeSong(notification: NSNotification) {
        let current = song?.nameSong == presenter.currentSong?.nameSong && song?.nameArtist == presenter.currentSong?.nameArtist
        let color = current ? #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) : .white
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
