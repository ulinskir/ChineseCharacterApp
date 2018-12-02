//
//  Match_Main.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics

typealias StrokeResult = (completed:Bool, rightDirection:Bool, rightOrder:Bool)
typealias FoundStroke = (rightDirection:Bool, orderDrawn:Int, targetIndex: Int, smoothedOrder:Int)

let srcEdges:Edges = (0,500,500,0)
let destEdges:Edges = (0,335,335,0)
let RESAMPLE_VAL = 64
let RESAMPLING = false
let SIMPLE_ORDER_CHECK:Bool = true
let COMPOUND_ORDER_CHECK:Bool = true

let instanceOfRecognizer = Recognizer()

class Matcher {
    func get_hints(_ target:[String], destDimensions:Edges) -> [Point] {
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
    func full_matcher(source:[[Point]], target:[[Point]]) -> ([StrokeResult], [Int]) {
        
        var strokeInfo:[(StrokeResult)] = []
        var strokeInfoSimpleOrder:[StrokeResult] = []

        typealias remTarg = (points:[Point], completed:Bool)
        // loop through strokes in the character
        var remainingTargets:[remTarg] = target.map({(a:[Point]) -> remTarg in return (a, false)})
        var foundStroke = false
        var numPrevFoundStrokes = 0
        var errorStrokes:[Int] = []
        var foundStrokes:[FoundStroke] = []
        
//        func is_in_order(j:Int) {
//        }
        for _ in 0..<target.count {
            strokeInfo.append((false,false,false))
            strokeInfoSimpleOrder.append((false,false,false))
            
        }
        
        for srcIndex in 0..<source.count {
            foundStroke = false
            if(numPrevFoundStrokes < remainingTargets.count) {
                for targetIndex in 0..<remainingTargets.count {
                    // maybe resample here
                    let currTarget = remainingTargets[targetIndex]
                    if(!currTarget.completed){
                        
                    
                    let curr = instanceOfRecognizer.recognize(source:processSourcePoints(source[srcIndex]), target:currTarget.points, offset:0)
                    
                    if (curr.score != -Double.infinity){
                        // If the stroke matches
                        
//                        result.append((true, curr.rightDirection, srcIndex, j==0))
                        foundStrokes.append((curr.rightDirection, numPrevFoundStrokes, targetIndex, -1))
                        strokeInfoSimpleOrder[targetIndex] = ((true, curr.rightDirection, srcIndex==targetIndex))
//                        foundStrokes[j] = result.last!
                        foundStroke = true
                        remainingTargets[targetIndex].completed = true
                        numPrevFoundStrokes += 1
                        }
                    }

                    
                }
                
                if(!foundStroke) {errorStrokes.append(srcIndex)}
            }}
            print("found strokes:", numPrevFoundStrokes)
        
            var sorted:[FoundStroke] = foundStrokes
            sorted.sort (by:{(a:FoundStroke, b:FoundStroke) -> Bool in
                return (a.targetIndex < b.targetIndex)
            })
//            var paired = sorted
            for i in 0..<sorted.count {
                sorted[i].smoothedOrder = i
            }
        
        
            for i in 0..<sorted.count {
                strokeInfo[sorted[i].targetIndex] = (true, sorted[i].rightDirection, sorted[i].smoothedOrder >= sorted[i].orderDrawn)
            }
        
        
        
        
        
//        for i in 0..<foundStrokes.count {
//            if(foundStrokes[i] != nil) {
//            let srcIndex = foundStrokes[i]!.matchingIndex
//            foundStrokes[i]!.rightOrder = srcIndex - errorStrokes < i
//
//            }
        
        
        if(COMPOUND_ORDER_CHECK) {
            for i in 0..<strokeInfo.count {
                strokeInfo[i].rightOrder = strokeInfo[i].rightOrder && strokeInfoSimpleOrder[i].rightOrder
            }
            return (strokeInfo, errorStrokes)
        }
        return (SIMPLE_ORDER_CHECK ? strokeInfoSimpleOrder : strokeInfo, errorStrokes)
    }
}
