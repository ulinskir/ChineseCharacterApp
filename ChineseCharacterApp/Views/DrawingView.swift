//
//  DrawingView.swift
//  Canvas
//
//  Created by Thomas (Tom) Parker on 9/22/18.
//  Copyright © 2018 Tom Parker. All rights reserved.
//


import UIKit

class DrawingView: UIView {

    
    var lineColor:UIColor!
    var lineWidth:CGFloat!
    var path:UIBezierPath!
    var touchPoint:CGPoint!
    var startingPoint:CGPoint!
    var points:[[Point]]
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
        lineColor = UIColor.black
        lineWidth = 10
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startingPoint = touch?.location(in: self)
        path = UIBezierPath()
        path.move(to: startingPoint)
        points.append([])
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        
        path.addLine(to: touchPoint)
        points[-1].append((Double(touchPoint.x), Double(touchPoint.y)))
        startingPoint = touchPoint
        
        drawShapeLayer()
    }
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearCanvas() {
        if (path != nil) {
            path.removeAllPoints()
            self.layer.sublayers = nil
            self.setNeedsDisplay()
        }
        points = []
    }
    
    func getPoints() -> [[Point]] {
        return points
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
