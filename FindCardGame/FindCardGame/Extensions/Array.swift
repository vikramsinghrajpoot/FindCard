//
//  Array.swift
//  FindCardGame
//
//  Created by Vikram Rajpoot on 24/04/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
