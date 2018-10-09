//
//  ChineseChar.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/3/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation

struct ChineseChar {
    let chinese:String
    let pinyin:String
    let english:String
    
    init(chinese:String, pinyin:String, english:String) {
        self.chinese = chinese
        self.pinyin = pinyin
        self.english = english
    }
    
}
