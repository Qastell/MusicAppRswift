//
//  BaseButton.swift
//  Music Player
//
//  Created by Кирилл Романенко on 29/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

class BaseButton: UIButton {

    init(image: UIImage, frame: CGRect, target: Any?, action: Selector) {
        super.init(frame: frame)
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        flash()
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
