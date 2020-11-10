//
//  MainTabBarController.swift
//  Music Player
//
//  Created by Кирилл Романенко on 28/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var router = Router()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        let mainVC = UINavigationController(rootViewController: router.create(.main))
        mainVC.tabBarItem.image = R.image.table()
        mainVC.tabBarItem.selectedImage = R.image.table()
        
        let albumVC = UINavigationController(rootViewController: router.create(.album))
        albumVC.tabBarItem.image = R.image.collection()
        albumVC.tabBarItem.selectedImage = R.image.collection()
        albumVC.loadViewIfNeeded()
        
        viewControllers = [mainVC, albumVC]
        
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.3411764706, blue: 0.4196078431, alpha: 1)
    }
}
