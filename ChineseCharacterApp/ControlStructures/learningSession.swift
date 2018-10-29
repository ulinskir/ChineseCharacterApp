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
    
    func charPracticed(index:Int, score:Double) {
        charsAlreadyPracticed[index] = score
        //TO DO: determine if score is failing and if so make user practice it again
    }
    
    func sessionFinished() {
        //TO DO: update all characters to account for new score information
    }
}
