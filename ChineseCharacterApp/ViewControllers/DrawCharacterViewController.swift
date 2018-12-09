//
//  DrawCharacterViewController.swift
//  ChineseCharacterApp
//
//  Takes a module (and level?) to create a learning session which allows
//  the user to draw each character in the module.
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit


class DrawCharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    @IBOutlet weak var startButton: UIButton! //tapped to start the learning session

    //top bar items
    @IBOutlet weak var progressBar: UIProgressView! //progress bar to display progress in the current learning session
    @IBOutlet weak var exitButton: UIButton! //button to exit current learning session
    
    // Character drawing screen
    @IBOutlet weak var masterDrawingView: UIView!
    @IBOutlet weak var drawingView: DrawingView! // a canvas to draw characters on
    @IBOutlet weak var backgroundCharLabel: UILabel! // for level 0 to display the curr char
    
    // Controls for the user
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    //Display current character information
    @IBOutlet weak var topView1: UIStackView! //view for levels 1 and 2
    @IBOutlet weak var topView2: UIStackView! //view for levels 0 and 3
    
    //top view 1
    @IBOutlet weak var chineseCharTop1: UILabel!
    @IBOutlet weak var englishTop1: UILabel!
    @IBOutlet weak var pinyinTop1: UILabel!
    
    //top view 2
    @IBOutlet weak var englishTop2: UILabel!
    @IBOutlet weak var pinyinTop2: UILabel!
    
    var module:Module? = nil        // the module being practiced, if applicable
    var ls:LearningSesion? = nil    // a learning session to track the current character and progress
    var level = 1                   // The level to practice on, defaults to 1
    
    var imageView = UIImageView(image: UIImage(named: "hintPoint"))    // used to diplay hint dots
    var imageViewBlack = UIImageView(image: UIImage(named: "hintPointBlack"))
    
    @IBOutlet weak var checkViewPopup: UIView!  // a popup window that allows the usesr to navigate
                                                // their results on a character
    @IBOutlet weak var textFeedbackStack: UIStackView!
    @IBOutlet weak var resultFeedbackLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    
    
    @IBOutlet weak var continueCheckViewButton: UIButton!
    @IBOutlet weak var strokeComparisonCollectionView: UICollectionView! // displays stroke by stroke results for the user to click through
    
    
    // When the user taps the start button, load the first character and hide the start button
    @IBAction func startLesson(_ sender: Any) {
        setupCharDisplay()
        startButton.isHidden = true
    }
    
 //------------------------------ USER DRAWING INTERACTION BUTTONS -----------------------------//
    
    // When hint button is tapped, display a dot on the drawingView corresponding to the
    // start of the next stroke to be drawn
    // NOTE: It is only guarenteed to be the correct next stroke if the user hasn't drawn strokes
    //       out of order.
    //       Hint is only enabled on levels 1 and 2
    @IBAction func hintButtonTapped(_ sender: Any) {
        guard let char = ls!.getCurrentChar() else {
            // make sure there is a current character in the learning session
            return
        }
        if drawingView.strokes.count < char.strokes.count {
            // if there are still strokes to draw, display the hint
            // first scale the start point from a 295 pt view to the current view size
            
            //let scaleFactor =  Double(self.drawingView.frame.width/295)
            //let points = char.points[drawingView.strokes.count][0]
            let matcher = Matcher()
            let dim = Double(self.drawingView.frame.width)
            let points = matcher.get_hints(char.strokes, destDimensions: (north: 0, south: dim, east: 0, west: dim))[drawingView.strokes.count]
            // then draw it on the screen
            self.drawPointOnCanvas(x: Double(points.x), y:  Double(points.y), view: masterDrawingView, point: imageView)
            //self.drawPointOnCanvas(x: Double(points[0]) * scaleFactor, y:  Double(points[1]) * scaleFactor, view: masterDrawingView, point: imageView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // after 2 seconds remove it
                self.imageView.removeFromSuperview()
            }
        }
    }
    
    // When clear is tapped, clear the screen of any user drawn lines
    @IBAction func undoButtonTapped(_ sender: Any) {
        drawingView.clearCanvas()
    }
    func all_to_cg (stroke:[Point]) -> [CGPoint] {
        return stroke.map({(z:Point) -> CGPoint in return CGPoint(x:CGFloat(z.x),y:CGFloat(z.y))})
    }
    
    // When the character has been submitted by the user,
    //  - send the matcher the screen dimensions and use it to check the user's char against the
    //    correct char
    //  - load the check char popup
    @IBAction func submitButtonTapped(_ sender: Any) {
        /*let testing_resampler = true
        
        // Set up and run the matcher
        let dim = Double(self.drawingView.frame.width) // get the size of the drawing view
        let currScreenDimensions: Edges = (0,dim,dim,0) // send it to the matcher
        
        let matcher = Matcher()
        let targetSvgs = ls!.getCurrentChar()!.strokes
        let targetStrokePoints = matcher.processTargetPoints(targetSvgs, destDimensions:currScreenDimensions)
        //insert target here?????
        let source = drawingView.getPoints()
        if(testing_resampler) {
            for src in source {
            let resampler = Resampler()
            let resampled_tester = resampler.resamplePoints(src,totalPoints: 64)
            }
        }
        var errorLevel = 0
        
        
 
        // save the result to the learning session
        typealias matcherResult = (targetScores: [StrokeResult], Errors: [Int])
        let res:matcherResult = matcher.full_matcher(src:source, target:targetStrokePoints)
        ls!.currentResult = res.targetScores
        
        if(source.count != targetSvgs.count) {
            errorLevel = 5
        } else {
            errorLevel = matcher.get_level(results: res.targetScores)
        }
        print("error level", errorLevel)
 */
        ls!.currentPoints = drawingView.getPoints()
        // Set up and load the check character popup
        checkUserChar()
    }
    
