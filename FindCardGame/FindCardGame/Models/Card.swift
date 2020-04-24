//
//  Card.swift
//  FindCardGame
//
//  Created by Vikram Rajpoot on 24/04/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation
import UIKit

class Card {
    // MARK: - Properties
    var id: String
    var shown: Bool = false
    static var allCards = [Card]()
    var number:Int!

    init(card: Card) {
        self.id = card.id
        self.shown = card.shown
        self.number = card.number

    }
    
    init(number: Int) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.number = number

    }
    
    // MARK: - Methods
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
}
