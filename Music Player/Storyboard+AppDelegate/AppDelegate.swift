//
//  AppDelegate.swift
//  Music Player
//
//  Created by Кирилл Романенко on 23/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//  Проверка работы Git

import UIKit

let serviceFactory = ServiceFactory()
let audioService = serviceFactory.audioService()
let songService = serviceFactory.songService()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = MainTabBarController()
        tabBarController.tabBar.alpha = 0.9
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}


