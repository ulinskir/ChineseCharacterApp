//
//  ColorScheme.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor  {
    struct Day {
        static let skyBlue = UIColor(red:0.79, green:0.92, blue:0.95, alpha:1.0)
        static let carbonGray = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
        static let maroon = UIColor(red:0.45, green:0.00, blue:0.00, alpha:1.0)
        static let neutralGray = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
    }
    
    struct Night {
        static let navy = UIColor(red:0.07, green:0.09, blue:0.38, alpha:1.0)
        static let darkBlue = UIColor(red:0.18, green:0.27, blue:0.51, alpha:1.0)
        static let mediumBlue = UIColor(red:0.33, green:0.42, blue:0.67, alpha:1.0)
        static let gray = UIColor(red:0.53, green:0.53, blue:0.61, alpha:1.0)
        static let purple = UIColor(red:0.75, green:0.66, blue:0.87, alpha:1.0)
    }
}
