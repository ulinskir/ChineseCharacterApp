//
//  Match_Main.swift
//  ChineseCharacterApp
//
//  Created by Krishna Kahn on 11/4/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import Foundation
import CoreGraphics

let src_edges:Edges = (0,500,0,500)
let dest_edges:Edges = (0,270,0,270)

func source_process_points(_ source:[CGPoint]) -> [Point] {
    let source_prep = Source_prep()
    return source_prep.resample(source, 128)
}

let instanceOfRecognizer = Recognizer()

class Matcher {
    func processTargetPoints(_ target:String) -> [Point] {//,_ src_edges:Edges,_ dest_edges:Edges) -> [Point] {
        let scale_fn = SVGConverter().make_canvas_dimension_converter(from: src_edges, to: dest_edges)
        let bezierPointsInstance = bezierPoints()
        return bezierPointsInstance.get_points(from: target, scale: scale_fn)
    }

    
    func full_matcher(source:[[Point]], target:[[Point]]) {
                
    }
}
