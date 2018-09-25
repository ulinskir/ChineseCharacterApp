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
    
    
    required init(value: Int = 0) {
        // set myValue before super.init is called
        
        super.init(frame: .zero)
        
        // set other operations after super.init, if required
        backgroundColor = .white
    }
    
    // For storyboard
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // If button in storyboard is Custom, you'll need to set
        // title color for control states and optionally the font
        // I've set mine to System, so uncomment next three lines if Custom
        
        //self.setTitleColor(tintColor, for: .normal)
        //self.setTitleColor(tintColor.withAlphaComponent(0.3), for: .highlighted)
        //self.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        //configure()
        
        backgroundColor = .white
    }
    
}

class ModuleButton: UIButton {
    
    
    required init(value: Int = 0) {
        // set myValue before super.init is called
        
        super.init(frame: .zero)
        
        // set other operations after super.init, if required
        backgroundColor = .white
    }
    
    // For storyboard
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // If button in storyboard is Custom, you'll need to set
        // title color for control states and optionally the font
        // I've set mine to System, so uncomment next three lines if Custom
        
        //self.setTitleColor(tintColor, for: .normal)
        //self.setTitleColor(tintColor.withAlphaComponent(0.3), for: .highlighted)
        //self.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        //configure()
        
        backgroundColor = .white
    }
    
}
