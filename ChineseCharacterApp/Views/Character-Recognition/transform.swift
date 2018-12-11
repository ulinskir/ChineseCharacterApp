//
//  transform.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 12/6/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation


private func + (a:Point, b:Point) -> Point {
    return (a.x + b.x, a.y + b.y)
}

private func - (a:Point, b:Point) -> Point {
    return Point(x: a.x - b.x, y: a.y - b.y)
}
//func angleDiff(angle1: Double, angle2: Double) -> Double {
//    // Difference of 2 angles
//    let diff = abs(angle1 - angle2);
//    return min(diff, 2 * Double.pi - diff);
//}
//
//func getAngle(median:[Point]) -> Double {
//    // Get overall angle of set of points.
//    let diff = util.subtract(median[(median.count - 1)], median[0]);
//    return atan2(diff.y, diff.x)
//}

func rotate(_ points: [Point], byRadians userRads: Double, minAngle: Double = Double.pi / 4) -> [Point] {
    assert(minAngle < Double.pi, "Minimum Angle Too Large")
    let maxAngle = 2 * Double.pi - minAngle
    var radians = userRads
    
    // if the angle between the two strokes is larger than the threshhold
    if userRads > minAngle && userRads < maxAngle {
        radians = (userRads < Double.pi ? minAngle : maxAngle)
    }
    let centroid:Point = (0.0,0.0)
    let cosvalue = cos(radians)
    let sinvalue = sin(radians)
    var newPoints: [Point] = []
    for point in points {
        let qx = (point.x - centroid.x) * cosvalue - (point.y - centroid.y) * sinvalue + centroid.x
        let qy = (point.x - centroid.x) * sinvalue + (point.y - centroid.y) * cosvalue + centroid.y
        newPoints.append(Point(x: qx, y: qy))
    }
    return newPoints
}

func squish(from source:[Point], to dest:[Point]) -> [Point] {
    assert(source.first! == (0.0,0.0))
    let util = util_fn()

    let scaleFactor = util.distance2(point1: source.first!, point2: source.last!) / util.distance2(point1: dest.first!, point2: dest.last!)
    
    return source.map { (scaleFactor * $0.x, scaleFactor * $0.y) }
}

class Transformer {
    private func moveStartPoints (_ points:[Point]) -> [Point] {
        let startPoint = points.first!
        return points.map {$0 - startPoint}
    }
    
    func transform(userStroke:[Point], targetStroke:[Point], angleThreshhold:Double) -> [Point]{
        
        assert(userStroke.count >= 2 && targetStroke.count >= 2, "Source and target are too small")
        var source = moveStartPoints(userStroke)
        let dest = moveStartPoints(targetStroke)
        let theta = angleDiff(angle1: getAngle(median: source), angle2: getAngle(median: dest))
        
        source = rotate(source, byRadians: theta, minAngle: angleThreshhold).map {
            $0 + targetStroke.first!
        }
        

        return source
        
    }
    
    
}
