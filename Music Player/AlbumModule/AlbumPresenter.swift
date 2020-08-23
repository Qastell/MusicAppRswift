//
//  AlbumPresenter.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumPresenting: BasePresenter {
    var albums: [Album] { get set }
    
    func showDetailPlayer(from: UIViewController?)
    func showAlbumDetailView(from: UIViewController?, indexPath: IndexPath)
}

class AlbumPresenter: AlbumPresenting {
    
    private let router: RouterProtocol?
    
    var albums: [Album]
    
    required init(router: RouterProtocol) {
        self.router = router
        
        albums = songService.albumStorage
    }
    
    func showDetailPlayer(from: UIViewController? = nil) {
        if audioService.currentSong == nil {
            audioService.playRandomSong()
        }
        
        router?.go(to: .detailPlayer, from: from)
    }
    
    func showAlbumDetailView(from: UIViewController? = nil, indexPath: IndexPath) {
        let album = albums[indexPath.row]
        router?.go(to: .albumDetail(for: album), from: from)
    }
}
