//
//  Match_Main.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics

typealias StrokeResult = (completed:Bool, rightOrder:Bool, rightDirection:Bool)

let src_edges:Edges = (0,500,500,0)
let dest_edges:Edges = (0,270,270,0)

func processSourcePoints(_ source:[CGPoint]) -> [Point] {
    let source_prep = Source_prep()
    return source_prep.resample(source, 128)
}

let instanceOfRecognizer = Recognizer()

class Matcher {
    
    func processTargetPoints(_ target:[String], destDimensions:Edges) -> [[Point]] {//,_ src_edges:Edges,_ dest_edges:Edges) -> [Point] {
        // Parses list of SVG paths to bezier curves, and samples them to create a list of strokes.
        let scale_fn = SVGConverter().make_canvas_dimension_converter(from: src_edges, to: dest_edges)
        let bezierPointsInstance = bezierPoints()
        var points:[[Point]] = []
        for i in 0..<target.count {
            points.append(bezierPointsInstance.get_points(from: target[i], scale: scale_fn))
        }
        return points
    }

// Target is a list of points, but source needs to be resampled maybe, but also IDK if resmpling is necessary
    func full_matcher(source:[[Point]], target:[[Point]]) -> [StrokeResult] {
        
        var result:[(StrokeResult)] = []
        
        // loop through strokes in the character
        var remainingTargets = target
        
        for i in 0..<source.count {
            for j in 0..<target.count {
                // maybe resample here
                let curr = instanceOfRecognizer.recognize(source:source[i], target:target[j], offset:0)
                
                if (curr.score != -Double.infinity){    // If the stroke matches
                    result.append((true, j==0, curr.rightDirection))
                    remainingTargets.remove(at:j)
                    break
                }
            result.append((false, false, false))
            }
        }
        return result
    }
}
