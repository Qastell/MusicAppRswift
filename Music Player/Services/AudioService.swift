//
//  AudioService.swift
//  Music Player
//
//  Created by Кирилл Романенко on 30/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol AudioServiceDelegate {
    func didChangeSong(currentSong: Song?)
}

protocol AudioServicing: class {
    var delegate: AudioServiceDelegate? { get set }
    
    var currentPlayList: [Song] { get set }
    
    var userPlaylistIsPlaying: Bool { get set }
    
    var currentSong: Song? { get set }
    
    var isPlaying: Bool { get }
    
    var duration: TimeInterval { get }
    
    var currentTime: TimeInterval { get set }
    
    var volume: Float? { get set }
    
    var volumeFloat: Float? { get set }
    
    func play()
    
    func pause()
    
    func stop()
    
    func setCurrentUserPlaylist(_ userPlaylist: UserSongs)
    
    func songIsCurrent(_ song: Song) -> Bool
    
    func mixTracklist (tracklist: [Song])
    
    func playRandomSong()
    
    func startPlayTheSong (_ song: Song)
    
    func goForward()
    
    func goBack()
    
    func changeStatusPlaying (playButton: UIButton, setPlayImage: String, setPauseImage: String)
    
    func checkNilSong()
}

class AudioService: AudioServicing {
    
    var delegate: AudioServiceDelegate?
    var delegates = MultiDelegate<AudioServiceDelegate>()
    
    private var audioPlayer: AVAudioPlayer?
    
    var currentPlayList = [Song]()
    
    var userPlaylistIsPlaying = Bool()
    
    private var beginningSong: Song? {
        return currentPlayList[0]
    }
    
    private var endingSong: Song? {
        return currentPlayList[currentPlayList.count-1]
    }
    
    var currentSong: Song? {
        didSet{
            delegates.invoke {
                $0.didChangeSong(currentSong: currentSong)
            }
            
            NotificationService.setNotification(.didChangeSong)
        }
    }
    
    private var nextSong: Song? {
        if let song = currentSong {
           return currentPlayList[song.indexSong+1]
        }
        return nil
    }
    
    private var previousSong: Song? {
        if let song = currentSong {
           return currentPlayList[song.indexSong-1]
        }
        return nil
    }
    
    var isPlaying: Bool {
        get {
            if let audioPlayer = audioPlayer{
                return audioPlayer.isPlaying
            }
            return false
        }
    }
    
    var duration: TimeInterval {
        if let audioPlayer = audioPlayer{
            return audioPlayer.duration
        }
        return 0.0
    }
    
    var currentTime: TimeInterval {
        get {
            if let audioPlayer = audioPlayer{
                return audioPlayer.currentTime
            }
            return 0.0
        }
        set {
            if let audioPlayer = audioPlayer{
                audioPlayer.currentTime = newValue
            }
        }
    }
    
    var volume: Float? {
        get {
            if let audioPlayer = audioPlayer{
                return audioPlayer.volume
            }
            return 0.0
        }
        set {
            if let volume = newValue, let audioPlayer = audioPlayer {
                audioPlayer.volume = volume
            }
        }
    }
    
    var volumeFloat: Float? {
        didSet {
            if let volumeFloat = volumeFloat, let audioPlayer = audioPlayer {
                audioPlayer.volume = volumeFloat
            }
        }
    }
    
    init() {
        let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc func updateData () {
        if String(format:"%.1f", currentTime) == String(format:"%.1f", duration-0.1) && isPlaying {
            if currentSong?.nameSong == endingSong?.nameSong && currentSong?.nameArtist == endingSong?.nameArtist{
                if let beginningSong = beginningSong {
                    startPlayTheSong(beginningSong)
                }
            } else {
                if let nextSong = nextSong {
                    startPlayTheSong(nextSong)
                }
            }
        }
    }
    
    //MARK: - Base function
    
    func play() {
        checkNilSong()
        if let audioPlayer = audioPlayer{
        audioPlayer.play()
        }
        NotificationService.setNotification(.play)
    }
    
    func pause() {
        if let audioPlayer = audioPlayer{
        audioPlayer.pause()
        }
        NotificationService.setNotification(.pause)
    }
    
    func stop() {
        if let audioPlayer = audioPlayer{
        audioPlayer.stop()
        }
        NotificationService.setNotification(.pause)
    }
    
    //MARK: - Custom function
    
    func checkNilSong() {
        if currentSong != nil {
            NotificationService.setNotification(.currentSongIsntNil)
        } else {
            NotificationService.setNotification(.currentSongIsNil)
        }
    }
    
    func setCurrentUserPlaylist(_ userPlaylist: UserSongs) {
        currentPlayList = userPlaylist
        userPlaylistIsPlaying = true
    }
    
    func songIsCurrent(_ song: Song) -> Bool {
        var isCurrent = Bool()
        
        if let currentSong = currentSong {
            isCurrent = currentSong.nameArtist == song.nameArtist && currentSong.nameSong == song.nameSong
        }
        
        return isCurrent
    }
    
    func mixTracklist (tracklist: [Song]) {
        userPlaylistIsPlaying = false
        
        var randomTracklist = tracklist.shuffled()
        
        for count in 0..<randomTracklist.count {
            randomTracklist[count].indexSong = count
        }
        
        currentPlayList = randomTracklist
        startPlayTheSong(currentPlayList[0])
    }
    
    func playRandomSong() {
        let randomNumber = Int.random(in: 0..<currentPlayList.count)
        startPlayTheSong(currentPlayList[randomNumber])
    }
    
    func startPlayTheSong (_ song: Song) {
        do{
            guard let audioPath = Bundle.main.path(forResource: "\(song.nameArtist) - \(song.nameSong)", ofType: ".mp3") else {return}
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
        }
        catch{
            print(error)
        }
        currentSong = song
        play()
        volume = volumeFloat
    }
    
    func goForward() {
        if currentSong != nil {
            if currentSong?.nameSong == endingSong?.nameSong && currentSong?.nameArtist == endingSong?.nameArtist{
                if let beginningSong = beginningSong {
                    startPlayTheSong(beginningSong)
                }
            } else {
                if let nextSong = nextSong {
                    startPlayTheSong(nextSong)
                }
            }
        }  else {
            if let beginningSong = beginningSong {
                startPlayTheSong(beginningSong)
            }
        }
    }
    
    func goBack() {
        if currentSong != nil {
            if currentSong?.nameSong == beginningSong?.nameSong && currentSong?.nameArtist == beginningSong?.nameArtist{
                if let endingSong = endingSong {
                    startPlayTheSong(endingSong)
                }
            } else {
                if let previousSong = previousSong {
                    startPlayTheSong(previousSong)
                }
            }
        } else {
            if let endingSong = endingSong {
                startPlayTheSong(endingSong)
            }
        }
    }
    
    func changeStatusPlaying (playButton: UIButton, setPlayImage: String, setPauseImage: String) {
        if currentSong == nil {
            playButton.setImage(UIImage(named: setPauseImage), for: .normal)
            if let beginningSong = beginningSong {
                startPlayTheSong(beginningSong)
            }
        } else {
            if isPlaying {
                pause()
                playButton.setImage(UIImage(named: setPlayImage), for: .normal)
            } else {
                play()
                playButton.setImage(UIImage(named: setPauseImage), for: .normal)
            }
        }
    }  
    
}
 

