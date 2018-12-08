//
//  Match_Main.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics

typealias StrokeResult = (score: Double, completed:Bool, rightDirection:Bool, rightOrder:Bool)
typealias FoundStroke = (rightDirection:Bool, orderDrawn:Int, targetIndex: Int, smoothedOrder:Int, score:Double)

let srcEdges:Edges = (0,500,500,0)
//let destEdges:Edges = (0,335,335,0)
var RESAMPLE_VAL = 128
var MAX_SOURCE_POINTS = 128
let RESAMPLING_SOURCE = false
let SIMPLE_ORDER_CHECK:Bool = true
let COMPOUND_ORDER_CHECK:Bool = true
let FIVE_LEVELS = true
let REC_2 = false
let transforming = true
let maxTransformAngle = Double.pi / 6

let instanceOfRecognizer = Recognizer()

func is_right_direction(source:[Point],target:[Point]) -> Bool {
    return util.distance2(point1: source.first!, point2: target.first!) + util.distance2(point1: source.last!, point2: target.last!) <
        util.distance2(point1: source.first!, point2: target.last!) + util.distance2(point1:source.last!, point2:target.first!)
}
func get_distances(_ source:[Point],_ target:[Point]) -> Double {
    return (getMinimumLength(pair: [source.first!, target.first!]) + getMinimumLength(pair:[source.last!, target.last!])) / 2
}

func recog_ez(source:[Point], target:[Point], distance MaxDist:Double) -> (Bool,Bool) {
    let distance = MaxDist
    if (getMinimumLength(pair: [source.first!, target.first!]) < distance && getMinimumLength(pair:[source.last!, target.last!]) < distance) {
        return (true,true)
    }
    
    if (getMinimumLength(pair: [source.first!, target.last!]) < distance && getMinimumLength(pair:[source.last!, target.first!]) < distance) {
        return (true,false)
    }
    return (false,false)
}


class Matcher {
    func get_hints(_ target:[String], destDimensions:Edges) -> [Point] {
        var hints:[Point] = []
        let targetPoints = processTargetPoints(target, destDimensions: destDimensions)
        for stroke in targetPoints {
            hints.append(stroke[0])
        }
        return hints
    }
    func to_strokePoint(_ points:[Point]) -> [StrokePoint] {
        let res = points.map({(pt:Point) -> StrokePoint in return StrokePoint(pt)})
        return res
        }
    func from_strokePoint(_ points:[StrokePoint]) -> [Point] {
        let res = points.map({(pt:StrokePoint) -> Point in return (pt.x,pt.y)})
        return res
    }
    func processSourcePoints(_ source:[Point]) -> [Point] {
        if(!(RESAMPLING_SOURCE && source.count > MAX_SOURCE_POINTS)) { return source }
        print("resampling")
        let source_prep = Resampler()
        
        var res = source_prep.resamplePoints(source, totalPoints: RESAMPLE_VAL)
        if (res.last! != source.last!) {
            res.append(source.last!)
        }
        print("resampled to ", res.count)
        return res
    }
    
    func processTargetPoints(_ target:[String], destDimensions:Edges) -> [[Point]] {//,_ src_edges:Edges,_ dest_edges:Edges) -> [Point] {
        // Parses list of SVG paths to bezier curves, and samples them to create a list of strokes.

        let scaleFn = SVGConverter().make_canvas_dimension_converter(from: srcEdges, to: destDimensions)
        let bezierPointsInstance = bezierPoints()
        var points:[[Point]] = []
        for i in 0..<target.count {
            points.append(bezierPointsInstance.get_points(from: target[i], scale: scaleFn))
        }
//        print(points[0])
        return points
    }
    func get_level(results:[StrokeResult]) -> Int {
        
        var order = true
        var completed = true
        var direction = true
        var errorLevel = 0
        
        for result in results {
            if(result.completed) {
                direction = (direction && result.rightDirection)
                order = (order && result.rightOrder)
            }
            else {
                if(FIVE_LEVELS) {
                    return 4
                }
                completed = false
            }
        }
        let orderError = !order
        let charError = !completed
        let directionError = !direction
        
        
        errorLevel += charError ? 4 : 0
        errorLevel += orderError ? 2 : 0
        errorLevel += directionError ? 1 : 0
        return errorLevel
    }
    func remove_consecutive_dupes(target:[[Point]]) -> [[Point]] {
        var targetList = target
        for stroke in 0..<targetList.count {
            var toKill:[Int] = []
            var killed = 0
            for i in 1..<targetList[stroke].count {
                if targetList[stroke][i] == targetList[stroke][i-1] {
                    toKill.append(i)
                }
                
            }
            for index in toKill {
                targetList[stroke].remove(at:index - killed)
                killed += 1
            }
        }
        return targetList
    }
    
