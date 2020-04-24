//
//  ViewController.swift
//  FindCardGame
//
//  Created by Vikram Rajpoot on 24/04/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLbl: UILabel!
    var counter = 0
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    let game = FindCard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        setupNewGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if game.isPlaying {
            resetGame()
        }
    }
    
    func setupNewGame() {
        collectionView.reloadData()
    }
    
    func resetGame() {
        counter = 0
        countLbl.text = "Steps: \(counter)"
        game.restartGame()
        setupNewGame()
        collectionView.isHidden = false
    }
    
    @IBAction func onStartGame(_ sender: Any) {
        resetGame()
        collectionView.isHidden = false
        counter = 0
        countLbl.text = "Steps: 0"
        self.game.newGame()
    }
    
    @objc func timerAction() {
        counter += 1
        countLbl.text = "Steps: \(counter)"
    }
}

// MARK: - CollectionView Delegate Methods
extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        counter += 1
        countLbl.text = "Steps: \(counter)"
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        if cell.shown { return }
        game.didSelectCard(cell.card)
       
        collectionView.deselectItem(at: indexPath, animated:true)
    }
}

// MARK: - MemoryGameProtocol Methods
extension GameController: FindGameProtocol {
    
    func findGameDidStart(_ game: FindCard) {
        collectionView.reloadData()
    }
    
    func findGame(_ game: FindCard, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCollectionViewCell
            cell.showCard(true, animted: true)
        }
    }
    
    func findGame(_ game: FindCard, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCollectionViewCell
            cell.showCard(false, animted: true)
        }
    }
    
    func findGameDidEnd(_ game: FindCard) {
        
        let alertController = UIAlertController(
            title: defaultAlertTitle,
            message: defaultAlertMessage,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.collectionView.isHidden = true
        }
        let playAgainAction = UIAlertAction(title: "Youe have done with \(counter) moves", style: .default) { [weak self] (action) in
            self?.collectionView.isHidden = true
            self?.resetGame()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) { }
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

