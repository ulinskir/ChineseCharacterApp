//
//  CharacterDetailsViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/16/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit
import CoreData

class CharacterDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //@IBOutlet weak var chineseCharLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var charDisplayLabel: UILabel!
    
    var currModule:Module? = nil
    var currChar:ChineseChar? = nil
    var imageView = UIImageView(image: UIImage(named: "hintPoint"))    // used to diplay hint dots

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chineseCharLabel.text = currChar?.char
        englishLabel.text = currChar?.definition
        pinyinLabel.text = currChar!.pinyin.count > 0 ? currChar?.pinyin[0] : "none"
        charDisplayLabel.text = currChar?.char
        strokeComparisonCollectionView.delegate = self
        strokeComparisonCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        charDisplayLabel.font = charDisplayLabel.font.withSize(charDisplayLabel.frame.size.height)
    }
    
    // If going back to the module details view, send the current module
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? ModuleDetailsViewController {
            destination.module = currModule
        }
    }
    
    
    //------------------------------ FUNCTIONS FOR STROKE COLLECTION VIEW -----------------------------//
    
    // for each stroke the user drew, create a box in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let points = ls!.currentPoints else {
            return ls!.getCurrentChar()!.strokes.count
        }
        return max(points.count,  ls!.getCurrentChar()!.strokes.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.height
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // Set up the collection view cell at indexpath to show the correct stroke
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "strokeCell", for: indexPath) as! StrokeCollectionViewCell
        // Check to make sure there is a char
        guard let char = ls!.getCurrentChar() else {
            return cell
        }
        
        guard ls!.currentPoints != nil else {
            return cell
        }
        
        let rowNumber : Int = indexPath.row
        let scaleFactor = cell.frame.width/masterDrawingView.frame.width
        drawStroke(shapeView: cell.strokeShapeView, rowNumber, withCorrect: true, highlighted: true, scaleFactor: scaleFactor)
        var i = 0
        while i < rowNumber {
            drawStroke(shapeView: cell.strokeShapeView, i, scaleFactor: scaleFactor)
            i += 1
        }
        
        cell.strokeView.layer.borderWidth = 1
        cell.strokeView.layer.borderColor = UIColor.black.cgColor
        
        cell.strokeLabel.font = cell.strokeLabel.font.withSize(cell.frame.height*0.9)
        cell.strokeLabel.text = String(char.char)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.imageView.isDescendant(of: masterDrawingView) {
            self.imageView.removeFromSuperview()
        }
        displayCharInView()
        displayGrid()
        textFeedbackStack.isHidden = true
        let rowNumber = indexPath.row
        guard let char = ls!.getCurrentChar()
            else {
                return
        }
        drawingView.clearCanvas()
        drawStroke(shapeView: drawingView, rowNumber, withCorrect: true, highlighted: true)
        var i = 0
        while i < rowNumber {
            drawStroke(shapeView: drawingView, i)
            i += 1
        }
        // Draw correct start point
        if rowNumber < char.strokes.count {
            let dim = self.drawingView.frame.width
            let matcher = Matcher()
            let points = matcher.get_hints(char.strokes, destDimensions: (north: 0, south: Double(dim), east: 0, west: Double(dim)))[rowNumber]
            self.drawPointOnCanvas(x: Double(points.x), y:  Double(points.y), view: masterDrawingView, point: imageView)
        }
        
    }
    
    func drawStroke(shapeView: ShapeView, _ num: Int, withCorrect: Bool = false, highlighted: Bool = false, scaleFactor: CGFloat = 1) {
        let char = ls!.getCurrentChar()!
        if withCorrect && num < char.strokes.count {
            let dim = shapeView.frame.width
            let lineWidth = CGFloat(dim/14 - 10)
            print("drawing correct stroke " + String(num))
            shapeView.drawChar(stroke:char.strokes[num], scale: SVGConverter().make_canvas_dimension_converter(from: (0,500,500,0), to: (0,Double(dim),Double(dim),0)), width: lineWidth )
        }
        var color = UIColor.black
        if highlighted {
            color = UIColor(red:0.54, green:0.07, blue:0.00, alpha:1.0)
        }
        let currPoints:[[Point]] = ls!.currentPoints!
        let sourceGfx = currPoints.map({(points:[Point]) -> [CGPoint] in return all_to_cg(stroke: points)})
        if num < sourceGfx.count  {
            print("drawing user stroke " + String(num))
            shapeView.drawUserStroke(stroke: sourceGfx[num], color: color, scaleFactor: scaleFactor)
        }
    }

}


