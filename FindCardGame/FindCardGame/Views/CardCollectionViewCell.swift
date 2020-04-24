//
//  CardCollectionViewCell.swift
//  FindCardGame
//
//  Created by Vikram Rajpoot on 24/04/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    
       var card: Card? {
           didSet {
               guard let card = card else { return }
               numberLbl.text = "\(card.number!)"
           }
       }
       
       var shown: Bool = false
       
       // MARK: - Methods

       func showCard(_ show: Bool, animted: Bool) {
           frontView.isHidden = false
           backView.isHidden = false
           shown = show
           
           if animted {
               if show {
                   UIView.transition(
                       from: backView,
                       to: frontView,
                       duration: 0.5,
                       options: [.transitionFlipFromRight, .showHideTransitionViews],
                       completion: { (finished: Bool) -> () in
                   })
               } else {
                   UIView.transition(
                       from: frontView,
                       to: backView,
                       duration: 0.5,
                       options: [.transitionFlipFromRight, .showHideTransitionViews],
                       completion:  { (finished: Bool) -> () in
                   })
               }
           } else {
               if show {
                bringSubviewToFront(frontView)
                   backView.isHidden = true
               } else {
                bringSubviewToFront(backView)
                   frontView.isHidden = true
               }
           }
       }
}
