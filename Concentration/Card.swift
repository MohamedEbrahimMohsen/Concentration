//
//  Card.swift
//  Concentration
//
//  Created by Mohamed Mohsen on 4/2/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation

struct Card : Hashable
{
    var hashValue: Int{return identifier}
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    enum cardFlipState {
        case notFliped;
        case flipedOnce
        case flipedMoreThanOne
    };
    var flipState = cardFlipState.notFliped
    private var identifier: Int
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
