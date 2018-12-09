//
//  ShapeView.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 12/8/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class ShapeView: UIView {

    var lineColor:UIColor = .black
    var lineWidth:CGFloat = 10
    var path = UIBezierPath()
    

    override func layoutSubviews() {
        lineColor = UIColor.black
        lineWidth = 10
    }
    
    func drawUserStroke(stroke:[CGPoint], color: UIColor = .black, scaleFactor:CGFloat = 1){
        assert(stroke.count > 1, "single point 'stroke' passed to DrawUserStroke")
        var scaled: [CGPoint] = []
        for s in stroke {
            scaled.append(CGPoint(x: s.x * scaleFactor, y: s.y*scaleFactor))
        }
        path = UIBezierPath()
        path.move(to:scaled[0])
        for st in scaled[1...] {
            path.addLine(to:st)
        }
        drawShapeLayer(color: color, width: 10*scaleFactor - 10)
    }
    
    
    func drawChar(stroke:String, scale:@escaping (Point) -> Point, width: CGFloat = 0) {
        func scale2 (x:Point) -> Point {return x}
        path = UIBezierPath(svgPath: stroke, scale: scale)
        drawShapeLayer(color: .darkGray, width: width)
    }
    
    func drawShapeLayer(color: UIColor = .black, width: CGFloat = 0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth + width
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearCanvas() {
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }

}
