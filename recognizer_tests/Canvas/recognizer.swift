//
//  Recognizer.swift
//  Canvas
//
//  Created by Krishna Kahn on 10/2/18.
//  Copyright © 2018 Krishna Kahn. All rights reserved.
//

import Foundation
//import

// Result is for the scoring component
typealias Result = (score:Double, source:(Point,Point)?, target: (Point,Point)?, warning: String?, penalties:Int?)
// what you think it is.
typealias Point = (x:Double, y:Double)

let kAngleThreshold = Double.pi / 5
let kDistanceThreshold = 0.3;
let kLengthThreshold = 1.5;

// Number of segments you're actually allowed to skip
let kMaxMissedSegments = 1;
let kMaxOutOfOrder:Double = 2;

// letant for how much distance in desired stroke location is allowable
let kMinDistance = 1 / 16;

let kMissedSegmentPenalty = 1.0;
let kOutOfOrderPenalty = 2;
let kReversePenalty = 2;
let kHookShapes:[[Point]] = [[(1, 3), (-3, -1)], [(3, 3), (0, -1)]];

class util_fn {
    // A set of utility functions
    
    // Returns distance squared of 2 points
    func distance2 (point1: Point, point2: Point) -> Double {
        return norm2(subtract(point1, point2))};
    // Deepcopy of a point
    let clone = {(_point:Point) -> Point in return (_point.x, _point.y)}
    
    // Squares a point's coordinates. Basically just there for distance2.
    // Can't do exponents on floats apparently, so this is what we have now. If there is a better way def chage it.
    let norm2 = {(_point: Point) -> Double in return (_point.x * _point.x) + (_point.y * _point.y) }
    // Round both coordinates in a point
    let _round = {(point: Point) -> Point in return (round(point.x),round(point.y))}
    // Get the difference in X and Y coordinates
    let subtract = {(point1:Point,point2: Point) -> Point in return (point1.x - point2.x, point1.y - point2.y)}
}
let util = util_fn()
//func
func angleDiff(angle1: Double, angle2: Double) -> Double {
    // Difference of 2 angles
    let diff = abs(angle1 - angle2);
    return min(diff, 2 * Double.pi - diff);
}

func getAngle(median:[Point]) -> Double {
    // Get overall angle of set of points.
    let diff = util.subtract(median[(median.count - 1)], median[0]);
    return atan2(diff.y, diff.x)
}
func getBounds(median: [Point]) -> [Point] {
    // finds the minimum and maximum x and y of a set of points
    var _min:Point = (Double.infinity, Double.infinity)
    var _max:Point = (-Double.infinity, -Double.infinity)
    
    for point in median {
        _min.x = min(_min.x, point.x);
        _min.y = min(_min.y, point.y);
        _max.x = max(_max.x, point.x);
        _max.y = max(_max.y, point.y);
    }
    return [_min,_max]
}
func getMidpoint(median: [Point]) -> Point {
    let bounds = getBounds(median:median);
    return ((bounds[0].x + bounds[1].x) / 2,
            (bounds[0].y + bounds[1].y) / 2)
}

func getMinimumLength (pair: [Point]) -> Double {
    // Gets distance between source and target, then adds kMinDistance
    return sqrt(util.distance2(point1: pair[0], point2: pair[1])) + Double(kMinDistance);
}

