//
//  NotificationService.swift
//  Music Player
//
//  Created by Кирилл Романенко on 05/08/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation

enum NotificationKeys {
    static let playNotificationKey = Notification.Name("isPlaying.true")
    static let pauseNotificationKey = Notification.Name("isPlaying.false")
    static let currentSongIsntNilKey = Notification.Name("isNil.false")
    static let currentSongIsNilKey = Notification.Name("isNil.true")
    static let didChangeCurrentSongKey = Notification.Name("currentSong.didChange")
    static let favoriteToCurrentKey = Notification.Name("currentPlaylist.didFavorite")
}

enum NotificationCases {
    case play
    case pause
    case currentSongIsntNil
    case currentSongIsNil
    case didChangeSong
    case favoriteToCurrent
}

final class NotificationService {
    
    static func setNotification(_ notificationCase: NotificationCases) {
        switch notificationCase {
        case .play:
            notificationPost("isPlaying.true")
        case .pause:
            notificationPost("isPlaying.false")
        case .currentSongIsntNil:
            notificationPost("isNil.false")
        case .currentSongIsNil:
            notificationPost("isNil.true")
        case .didChangeSong:
            notificationPost("currentSong.didChange")
        case .favoriteToCurrent:
            notificationPost("currentPlaylist.didFavorite")
        }
    }
    
    static func notificationPost(_ notificationKey: String) {
        let notification = Notification.Name(notificationKey)
        NotificationCenter.default.post(name: notification, object: nil)
    }
    
}





