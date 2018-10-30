//
//  User.swift
//  ChineseCharacterApp
//
//  Created by HEOP on 10/9/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation


//allow user to change their password
class User {
    var ID: String
    var fullName: String
    var password: String
    var email: String
    var charactersLearned: Int
    var accuracy: Int
    
    init (fullName: String, password: String, email: String) {
        self.ID = NSUUID().uuidString
        self.fullName = fullName
        self.password = password
        self.email = email
        self.charactersLearned = 0
        self.accuracy = 0
    }
}
