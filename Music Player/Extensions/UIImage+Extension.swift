//
//  UIImage+Extension.swift
//  Music Player
//
//  Created by Кирилл Романенко on 29/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return image
    }
}
