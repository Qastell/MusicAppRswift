//
//  BarButton.swift
//  Music Player
//
//  Created by Кирилл Романенко on 16/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

class NavigationBarButton: BaseButton {

    init(imageName: String, navigationController: UINavigationController?, frame: CGRect, target: Any?, action: Selector) {
        super.init(imageName: imageName, frame: frame, target: target, action: action)
        if let navigationController = navigationController {
            navigationController.navigationBar.insertSubview(self, at: 1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
