//
//  AlbumDetailPresenter.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumDetailViewProtocol: class {
    func updateStatusPlaying(isPlaying: Bool)
}

protocol AlbumDetailViewCellProtocol: class {
    func updateStatusPlaying(song: Song)
}

protocol AlbumDetailPresenting: BasePresenter {
    var album: Album? { get set }
    var currentSong: Song? { get }
    var view: AlbumDetailViewProtocol? { get set }
    var tableCell: AlbumDetailViewCellProtocol? { get set }
    var isPlaying: Bool { get }
    
    func playSongButtonAction(albumID: Int)
    func configure(album: Album)
    func playPause(playButton: UIButton, setPlayImage: String, setPauseImage: String)
    func mixTracklist()
    func playSongCell(song: Song, albumID: Int)
    func showDetailPlayer(from: UIViewController?, indexPath: IndexPath, albumID: Int)
    func checkSongObserver()
}

class AlbumDetailPresenter: AlbumDetailPresenting {
    
    private let router: RouterProtocol?
    
    var view: AlbumDetailViewProtocol?
    var tableCell: AlbumDetailViewCellProtocol?
    
    var currentSong: Song? {
        get {
            audioService.currentSong
        }
    }
    
    var isPlaying: Bool {
        get {
            audioService.isPlaying
        }
    }
    
    let playNotification = NotificationKeys.playNotificationKey
    let pauseNotification = NotificationKeys.pauseNotificationKey
    
    var album: Album?
    
    required init(router: RouterProtocol) {
        self.router = router
        
        createObservers()
    }
    
    func checkSongObserver() {
        NotificationService.setNotification(.didChangeSong)
    }
    
    func playSongButtonAction(albumID: Int) {
        let song = songService.albumStorage[albumID].tracklist[0]
        audioService.startPlayTheSong(song)
        audioService.currentPlayList = songService.albumStorage[albumID].tracklist
    }
    
    func playSongCell(song: Song, albumID: Int) {
        audioService.userPlaylistIsPlaying = false
        
        songService.albumStorage.forEach( {
            if $0.id == albumID {
                audioService.currentPlayList = songService.albumStorage[$0.id].tracklist
            }
        } )
        
        if audioService.currentSong == nil {
            audioService.startPlayTheSong(song)
        } else {
            if audioService.songIsCurrent(song){
                if audioService.isPlaying {
                    audioService.pause()
                } else {
                    audioService.play()
                }
            } else {
                audioService.startPlayTheSong(song)
            }
        }
    }
    
    func playPause(playButton: UIButton, setPlayImage: String, setPauseImage: String) {
        audioService.changeStatusPlaying(playButton: playButton, setPlayImage: setPlayImage, setPauseImage: setPauseImage)
    }
    
    func mixTracklist() {
        if let album = self.album {
            audioService.mixTracklist(tracklist: songService.albumStorage[album.id].tracklist)
        }
    }
    
    func showDetailPlayer(from: UIViewController? = nil, indexPath: IndexPath, albumID: Int) {
        if audioService.songIsCurrent(songService.albumStorage[albumID].tracklist[indexPath.row]) {
            router?.go(to: .detailPlayer, from: from)
        } else {
            audioService.currentPlayList = songService.albumStorage[albumID].tracklist
            audioService.userPlaylistIsPlaying = false
            audioService.startPlayTheSong(audioService.currentPlayList[indexPath.row])
            router?.go(to: .detailPlayer, from: from)
        }
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusPlayingNotification), name: playNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusPlayingNotification), name: pauseNotification, object: nil)
    }
    
    //MARK: - selectors & IBActions
    
    @objc func updateStatusPlayingNotification (notification: NSNotification) {
        let isPlaying = notification.name == playNotification
        view?.updateStatusPlaying(isPlaying: isPlaying)
    }
    
    func configure(album: Album) {
        self.album = album
    }
}
