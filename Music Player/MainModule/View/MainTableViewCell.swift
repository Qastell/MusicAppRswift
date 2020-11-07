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
    private let playlistNotification = NotificationKeys.favoritePlaylistDidStart
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(didChangePlaylist), name: playlistNotification, object: nil)
    }
    
    @objc private func didChangePlaylist(notification: NSNotification) {
        
        playlist = presenter.userPlaylist
        
        playlist.forEach( {
            if var song = song {
                if $0.nameSong == song.nameSong {
                    song.indexSong = $0.indexSong
                }
            }
        } )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
