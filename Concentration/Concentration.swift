//
//  Concentration.swift
//  Concentration
//
//  Created by Mohamed Mohsen on 4/2/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation

class Concentration{
    
     var cards = [Card]()
    private(set) var flipsCount = 0
    private(set) var scoreCount  = 0
    private var indexOfOneAndOnlyFaceUpCard: Int? //Hold the identifier of the selected card in case one card choosed
    {
        get{
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set{
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func AllFaceDown(){
        for index in cards.indices{
            cards[index].isFaceUp = false
        }
    }
    
    func ChooseCard(at index: Int)
    {
        assert(cards.indices.contains(index) , "Concentration.chooseCard(at: \(index) ) Not a Valid Card")
        if cards[index].isFaceUp == true {return}
        flipsCount += 1
        cards[index].flipState = cards[index].flipState == Card.cardFlipState.notFliped ? Card.cardFlipState.flipedOnce : Card.cardFlipState.flipedMoreThanOne
        
        if !cards[index].isMatched {
            if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index{
                if cards[matchedIndex] == cards[index]{
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    cards[index].isFaceUp = true
                    cards[matchedIndex].isFaceUp = true
                    scoreCount += 2
//                    return
                }else if cards[index].flipState == Card.cardFlipState.flipedMoreThanOne{
                    scoreCount -= 1
                }
                    cards[index].isFaceUp = true
                //TODO Flip if not matched not waited for choose the third one
                
            }else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        
        
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0 , "Concentration.numberOfPairsOfCards(\(numberOfPairsOfCards)) Can't be Negative")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card,card]
        }
        //TODO Shuffle the cards
        //...Done
        for _ in cards.indices {
            cards.swapAt(cards.count.arc4random, cards.count.arc4random)
        }
    }
}
































