//
//  UIButton+Extension.swift
//  Music Player
//
//  Created by Кирилл Романенко on 29/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation
import UIKit

enum ButtonImage {
    case setTitle(from: Song)
    case setImage(from: Song)
}

extension UIButton {
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.15
        flash.fromValue = 1
        flash.toValue = 0.4
        flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
    
    func set(_ image: ButtonImage) {
        switch image {
        case .setTitle(let song):
            setTitle((song.indexSong+1).description, for: .normal)
        case .setImage(let song):
            setImage(UIImage(named: song.imageSong), for: .normal)
        }
    }
    
}
