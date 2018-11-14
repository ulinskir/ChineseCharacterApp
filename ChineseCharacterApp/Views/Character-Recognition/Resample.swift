//
//  Resample.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics

private func pathLength(path: [Point]) -> Double {
    var length:Double = 0
    for i in 0..<(path.count - 1) {
        let p1 = path[i]
        let p2 = path[i+1]
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        length += sqrt(dx * dx + dy * dy)
    }
    return length
}
class Source_prep {
func resample(_ points: [CGPoint],_ totalPoints: Int) -> [Point] {
    // Goes from a list of an arbitrary number of unevenly spaced CGPoints to a list of evenly spaced Points (double precision)
    var initialPoints = points.map(util.cg_to_Point)
    let interval = pathLength(path:initialPoints) / Double(totalPoints - 1)
    var totalLength: Double = 0.0
    var newPoints: [Point] = [initialPoints.first!]
    
    for i in 1..<initialPoints.count {
        let currentLength = sqrt(util.distance2(point1: initialPoints[i-1], point2: initialPoints[i]));
        
        if ((totalLength+currentLength) >= interval) {
            let qx = initialPoints[i-1].x + ((interval - totalLength) / currentLength) * (initialPoints[i].x - initialPoints[i-1].x)
            let qy = initialPoints[i-1].y + ((interval - totalLength) / currentLength) * (initialPoints[i].y - initialPoints[i-1].y)
            let q:Point = (qx,qy)
            newPoints.append(q)
            initialPoints.insert(q, at: i)
            totalLength = 0.0
            
        } else {
            totalLength += currentLength
        }
    }
    
    if newPoints.count == totalPoints-1 {
        newPoints.append(util.cg_to_Point(points.last!))
    }
    return newPoints
}
}
