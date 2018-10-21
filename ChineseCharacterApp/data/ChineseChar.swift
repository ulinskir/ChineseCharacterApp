//
//  ChineseChar.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/3/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation

class ChineseChar {
    var char : String
    var strokes : [String]
    var definition : String
    var pinyin: [String]
    var decomposition: String
    var radical: String
    
    init(character: String, strks: [String], def: String, pin: [String], decomp: String, rad: String) {
        char = character
        strokes = strks
        definition = def
        pinyin = pin
        radical = rad
        decomposition = decomp
    }
}
