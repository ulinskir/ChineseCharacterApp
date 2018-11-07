//
//  learningSession.swift
//  ChineseCharacterApp
//
// Maintains a list of the characters a user will practice in a learning session
// and the scores the user gets for each character practiced
//
//  Created by Risa Ulinski on 10/27/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation

class LearningSesion {
    var charsToPractice: [ChineseChar]
    var charsAlreadyPracticed: [Int : Double]
    var level: Int
    var current: Int
    
    init() {
        charsToPractice = []
        charsAlreadyPracticed = [:]
        level = 0
        current = 0
    }
    
    init(charsToPractice:[ChineseChar]) {
        self.charsToPractice = charsToPractice
        charsAlreadyPracticed = [:]
        level = 0
        current = 0

    }
    
    init(charsToPractice:[ChineseChar], level: Int) {
        self.charsToPractice = charsToPractice
        charsAlreadyPracticed = [:]
        self.level = level
        current = 0

    }
    
    func getCurrentChar() -> ChineseChar? {
        if current > 0 && current < charsToPractice.count {
            return charsToPractice[current]
        }
        return nil
    }
    
    func progress() -> Double {
        if self.charsToPractice.count == 0 {
            return 1.0
        }
        return Double(self.charsAlreadyPracticed.count) / Double(self.charsToPractice.count)
    }
    
    func charPracticed(score:Double) {
        charsAlreadyPracticed[current] = score
        current += 1
        //TO DO: determine if score is failing and if so make user practice it again
    }
    
    func sessionFinished() -> Bool {
        return charsToPractice.count == current
    }
    //TO DO: update all characters to account for new score information when session is finished
}
