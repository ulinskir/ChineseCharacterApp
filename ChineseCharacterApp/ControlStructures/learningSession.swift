//
//  learningSession.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/27/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation

class LearningSesion {
    var charsToPractice: [ChineseChar]
    var charsAlreadyPracticed: [ChineseChar : Int]
    
    init() {
        charsToPractice = []
        charsAlreadyPracticed = [:]
    }
    
    init(charsToPractice:[ChineseChar]) {
        self.charsToPractice = charsToPractice
        charsAlreadyPracticed = [:]
    }
    
    func progress() -> Double {
        if self.charsToPractice.count == 0 {
            return 1.0
        }
        return Double(self.charsAlreadyPracticed.count) / Double(self.charsToPractice.count)
    }
}
