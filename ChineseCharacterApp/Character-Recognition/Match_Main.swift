//
//  Match_Main.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics



func source_process_points(_ source:[CGPoint]) -> [Point] {
    let source_prep = Source_prep()
    return source_prep.resample(source, 128)
}


func target_points(_ target:String) -> [Point] {
    let bezierPointsInstance = bezierPoints()
    return bezierPointsInstance.get_points(from: target)
}


