//
//  RoutableViewController.swift
//  Music Player
//
//  Created by Кирилл Романенко on 21/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
// 

import Foundation
import UIKit

class RoutableViewController<T>: UIViewController {

    private enum Module {
        case main
        case album
    }
    
    var presenter: T!
    
    private let router = Router()
    private lazy var addBar = AdditionalTabBarView()
    
    private var addBarIsHidden = true {
        didSet {
            changeContentInset(addBarIsHidden)
        }
    }
    
    var changeContentInset: ((Bool) -> ())!
    
    private let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let currentSongIsntNil = NotificationKeys.currentSongIsntNilKey
    private let currentSongIsNil = NotificationKeys.currentSongIsNilKey
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter is MainPresenting? {
            setBlurNavBar(.main)
            setupAddBar()
        } else if presenter is AlbumPresenting? {
            setBlurNavBar(.album)
            setupAddBar()
        }
        
        createObservers()
        createGesture()
        
        if addBar.presenter.currentSong != nil {
            guard let tabBar = tabBarController?.tabBar else { return }
            addBar.frame.origin.y = tabBar.frame.minY-40
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if presenter is MainPresenting? {
            setBlurTabBar(.main, willDisappear: false)
        } else if presenter is AlbumPresenting? {
            setBlurTabBar(.album, willDisappear: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        if presenter is MainPresenting? {
            setBlurTabBar(.main, willDisappear: true)
        } else if presenter is AlbumPresenting? {
            setBlurTabBar(.album, willDisappear: true)
        }
    }
    
//    func changeContentInset(_ bool: Bool) {
//        // метод для переопределения
//    }
    
    fileprivate func createGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGest))
        addBar.addGestureRecognizer(tapGesture)
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showOrHideAddBar), name: currentSongIsntNil, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showOrHideAddBar), name: currentSongIsNil, object: nil)
    }
    
    @objc private func tapGest (_ param: UITapGestureRecognizer) {
        router.go(to: .detailPlayer, from: self)
    }
    
    @objc private func showOrHideAddBar(notification: NSNotification) {
        let songIsntNil = notification.name == currentSongIsntNil
        
        guard let tabBar = tabBarController?.tabBar else { return }
        if songIsntNil && addBarIsHidden{
            hideAnimation(setY: tabBar.frame.minY-40, setAlpha: 1, isHide: false)
        } else if !songIsntNil{
            hideAnimation(setY: tabBar.frame.minY, setAlpha: 0, isHide: true)
        }
        
    }
    
    private func hideAnimation(setY: CGFloat, setAlpha: CGFloat, isHide: Bool) {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.addBar.frame.origin.y = setY
                        self.addBar.alpha = setAlpha
                        self.addBarIsHidden = isHide
        }) { (finished) in
//            self.addBarIsHidden = isHide
        }
    }
}

extension RoutableViewController {
    
    private func setupAddBar() {
        guard let tabBar = tabBarController?.tabBar else { return }
        
        let addBarFrame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.minY, width: tabBar.frame.width, height: 40)
        addBar = AdditionalTabBarView(frame: addBarFrame)
        addBar.backgroundColor = .clear
        self.view.addSubview(addBar)
    }
    
    private func setBlurNavBar(_ module: Module) {
        guard let navigationController = navigationController else {return}
        navigationItem.largeTitleDisplayMode = .always
        
        switch module {
        case .main:
            let frameForBlackView = CGRect(x: 0, y:0-navigationController.navigationBar.bounds.height, width: navigationController.navigationBar.bounds.width, height: navigationController.navigationBar.bounds.height*2)
            let blackView = UIView(frame: frameForBlackView)
            blackView.backgroundColor = #colorLiteral(red: 0.1057690903, green: 0.1057690903, blue: 0.1057690903, alpha: 1)
            
            navigationController.navigationBar.insertSubview(blackView, at: 0)
        case .album:
            let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            frost.frame = CGRect(x: 0, y:0-navigationController.navigationBar.bounds.height, width: navigationController.navigationBar.bounds.width, height: navigationController.navigationBar.bounds.height*2)
            navigationController.navigationBar.setBackgroundImage(UIImage.image(with: .clear), for: .default)
            
            frost.alpha = 0.85
            
            navigationController.navigationBar.insertSubview(frost, at: 0)
        }
    }
    
    private func setBlurTabBar(_ module: Module, willDisappear: Bool) {
        guard let tabBar = tabBarController?.tabBar else { return }
        
        if willDisappear {
            frost.removeFromSuperview()
        } else {
            switch module {
            case .main:
                tabBar.backgroundImage = UIImage.image(with: #colorLiteral(red: 0.1057690903, green: 0.1057690903, blue: 0.1057690903, alpha: 1))
            case .album:
                tabBar.backgroundImage = UIImage.image(with: .clear)
                
                frost.frame = tabBar.bounds
                frost.autoresizingMask = .flexibleWidth
                
                tabBar.insertSubview(frost, at: 0)
            }
        }
    }
}