//------------------------------ USER CHECKING INTERACTION BUTTONS -----------------------------//

    //TO DO: Determine metric for correctness of user's char
    func isCharRight() -> Bool {
        return true
    }
    
    // miss-named, actually continue button tapped
    // If char is right save results to learning session and move to the next character
    // else insert char at the end of the learning sessions list of characters to be precticed
    // and move to the next char
    @IBAction func noButtonTapped(_ sender: UIButton) {
        if isCharRight() {
            ls!.charPracticed(score: 1)
            progressBar.setProgress(Float(ls!.progress()), animated: true)
        } else {
            let failedChar = ls!.charsToPractice.remove(at: ls!.current)
            ls!.charsToPractice.insert(failedChar, at: ls!.charsToPractice.endIndex)
        }
        loadNextChar()
        checkViewPopup.isHidden = true
        textFeedbackStack.isHidden = true
    }
    
    
//------------------------------ APP LIFECYCLE METHODS -----------------------------//

    override func viewDidLoad() {
        super.viewDidLoad()
        ls = LearningSesion(charsToPractice: module!.chineseChars,level: level)
        ls!.charsToPractice.shuffle()
        topView1.isHidden = true
        topView2.isHidden = true
        checkViewPopup.isHidden = true
        textFeedbackStack.isHidden = true
        strokeComparisonCollectionView.delegate = self
        strokeComparisonCollectionView.dataSource = self
    }
    
    // Once the view is loaded and views have the correct dimensions, set the font sizes appropiately
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFontSizes()
        displayGrid()
    }
    
    
