//
//  ViewController.swift
//  Concentration
//
//  Created by Mohamed Mohsen on 4/1/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    struct themeEnviroment {
        var boardBackgroundColor: UIColor
        var cardBackgroundColor: UIColor
    }
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private var emojisThemes = ["🏈🏀🎾⚽️🎱🏓" , "🦒🐍🐌🙈🐢🐇" , "🍇🍉🍎🍓🥝🍊" , "🍣🌭🌮🍔🍙🍕"]//,"AYWMHR" , "☀︎☁︎♠︎♞☻♥︎"]
    private var emojisThemesCorrespondingEnviromentBackgrounds = [0: themeEnviroment.init(boardBackgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
                                                                      cardBackgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), //Sports
                                                                  1: themeEnviroment.init(boardBackgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), //Animals
                                                                  2: themeEnviroment.init(boardBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), //Fruits
                                                                  3: themeEnviroment.init(boardBackgroundColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))] //Food
    private var currentEmojiThemeIndex = 0
    private var emojisChoices = [Int:String]()
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1)/2
    }

    private var facedUpCardsCount: Int{
        return game.cards.filter{$0.isFaceUp}.count
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var PlayAgainLabel: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var flipsCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            
            
            UIView.transition(with: cardButtons[cardNumber],duration: 0.6,options: [.transitionFlipFromLeft],
                                  animations: {
                                    self.game.ChooseCard(at: cardNumber)
            },
              completion:{finished in
                if self.facedUpCardsCount == 2{
                    for index in self.self.game.cards.indices{
                        if self.cardButtons[index].isHidden {continue}
                        if self.game.cards[index].isFaceUp {
                            UIView.transition(with: self.cardButtons[index],duration: 0.6,options: [.transitionFlipFromLeft],
                                              animations: {
                                                self.game.cards[index].isFaceUp = false
                                                self.cardButtons[index].setTitle("", for: UIControlState.normal)
                                                self.cardButtons[index].backgroundColor =  self.emojisThemesCorrespondingEnviromentBackgrounds[self.currentEmojiThemeIndex]?.cardBackgroundColor
                            },
                          completion: { finished in
                            self.updateViewFromModel()
                            
                        })
                    }
                    }
                }
            }
            )
            
            updateFlipsCountLabel()
            updateScoreLabel()
            updateViewFromModel()
            if isFinishedTheGame() == true{
                gameIsFinished()
            }
        }else{
            print("nil value had been catched")
        }
        
//        if facedUpCardsCount == 2 {
//            for cardNumber in game.cards.indices{
//                let card = game.cards[cardNumber]
//                if card.isFaceUp && !card.isMatched{
//                    UIView.transition(with: cardButtons[cardNumber],
//                                      duration: 0.6,
//                                      options: [.transitionFlipFromLeft],
//                                      animations: {
//                                        self.game.cards[cardNumber].isFaceUp = false
//                    }
//                    )
//                }
//            }
//        }
        
        
        
    }
    private func updateFlipsCountLabel(){
        flipsCountLabel.text = "Flips: \(game.flipsCount)"
    }
    private func updateScoreLabel(){
        scoreLabel.text = "Score: \(game.scoreCount)"
    }
    private func updateViewFromModel()
    {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp
            {            
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.cardBackgroundColor
            }else{
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.cardBackgroundColor
            }
        }
    }
    
    //TODO check finishing the game and option to play a new game
    private func isFinishedTheGame()-> Bool
    {
        return game.cards.filter{$0.isMatched == true}.count == game.cards.count
    }
    
    private func gameIsFinished()
    {
        PlayAgainLabel.isHidden = false
    }
    
    @IBAction private func PlayAgain(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        updateViewFromModel()
        reset()
    }
    
    private func reset(){
        fillEmojisChoices()
        currentEmojiThemeIndex = emojisThemesCorrespondingEnviromentBackgrounds.count.arc4random
        self.view.backgroundColor = emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.boardBackgroundColor
        for cardButton in cardButtons{
            cardButton.backgroundColor = emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.cardBackgroundColor
        }
        flipsCountLabel.textColor = emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.cardBackgroundColor
        scoreLabel.textColor = emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.cardBackgroundColor
        PlayAgainLabel.setTitleColor(emojisThemesCorrespondingEnviromentBackgrounds[currentEmojiThemeIndex]?.cardBackgroundColor, for: UIControlState.normal)

        flipsCountLabel.text = "Flips: 0"
        scoreLabel.text = "Score: 0"
        PlayAgainLabel.isHidden = true
    }
    
    //TODO Generate automatic emojis according to cardButtons size
    private func fillEmojisChoices()
    {
        emojisThemes = ["🏈🏀🎾⚽️🎱🏓" , "🦒🐍🐌🙈🐢🐇" , "🍇🍉🍎🍓🥝🍊" , "🍣🌭🌮🍔🍙🍕"]
        for emojiTheme in emojisThemes {
            emojisChoices[emojisChoices.count] = emojiTheme
        }
    }
    
    private var emojis = [Card:String]()
    
    private func emoji(for card: Card) -> String
    {
        if emojis[card] == nil , emojisChoices.count > 0{
            let randomEmojiIndex = emojisChoices[currentEmojiThemeIndex]?.index((emojisChoices[currentEmojiThemeIndex]?.startIndex)!, offsetBy: (emojisChoices[currentEmojiThemeIndex]?.count.arc4random)!)
            if let randmomEmoji = emojisChoices[currentEmojiThemeIndex]?.remove(at: randomEmojiIndex!){
             emojis[card] = String(randmomEmoji)
            }
        }
        return emojis[card] ?? "?"
    }

}
