func hasHook (median: [Point]) -> Bool {
    // determine if the stroke is supposed to have a hook?
    if (median.count < 3) {return false};
    
    if (median.count > 3) {return true};
    // for shape in kHookShapes:
    for shape in kHookShapes {
        if match(median:median, shape:shape) {
            return true};
    }
    return false;
}
func match (median: [Point], shape: [Point]) -> Bool {
    // TODO: LOOK OVER THIS WITH ENERGETIC EYES
    if (median.count != shape.count + 1) {return false};
    for i in 0..<shape.count {
        let angle = angleDiff(angle1: getAngle(median: Array(median[i...i+2])), angle2: getAngle(median:[(0, 0), shape[i]]));
        if (angle >= kAngleThreshold) {return false};
    }
    return true;
}
func performAlignment (_source:[Point], _target:[Point]) -> Result {
    // Calculating difference between desired stroke and user-inputted stroke
    
    
    // Deep copies of source and target. I'd assume there's a good reason to do this or they wouldn't
    let source = _source.map(util.clone);
    let target = _target.map(util.clone);
    
    // a list where the first element is
    // a list from 0 to length of source, where the first element is 0 and the rest are -infinity
    // Gets rows pushed onto it
    
    // A 0 and a bunch of -(infinity)
    var memo:[[Double]] = [Array(0..<source.count).map(
    {(j:Int) -> Double in return (j > 0) ? -Double.infinity : 0})];
    
    // i iterates through target points
    // For every single point in the target, compares to every combination of 2 source points
    for i in 1..<target.count {
        
        var row = [Double.infinity];
        
        // j iterates through source points
        for j in 1..<source.count {
            
            // Starting with minimum
            var best_value = -Double.infinity;
            
            let start = max(j - kMaxMissedSegments - 1, 0);
            
            // k iterates through all previous points to the jth point in source
            // Best_value is the score of the best scoring (most similar to target points) pair of point j and a point before point j
            for k in start..<j {
                
                // Condition for skipping score pairing (-infinity in the corresponding element of memo)
                
                // Why are they comparing to the kth thing if the rows are added based on the j loop???????
                
                // Looking at the score of the comparison of the source points up to k and the previous target point
                
                
                if (memo[i - 1][k] == -Double.infinity) {continue};
                
                // memo[i - 1][k] is the score of the points up to the previous target point and up to the first source point that is getting checked
                
                let score = scorePairing(
                   
                    source:[source[k], source[j]], target: [target[i - 1], target[i]], is_initial_segment: i == 1);
                // Compares the two points in the source to two adjacent points of target
                if (score != -Double.infinity) {
                    print(score)
                }
                
                // Number of source segments being skipped
                let penalty = (j - k - 1) * Int(kMissedSegmentPenalty);
                
                // looking at the previous row of memo, and passing on the best score if it's better than the score for this row
                
                // Setting the best value to the maximum of (the previous source point combination)
                // and the sum of the score pairing of the these two source points to the current target point
                // and its cumulative comparison to all the previous target points
                best_value = max(best_value, score + memo[i - 1][k] - Double(penalty));
            }
            row.append(best_value)
        }
        memo.append(row);
    }
    var result:Result = (score: -Double.infinity,
                         source: nil,
                         target: nil,
                         warning: nil,
                         penalties: nil)
    // is either target.count or target.count - 1
    let min_matched = target.count - (hasHook(median:target) ? 1 : 0);
    
    // Read memo table and get scores
    for i in min_matched - 1..<target.count{
        
        // penalty for how far from the end your current best score is.
        let penalty = (target.count - i - 1) * Int(kMissedSegmentPenalty);
        
        // for each value of i that was matched, take the last column of memo
        let score = memo[i][source.count - 1] - Double(penalty);
        
        
        if (score > result.score) {
            result = (score:0.0,
                      source:(source[0], source[source.count - 1]),
                      target: (target[0], target[i]),
                      warning: i < target.count - 1 ? "Should hook." : nil,
                      penalties:0);
            
            
        }
    }
    return result;
}

func scorePairing (source: [Point], target: [Point], is_initial_segment: Bool) -> Double {
    
    // Angle offset
    let angle = angleDiff(angle1:getAngle(median:source), angle2:getAngle(median:target));
    
    // Distance between midpoints
    let targetMidpoint = getMidpoint(median:target)

    let sourceMidpoint = getMidpoint(median:source)
    let distance = sqrt(util.distance2(
        point1: sourceMidpoint, point2:targetMidpoint));
    
    // length ratio with abs(ln(x)) done to make the inputs make sense (just go with it)
    let length = abs(log(
        abs(getMinimumLength(pair:source) / getMinimumLength(pair:target))));
    
    print("sourceMidpoint: ", sourceMidpoint, "targetMidpoint", targetMidpoint)
    
    // If angle or distance or length are beyond the threshold, returns -infinity
    if (angle > (is_initial_segment ? 1 : 2) * kAngleThreshold ||
        distance > kDistanceThreshold || length > kLengthThreshold) {
        print("failed_scorePairing")
        return -Double.infinity;
    }
    // Return the negative sum of the differences between angle, distance, and length
    return -angle - distance - length;
//    print("angle:",angle,"distance",distance,"length",length)
//    return 0.0
}
class Recognizer: NSObject {
    func recognize (source:[Point], target:[Point], offset: Double) -> Result {
        // checks for stroke and reverse stroke
        
        if (offset > kMaxOutOfOrder)
        {return (score: -Double.infinity,source: nil,target:nil,warning:nil,penalties:nil)};
        
        // Perform alignment and check score
        var result = performAlignment(_source:source, _target:target);
        
        // if it sucks, see if they did the stroke in reverse
        if (result.score == -Double.infinity) {
            var rev_source = source;
            rev_source.reverse()
            let alternative = performAlignment(_source:rev_source, _target:target);
            
            // yell at them
            if (alternative.score != -Double.infinity) {
                result = (score: alternative.score,
                          source: alternative.source,
                          target: alternative.target,
                          warning: "Reversed Stroke",
                          penalties: alternative.penalties! + 1)
            }
        }
        result.score -= abs(offset) * Double(kOutOfOrderPenalty);
        return result;
    }
}
