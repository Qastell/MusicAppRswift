//
//  TabBarActionPresenter.swift
//  Music Player
//
//  Created by Кирилл Романенко on 28/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

protocol AddTabBarViewProtocol {
    func songDidChange(currentSong: Song?)
    func statusPlayingDidChange(isPlaying: Bool)
}

protocol AddTabBarPresenterProtocol {
    var isPlaying: Bool { get }
    var currentSong: Song? { get }
    
    func playPause(playButton: UIButton, setPlayImage: String, setPauseImage: String)
    func playNextSong()
}

class AddTabBarPresenter: AddTabBarPresenterProtocol {
    var view: AddTabBarViewProtocol?
    
    private let playNotification = NotificationKeys.playNotificationKey
    private let pauseNotification = NotificationKeys.pauseNotificationKey
    private let changeSongNotification = NotificationKeys.didChangeCurrentSongKey
    
    var isPlaying: Bool {
        get {
            audioService.isPlaying
        }
    }
    
    var currentSong: Song? {
        get {
            audioService.currentSong
        }
    }
    
    init() {
        createObservers()
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewData), name: playNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewData), name: pauseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeNameSong), name: changeSongNotification, object: nil)
    }
    
    @objc private func updateViewData(notification: NSNotification) {
        let isPlaying = notification.name == playNotification
        view?.statusPlayingDidChange(isPlaying: isPlaying)
    }
    
    @objc private func changeNameSong(notification: NSNotification) {
        view?.songDidChange(currentSong: currentSong)
    }
    
    func playPause(playButton: UIButton, setPlayImage: String, setPauseImage: String) {
        audioService.changeStatusPlaying(playButton: playButton, setPlayImage: setPlayImage, setPauseImage: setPauseImage)
    }
    
    func playNextSong() {
        if audioService.isPlaying {
            audioService.goForward()
        } else {
            audioService.stop()
            
            audioService.currentSong = nil
            audioService.checkNilSong()
        }
    }
    
}
