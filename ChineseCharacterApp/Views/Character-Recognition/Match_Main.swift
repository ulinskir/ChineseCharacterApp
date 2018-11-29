//
//  Match_Main.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics

typealias StrokeResult = (completed:Bool, rightDirection:Bool, matchingIndex:Int, rightOrder:Bool?)

let srcEdges:Edges = (0,500,500,0)
let destEdges:Edges = (0,335,335,0)
let RESAMPLE_VAL = 64
let RESAMPLING = false




let instanceOfRecognizer = Recognizer()

class Matcher {
    func get_hints(_ target:[String], destDimensions:Edges) -> [Point]{
        var hints:[Point] = []
        let targetPoints = processTargetPoints(target, destDimensions: destDimensions)
        for stroke in targetPoints {
            hints.append(stroke[0])
        }
        return hints
    }
    func processSourcePoints(_ source:[Point]) -> [Point] {
        if(!RESAMPLING) { return source }
        
        let source_prep = Source_prep()
        return source_prep.resample(source, RESAMPLE_VAL)
    }
    
    func processTargetPoints(_ target:[String], destDimensions:Edges) -> [[Point]] {//,_ src_edges:Edges,_ dest_edges:Edges) -> [Point] {
        // Parses list of SVG paths to bezier curves, and samples them to create a list of strokes.
        let scaleFn = SVGConverter().make_canvas_dimension_converter(from: srcEdges, to: destEdges)
        let bezierPointsInstance = bezierPoints()
        var points:[[Point]] = []
        for i in 0..<target.count {
            points.append(bezierPointsInstance.get_points(from: target[i], scale: scaleFn))
        }
        print(points)
        return points
    }

// Target is a list of points, but source needs to be resampled maybe, but also IDK if resmpling is necessary
    func full_matcher(source:[[Point]], target:[[Point]]) -> [StrokeResult] {
        
        var result:[(StrokeResult)] = []
        
        // loop through strokes in the character
        var remainingTargets = target
        var foundStroke = false
        var errorStrokes:Int = 0
        var foundStrokes:[StrokeResult?] = []
        for _ in 0..<target.count {
            foundStrokes.append(nil)
        }
        func is_in_order(j:Int) {
            
        }
        
        for srcIndex in 0..<source.count {
            foundStroke = false
            if(remainingTargets.count > 0) {
                for j in 0..<remainingTargets.count {
                    // maybe resample here
                    let curr = instanceOfRecognizer.recognize(source:processSourcePoints(source[srcIndex]), target:remainingTargets[j], offset:0)
                    
                    if (curr.score != -Double.infinity){
                        // If the stroke matches
                        
                        result.append((true, curr.rightDirection, srcIndex, j==0))
                        foundStrokes[j] = result.last!
                        foundStroke = true
                        remainingTargets.remove(at:j)
                        break
                    }
                }
                
                if(!foundStroke) {errorStrokes += 1}
            }
        }
        
        for i in 0..<foundStrokes.count {
            if(foundStrokes[i] != nil) {
            let srcIndex = foundStrokes[i]!.matchingIndex
            foundStrokes[i]!.rightOrder = srcIndex - errorStrokes < i
            
            }
            
        }
        
        return result
    }
}
