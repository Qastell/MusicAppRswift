//
//  NotificationService.swift
//  Music Player
//
//  Created by Кирилл Романенко on 05/08/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation

enum StringNotificationKeys {
    static let playingIsTrue = "isPlaying.true"
    static let playingIsFalse = "isPlaying.false"
    static let songIsNil = "isNil.true"
    static let songIsntNil = "isNil.false"
    static let songDidChange = "currentSong.didChange"
    static let favoritePlaylistDidStart = "favoritePlaylist.didStart"
}

enum NotificationKeys {
    static let playNotificationKey = Notification.Name(StringNotificationKeys.playingIsTrue)
    static let pauseNotificationKey = Notification.Name(StringNotificationKeys.playingIsFalse)
    static let currentSongIsntNilKey = Notification.Name(StringNotificationKeys.songIsntNil)
    static let currentSongIsNilKey = Notification.Name(StringNotificationKeys.songIsNil)
    static let didChangeCurrentSongKey = Notification.Name(StringNotificationKeys.songDidChange)
    static let favoritePlaylistDidStart = Notification.Name(StringNotificationKeys.favoritePlaylistDidStart)
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
            notificationPost(StringNotificationKeys.playingIsTrue)
        case .pause:
            notificationPost(StringNotificationKeys.playingIsFalse)
        case .currentSongIsntNil:
            notificationPost(StringNotificationKeys.songIsntNil)
        case .currentSongIsNil:
            notificationPost(StringNotificationKeys.songIsNil)
        case .didChangeSong:
            notificationPost(StringNotificationKeys.songDidChange)
        case .favoriteToCurrent:
            notificationPost(StringNotificationKeys.favoritePlaylistDidStart)
        }
    }
    
    static func notificationPost(_ notificationKey: String) {
        let notification = Notification.Name(notificationKey)
        NotificationCenter.default.post(name: notification, object: nil)
    }
    
}





