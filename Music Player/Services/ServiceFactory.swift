//
//  ServiceFactory.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation

class ServiceFactory {
    
    func songService() -> SongsService {
        return SongsService()
    }
    
    func audioService() -> AudioService {
        return AudioService()
    }
    
}





