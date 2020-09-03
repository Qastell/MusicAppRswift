//
//  Router.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

enum RouteScreen {
    case detailPlayer
    case albumDetail(for: Album)
}

enum CreateScreen {
    case main
    case album
}

protocol RouterProtocol: class {
    func go(to screen: RouteScreen, from: UIViewController?)
    func create(_ screen: CreateScreen) -> UIViewController
}

class Router: RouterProtocol{
    
    func go(to screen: RouteScreen, from: UIViewController? = nil) {
        var controller: UIViewController
        
        switch screen {
        case .detailPlayer:
            controller = createDetailPlayerView()
            from?.present(controller, animated: true, completion: nil)
        case .albumDetail (let album):
            controller = createAlbumDetailView(for: album)
            from?.present(controller, animated: true, completion: nil)
        }
    }
    
    func create(_ screen: CreateScreen) -> UIViewController {
        switch screen {
        case .main:
            return createMainView()
        case .album:
            return createAlbumView()
        }
    }
    
    private func createMainView() -> UIViewController {
        let view = MainViewController.instantiateFromStoryboard()
        let presenter = MainPresenter(router: self)
        view.presenter = presenter
        return view
    }
    
    private func createDetailPlayerView() -> UIViewController {
        let view = DetailPlayerViewController.instantiateFromStoryboard()
        let presenter = DetailPlayerPresenter(router: self)
        view.presenter = presenter
        return view
    }
    
    private func createAlbumView() -> UIViewController {
        let view = AlbumViewController.instantiateFromStoryboard()
        let presenter = AlbumPresenter(router: self)
        view.presenter = presenter
        return view
    }
    
    private func createAlbumDetailView(for album: Album) -> UIViewController {
        let view = AlbumDetailViewController.instantiateFromStoryboard()
        view.modalPresentationStyle = .fullScreen
        let presenter = AlbumDetailPresenter(router: self)
        presenter.configure(album: album)
        view.presenter = presenter
        presenter.checkSongObserver()
        return view
    }
    
    static func createAddBarView() -> AdditionalTabBarView {
        let view = AdditionalTabBarView()
        let presenter = AddTabBarPresenter()
        view.presenter = presenter
        return view
    }
}




























