//
//  MainPresenter.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

typealias UserSongs = [Song]

protocol MainViewProtocol: class {
    func statusPlayingDidChange(isPlaying: Bool)
    func showButtons()
}

protocol MainTableViewCellProtocol: class {
    func updateSong(song: String, artist: String)
    func updatePlaylist(userPlaylist: [Song])
}

protocol MainPresenting: BasePresenter {
    var view: MainViewProtocol? { get set }
    var tableCell: MainTableViewCellProtocol? { get set }
    var currentSong: Song? { get }
    
    var userPlaylist: UserSongs { get set }
    var bufferUserPlaylist: UserSongs { get }
    
    func didMoveRow (moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func showDetailPlayerView(from: UIViewController?)
    func presentDetailPlayerView(from: UIViewController?, indexPath: IndexPath)
    func mainViewDidStart()
    func startSetup()
    func playPause(playButton: UIButton, setPlayImage: String, setPauseImage: String)
    func goForward()
    func mixTracklist()
    func cellPlayButtonAction(userPlaylist: [Song], cellSong: Song)
}

class MainPresenter: MainPresenting {
    
    weak var view: MainViewProtocol?
    weak var tableCell: MainTableViewCellProtocol?
    
    var currentSong: Song? {
        get{
            audioService.currentSong
        }
    }
    
    var bufferUserPlaylist: UserSongs {
        get{
            songService.userPlaylist
        }
    }
    
    var userPlaylist = UserSongs()
    
    private let router: RouterProtocol?
    
    private let playNotification = NotificationKeys.playNotificationKey
    private let pauseNotification = NotificationKeys.pauseNotificationKey
    private let currentSongIsntNil = NotificationKeys.currentSongIsntNilKey
    
    required init(router: RouterProtocol) {
        self.router = router
        createObservers()
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewData), name: playNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewData), name: pauseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showButtons), name: currentSongIsntNil, object: nil)
    }
    
    @objc private func updateViewData(notification: NSNotification) {
        let isPlaying = notification.name == playNotification
        view?.statusPlayingDidChange(isPlaying: isPlaying)
    }
    
    @objc private func showButtons(notification: NSNotification) {
        view?.showButtons()
    }
    
    func goForward() {
        audioService.goForward()
    }
    
    func mixTracklist() {
        audioService.mixTracklist(tracklist: userPlaylist)
    }
    
    func playPause(playButton: UIButton, setPlayImage: String, setPauseImage: String) {
        audioService.changeStatusPlaying(playButton: playButton, setPlayImage: setPlayImage, setPauseImage: setPauseImage)
    }
    
    func cellPlayButtonAction(userPlaylist: [Song], cellSong: Song) {
        audioService.setCurrentUserPlaylist(userPlaylist)
        
        if audioService.currentSong == nil {
            audioService.startPlayTheSong(cellSong)
        } else {
            if audioService.songIsCurrent(cellSong){
                if audioService.isPlaying {
                    audioService.pause()
                } else {
                    audioService.play()
                }
            } else {
                audioService.startPlayTheSong(cellSong)
            }
        }
    }
    
    func startSetup() {
        for count in 0..<songService.songStorage.count{
            if songService.songStorage[count].nameSong == "SICKO MODE" || songService.songStorage[count].nameSong == "The Hills" || songService.songStorage[count].nameSong == "SAD!" || songService.songStorage[count].nameSong == "Call Out My Name" || songService.songStorage[count].albumName == ""{
                userPlaylist.append(songService.songStorage[count])
                userPlaylist[userPlaylist.count-1].indexSong = userPlaylist.count-1
            }
        }
    }
    
    func mainViewDidStart() {
        songService.userPlaylist = userPlaylist
        audioService.setCurrentUserPlaylist(userPlaylist)
    }
    
    func showDetailPlayerView(from: UIViewController? = nil) {
        if audioService.currentSong == nil {
            audioService.playRandomSong()
        }
        router?.go(to: .detailPlayer, from: from)
    }
    
    func presentDetailPlayerView(from: UIViewController? = nil, indexPath: IndexPath) {
        if audioService.songIsCurrent(userPlaylist[indexPath.row]) {
            router?.go(to: .detailPlayer, from: from)
        } else {
            audioService.startPlayTheSong(userPlaylist[indexPath.row])
            audioService.setCurrentUserPlaylist(userPlaylist)
            router?.go(to: .detailPlayer, from: from)
        }
    }
    
    func didMoveRow (moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = userPlaylist[sourceIndexPath.row]
        userPlaylist.remove(at: sourceIndexPath.row)
        userPlaylist.insert(item, at: destinationIndexPath.row)
        
        //update indexes of all songs in massive
        for count in 0..<userPlaylist.count {
            userPlaylist[count].indexSong = count
        }
        
        //update data about user's playlist
        songService.userPlaylist = userPlaylist
        
        //notificate cells about changing favorite tracklist
        NotificationService.setNotification(.favoriteToCurrent)
        
        if audioService.userPlaylistIsPlaying {
            //update data about current playlist
            audioService.currentPlayList = userPlaylist
            audioService.currentPlayList.forEach( {
                if var currentSong = audioService.currentSong {
                    if $0.nameSong == currentSong.nameSong {
                        currentSong.indexSong = $0.indexSong
                        audioService.currentSong?.indexSong = $0.indexSong
                    }
                }
            } )
        }
    }
    
}

























