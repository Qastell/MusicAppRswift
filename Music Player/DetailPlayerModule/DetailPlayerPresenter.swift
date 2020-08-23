//
//  DetailPlayerPresenter.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

protocol DetailPlayerViewProtocol {
    func songDidChange(currentSong: Song?)
    func statusPlayingDidChange(isPlaying: Bool)
}

protocol DetailPlayerPresenting: BasePresenter {
    var view: DetailPlayerViewProtocol? { get set }
    var isPlaying: Bool { get }
    var volumeFloat: Float? { get set }
    var volume: Float? { get set }
    var currentTime: TimeInterval { get set }
    var duration: TimeInterval { get }
    var currentSong: Song? { get }
    
    func play()
    func pause()
    func playNextSong()
    func playPreviousSong()
    func stop()
}

class DetailPlayerPresenter: DetailPlayerPresenting {
    
    var view: DetailPlayerViewProtocol?
    
    private let router: RouterProtocol?
    
    let playNotification = NotificationKeys.playNotificationKey
    let pauseNotification = NotificationKeys.pauseNotificationKey
    
    var isPlaying: Bool {
        get{
            audioService.isPlaying
        }
    }
    var currentTime: TimeInterval {
        get{
            audioService.currentTime
        }
        set{
            audioService.currentTime = newValue
        }
    }
    
    var duration: TimeInterval {
        get{
            audioService.duration
        }
    }
    
    var volumeFloat: Float? {
        get{
            audioService.volumeFloat
        }
        set{
            audioService.volumeFloat = newValue
        }
    }
    
    var volume: Float? {
        get{
            audioService.volume
        }
        set{
            audioService.volume = newValue
        }
    }
    
    var currentSong: Song? {
        get{
            audioService.currentSong
        }
    }
    
    required init(router: RouterProtocol) {
        self.router = router
        
        audioService.delegate = self
        createObservers()
    }
    
    func play() {
        audioService.play()
    }
    
    func pause() {
        audioService.pause()
    }
    
    func playNextSong() {
        audioService.goForward()
    }
    
    func playPreviousSong() {
        audioService.goBack()
    }
    
    func stop() {
        audioService.stop()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusPlaying), name: playNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusPlaying), name: pauseNotification, object: nil)
    }
    
    @objc func updateStatusPlaying (notification: NSNotification) {
        let isPlaying = notification.name == playNotification
        view?.statusPlayingDidChange(isPlaying: isPlaying)
    }
    
}

extension DetailPlayerPresenter: AudioServiceDelegate {
    func didChangeSong(currentSong: Song?) {
        view?.songDidChange(currentSong: currentSong)
    }
}