    func run_recognize_2(source:SwiftUnistroke, target:[SwiftUnistrokeTemplate], sourcePt:[Point], targetPt:[[Point]]) -> FoundStroke?
    {
        if(target.count == 0) {
            return nil
        }
        
        var goodTargets = target
        do{
            let (template, distance) = try source.recognizeIn(templates: target, useProtractor: false)
            
            if (template != nil) {
                let targetIndex = Int(template!.name)!
                let (completed, direction) = recog_ez(source: sourcePt, target: targetPt[targetIndex], distance: 50)
                if(completed) {
                    return (direction, -1, targetIndex, -1, score: -distance!)
                } else {
                    for i in 0..<goodTargets.count {
                        if goodTargets[i].name == template!.name {
                            goodTargets.remove(at: i)
                            break
                        }
                    }
                    return run_recognize_2(source: source, target: goodTargets, sourcePt: sourcePt, targetPt: targetPt)
                    }
                //                        foundStrokes[j] = result.last!
                
                
            }} catch {
                print(error.localizedDescription)
        }
        return nil
    }
    
// Target is a list of points, but source needs to be resampled maybe, but also IDK if resmpling is necessary
    func full_matcher(src:[[Point]],target:[[Point]], screenSize:Double = 335) -> ([StrokeResult], [Int]) {
        let maxDistance = screenSize / 5
        let targetList:[[Point]] = remove_consecutive_dupes(target: target)
        var source:[[Point]] = []
        for stroke in src {
            if (stroke.count > 3) {
                source.append(processSourcePoints(stroke))
            }
        }
        
        
        var strokeInfo:[(StrokeResult)] = []
        var strokeInfoSimpleOrder:[StrokeResult] = []

        typealias remTarg = (points:[Point], completed:Bool)
        // loop through strokes in the character
        var remainingTargets:[remTarg] = targetList.map({(a:[Point]) -> remTarg in return (a, false)})
        var foundStroke = false
        var numPrevFoundStrokes = 0
        var errorStrokes:[Int] = []
        var foundStrokes:[FoundStroke] = []
        
//        if(target.count >= 4){
//            print("verticalstroke:", target[3])
//            print("numStrokes:", target[3].count)
//        }
        
//        func is_in_order(j:Int) {
//        }
        let make_strpoint = {(a:Point) -> StrokePoint in return StrokePoint(x: a.x, y: a.y)}

        var targetRecognizers: [SwiftUnistrokeTemplate] = []
        for i in 0..<targetList.count {
            strokeInfo.append((-Double.infinity,false,false,false))
            strokeInfoSimpleOrder.append((-Double.infinity,false,false,false))
            targetRecognizers.append(SwiftUnistrokeTemplate(name:String(i), points: targetList[i].map(make_strpoint)))
            
        }
        
//        let srcRecog = source.map({(points: [Point]) -> SwiftUnistroke in return SwiftUnistroke(points.map(make_strpoint))})
        for srcIndex in 0..<source.count {
            foundStroke = false
            if(numPrevFoundStrokes < remainingTargets.count) {
                

                var bestMatch:(targetIndex:Int, strokeResult:StrokeResult)? = nil
                for targetIndex in 0..<remainingTargets.count {
                    // maybe resample here
                    let currTarget = remainingTargets[targetIndex]
                    let currSource = source[srcIndex]
                    let transformed = Transformer().transform(userStroke: currSource, targetStroke: currTarget.points, angleThreshhold: maxTransformAngle)
                    assert((transformed.first! == currTarget.points.first!), "transforming not working as intended")
                    
                    if(currTarget.completed){continue}
                    
                    var curr = instanceOfRecognizer.recognize(source:currSource, target:currTarget.points, offset:0)
                    if(transforming && curr.score == -Double.infinity) {
                        print("transforming")
                        
                        curr = instanceOfRecognizer.recognize(source:transformed,target:currTarget.points, offset:0)
                    }
                    
                    if source.count > 30 {
                        let shortened = Array(source[srcIndex][5..<source.count-5])
                    
                        let tooLong = instanceOfRecognizer.recognize(source:shortened, target:currTarget.points, offset:0)

                        if(tooLong.score != -Double.infinity) {
                            curr = tooLong
                        }
                    }
                    
                    if (curr.score != -Double.infinity){
                        
                        
                        if(recog_ez(source: source[srcIndex], target:currTarget.points, distance: maxDistance).0){
                            let score = get_distances(currSource, currTarget.points)

                            if(bestMatch == nil || bestMatch!.strokeResult.score > score) {
                                let newBest:StrokeResult = (score, true, curr.rightDirection, false)
                                bestMatch = (targetIndex, newBest)
                        
                        }
                        else{print("strokes", srcIndex, targetIndex, "found out of place")}
                    }
                    }
                
                
            }
                if(bestMatch != nil) {
                    
                    let bestRes = bestMatch!.strokeResult
                    let targetIndex = bestMatch!.targetIndex
                    foundStrokes.append((bestRes.rightDirection, numPrevFoundStrokes, bestMatch!.targetIndex, -1, bestRes.score))
                

                    strokeInfoSimpleOrder[targetIndex] = ((bestRes.score, true, bestRes.rightDirection, srcIndex == bestMatch!.targetIndex))
                //                        foundStrokes[j] = result.last!
                    foundStroke = true
                    remainingTargets[targetIndex].completed = true
                    numPrevFoundStrokes += 1
                }
                if(!foundStroke) {errorStrokes.append(srcIndex)}
                }
            
        }
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
                strokeInfo[sorted[i].targetIndex] = (sorted[i].score, true, sorted[i].rightDirection, sorted[i].smoothedOrder >= sorted[i].orderDrawn)
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
