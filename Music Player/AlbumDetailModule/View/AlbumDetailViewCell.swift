//
//  AlbumTableViewCell.swift
//  Music Player
//
//  Created by Кирилл Романенко on 05/06/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

class AlbumDetailViewCell: SongCell<AlbumDetailPresenting> {

    static let identifier = "AlbumTableViewCell"
    
    var albumID = Int()
    
    let songNotification = NotificationKeys.didChangeCurrentSongKey
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        createObservers()
        
        buttonPlay.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        buttonPlay.setTitleColor(.black, for: .normal)
        buttonPlay.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    @objc private func playButtonAction() {
        guard let song = song else { return }
        
        buttonPlay.flash()
        presenter?.playSongCell(song: song, albumID: albumID)
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSong), name: songNotification, object: nil)
    }
    
    @objc private func didChangeSong(notification: NSNotification) {
        let current = song?.nameSong == presenter.currentSong?.nameSong && song?.nameArtist == presenter.currentSong?.nameArtist
        let color = current ? #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) : .white
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
}
