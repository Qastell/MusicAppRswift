//
//  UIViewController+Extension.swift
//  Music Player
//
//  Created by Кирилл Романенко on 29/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiateFromStoryboard() -> Self {
        return instantiateController()
    }

    fileprivate class func instantiateController<T>() -> T {
        let storyboard = R.storyboard.main()
        let controller = storyboard.instantiateViewController(
            withIdentifier: String(describing: self)) as! T
        return controller
    }
}
