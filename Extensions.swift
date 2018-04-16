//
//  Extensions.swift
//  Concentration
//
//  Created by Mohamed Mohsen on 4/5/18.
//  Copyright © 2018 Mohamed Mohsen. All rights reserved.
//

import Foundation

extension Collection{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
    
    var NoElements: Bool{
        return count == 0 ? true : false
    }
}


extension Int{
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}
