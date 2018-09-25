//
//  HomeViewButton.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation

import UIKit

class HomeViewButton: UIButton {
    
    var myValue: Int
    
    required init(value: Int = 0) {
        // set myValue before super.init is called
        self.myValue = value
        
        super.init(frame: .zero)
        
        // set other operations after super.init, if required
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
