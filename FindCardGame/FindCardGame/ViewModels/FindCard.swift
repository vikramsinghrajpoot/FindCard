//
//  FindCard.swift
//  FindCardGame
//
//  Created by Vikram Rajpoot on 24/04/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation

protocol FindGameProtocol {
    func findGameDidStart(_ game: FindCard)
    func findGameDidEnd(_ game: FindCard)
    func findGame(_ game: FindCard, showCards cards: [Card])
    func findGame(_ game: FindCard, hideCards cards: [Card])
}

class FindCard {
    // MARK: - Properties
    var delegate: FindGameProtocol?
    var cards:[Card] = [Card]()
    var cardsShown:[Card] = [Card]()
    var isPlaying: Bool = false
    // MARK: - Methods
    func newGame(){
        self.cards = createGame()
        isPlaying = true
        delegate?.findGameDidStart(self)
    }
    
    func restartGame() {
        isPlaying = false
        
        cards.removeAll()
        cardsShown.removeAll()
    }

    func cardAtIndex(_ index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }

    func indexForCard(_ card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }

    func didSelectCard(_ card: Card?) {
        guard let card = card else { return }
        
        delegate?.findGame(self, showCards: [card])
        
        if unmatchedCardShown() {
            let unmatched = unmatchedCard()!
            
            if card.equals(unmatched) {
                cardsShown.append(card)
            } else {
                let secondCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.findGame(self, hideCards:[card, secondCard])
                }
            }
            
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            endGame()
        }
    }
    
    fileprivate func endGame() {
        isPlaying = false
        delegate?.findGameDidEnd(self)
    }
    
    fileprivate func unmatchedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    fileprivate func unmatchedCard() -> Card? {
        let unmatchedCard = cardsShown.last
        return unmatchedCard
    }

    fileprivate func shuffleCards(cards:[Card]) -> [Card] {
        var randomCards = cards
        randomCards.shuffle()
        return randomCards
    }
    
    private func createGame() -> [Card]{
        let lottery = AppRandom()
        let numbers = lottery.generateNumbers(repetitions: repetation, maxValue: maxNumber)
        var cards = [Card]()
        for number in numbers {
            let card = Card(number:number)
            let copy = card.copy()
            cards.append(card)
            cards.append(copy)
        }
        return cards
    }
}
