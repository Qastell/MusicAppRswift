//
//  Multidelegate.swift
//  Music Player
//
//  Created by Кирилл Романенко on 04/11/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation

class MultiDelegate<T> {
    // Т - тип протокола
    
    // массив получателей
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(delegate: T) {
        for oneDelegate in delegates.allObjects.reversed() {
            if oneDelegate === delegate as AnyObject {
                delegates.remove(oneDelegate)
            }
        }
    }
    
    func invoke(invocation: (T) -> ()) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}




