//------------------------------ FUNCTIONS FOR SETTING UP DISPLAYS -----------------------------//
    
    // If there is another character in the learning session load it
    // else move to the lesson finished screen
    func loadNextChar() {
        drawingView.clearCanvas()   // remove any user drawing from the drawing view
        if !ls!.sessionFinished() {
            setupCharDisplay()
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    // Sets up the check user char popup
    func checkUserChar() {
        if ls!.current + 1 == ls!.charsToPractice.count {
            continueCheckViewButton.setTitle("Done", for: .normal)
        } else {
            continueCheckViewButton.setTitle("Continue", for: .normal)
        }
        //disable drawing on canvas
        drawingView.enableUserDrawing = false
        masterDrawingView.backgroundColor = .white
        hideCharInView()
        drawingView.clearCanvas()
        checkViewPopup.isHidden = false
        textFeedbackStack.isHidden = false
        strokeComparisonCollectionView.reloadData()
        
    }
    
    // Draws a red bullseye with size 1/16th of the drawing view at a given point
    func drawPointOnCanvas(x:Double,y:Double,view:UIView, point: UIImageView) {
        let pointRadius = Double(view.frame.height / 16)
        point.frame = CGRect(x: x - pointRadius/2, y: y - pointRadius/2, width: (pointRadius), height: (pointRadius))
        view.addSubview(imageView)
    }
    
    // If there is a character to practice in the learning session display it appropiately for the given level
    func setupCharDisplay() {
       guard let char = ls!.getCurrentChar() else {
            // if there is no char do nothing
            return
        }
        // allow the user to draw on the canvas
        displayGrid()
        drawingView.enableUserDrawing = true
        // if there is still a hint dot displayed, remove it
        if self.imageView.isDescendant(of: masterDrawingView) {
            self.imageView.removeFromSuperview()
        }
        
        // initialize the stroke comparision view with the new strokes
        strokeComparisonCollectionView.reloadData()
        
        // Set up the view with the new char based on the level
        switch ls!.level {
        case 1:
            // if level is 1, display entire character in the background of the drawing view
            setLabelsInTop2(char: char)
            displayCharInView()
        case 2:
            hideCharInView()
            setLabelsInTop1(char: char)
        case 3:
            hideCharInView()
            setLabelsInTop2(char: char)
            hintButton.isEnabled = false
        default:
            // Default to level 1, display entire character in the background of the drawing view
            setLabelsInTop2(char: char)
            displayCharInView()
        }
    }
    
    // Set the labels in the top1 view-- the view that has the chinese in it
    func setLabelsInTop1(char:ChineseChar) {
        englishTop1.text = char.definition
        chineseCharTop1.text = char.char
        pinyinTop1.text = char.pinyin.count > 0 ? char.pinyin[0] : "none"
        showTop1()
    }
    
    // Set the labels in the top2 view-- the view that doen't have the chinese in it
    func setLabelsInTop2(char:ChineseChar) {
        englishTop2.text = char.definition
        pinyinTop2.text = char.pinyin.count > 0 ? char.pinyin[0] : "none"
        showTop2()
    }
    
    // Hide the background char
    func hideCharInView() {
        backgroundCharLabel.text = ""
    }
    
    // Show the char in drawing view
    func displayCharInView() {
        let char = ls!.getCurrentChar()
        backgroundCharLabel.text = char?.char
    }
    
    // Show the top1 and hide top2
    func showTop1() {
        topView1.isHidden = false
        topView2.isHidden = true
    }
    
    // Show the top2 and hide top1
    func showTop2() {
        topView1.isHidden = true
        topView2.isHidden = false
    }
    
    //Set the font sizes based on the view dimensions
    func setFontSizes() {
        backgroundCharLabel.font = backgroundCharLabel.font.withSize(drawingView.frame.size.height*0.9)
        chineseCharTop1.font = chineseCharTop1.font.withSize(topView1.frame.size.height * 0.7)
        englishTop1.fitTextToBounds()
        englishTop2.fitTextToBounds()
        englishTop2.font = englishTop2.font.withSize(englishTop2.frame.height * 0.8)
        pinyinTop2.font = pinyinTop2.font.withSize(pinyinTop2.frame.height * 0.7)
        pinyinTop1.font = pinyinTop1.font.withSize(pinyinTop1.frame.height * 0.6)
        englishTop1.font = englishTop1.font.withSize(englishTop1.frame.height * 0.6)
    }
    
    func displayGrid() {
        masterDrawingView.backgroundColor = UIColor(patternImage: UIImage(named: "chineseGrid.png")!)
        masterDrawingView.contentMode =  UIView.ContentMode.scaleAspectFill
        UIGraphicsBeginImageContext(masterDrawingView.frame.size);
        var image = UIImage(named: "chineseGrid")
        image?.draw(in: masterDrawingView.bounds)
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        masterDrawingView.backgroundColor = UIColor(patternImage: image!)
    }
    
    func hideGrid() {
        masterDrawingView.backgroundColor = .white
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
    
    // When exit button is tapped, display popup to make sure the user wants to
    // quit the current learning session
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        let alert:UIAlertController = UIAlertController(title:"", message:"Are you sure you want to quit? Your progress will not be saved.", preferredStyle: .alert)
        let yesAction:UIAlertAction = UIAlertAction(title:"Yes", style: .destructive)
        { (_:UIAlertAction) in
            self.performSegue(withIdentifier: "DrawHome", sender: self)
        }
        let noAction:UIAlertAction = UIAlertAction(title:"No", style: .cancel)
        { (_:UIAlertAction) in
            
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated:true)
    }
}
