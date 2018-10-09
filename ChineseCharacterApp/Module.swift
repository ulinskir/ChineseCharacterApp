//
//  Module.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/3/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation

class Module {
    var name: String
    var chineseChars: [ChineseChar]
    
    init(name: String, chineseChars: [ChineseChar]) {
        self.name = name
        self.chineseChars = []
    }
}

var colors = Module(name: "colors", chineseChars: [])
var animals = Module(name: "animals", chineseChars: [])
var numbers = Module(name: "numbers", chineseChars: [])
