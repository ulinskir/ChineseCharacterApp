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

class DrawCharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
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
    var imageView: UIImageView!     // used to diplay hint dots
    
    
    @IBOutlet weak var checkViewPopup: UIView!  // a popup window that allows the usesr to navigate
                                                // their results on a character
    
    @IBOutlet weak var strokeComparisonCollectionView: UICollectionView! // displays stroke by stroke results for the user to click through
    
    
    /*
        When the user taps the start button, load the first character and hide the start button
     */
    @IBAction func startLesson(_ sender: Any) {
        setupCharDisplay()
        startButton.isHidden = true
    }
    
    
    // When hint button is tapped, give the user the correct hint, based on their
    // level for the current character
    // TO DO: implement this
    @IBAction func hintButtonTapped(_ sender: Any) {
        /*if(ls!.getCurrentChar() != nil) {
            let strokes = ["M 337 94 C 322 90 237 56 214 40", "M 339 141 C 324 137 244 105 221 89"]
//            let strokes = ls!.getCurrentChar()?.strokes
            for stroke in strokes {
                drawingView.drawChar(stroke:stroke, scale:SVGConverter().make_canvas_dimension_converter(from:(0,500,500,0), to:(0,335,335,0)))
            }
            
        }*/
        
        guard let char = ls!.getCurrentChar() else {
            print("no char")
            return
        }
        if drawingView.strokes.count < char.points.count {
            //self.drawPointOnCanvas(x: Double(self.drawingView.frame.width / 2), y:  Double(self.drawingView.frame.width / 2))
            let scaleFactor =  Double(self.drawingView.frame.width/295)
            let points = char.points[drawingView.strokes.count][0]
            self.drawPointOnCanvas(x: Double(points[0]) * scaleFactor, y:  Double(points[1]) * scaleFactor)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.imageView.removeFromSuperview()
                print("time up")
            }
        }
        else {
            print("all strokes finished")
        }
    }
    
    // When undo is tapped, clear the screen
    // TO DO: make this clear only the most recent stroke
    @IBAction func undoButtonTapped(_ sender: Any) {
        drawingView.clearCanvas()
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
            print("No")
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated:true)
    }
    
    // When the character has been submitted by the user, ???
    // TO DO: implement this
    @IBAction func submitButtonTapped(_ sender: Any) {
        //Recognize()
        // Edges: (north, south, east, west)
        if self.imageView.isDescendant(of: masterDrawingView) {
            self.imageView.removeFromSuperview()
        }
        let currScreenDimensions: Edges = (0,335,335,0)
        
        let matcher = Matcher()
        let targetSvgs = ls!.getCurrentChar()!.strokes
        let targetStrokePoints = matcher.processTargetPoints(targetSvgs, destDimensions:currScreenDimensions)
        //insert target here
        let source = drawingView.getPoints()
        let result = matcher.full_matcher(source:source, target:targetStrokePoints)
        print(result)
        if submitButton.titleLabel!.text == "Check" {
            print("hi")
            checkUserChar()
            ls!.level += 1
            if (ls!.level > 3) {
                ls!.level = 0
            }
        } else if submitButton.titleLabel!.text == "Continue"{
            loadNextChar()
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        checkUserChar()
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        let failedChar = ls!.charsToPractice.remove(at: ls!.current)
        ls!.charsToPractice.insert(failedChar, at: ls!.charsToPractice.endIndex)
        loadNextChar()
        checkViewPopup.isHidden = true
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        ls!.charPracticed(score: 1)
        progressBar.setProgress(Float(ls!.progress()), animated: true)
        loadNextChar()
        checkViewPopup.isHidden = true
    }
    
    
    func checkUserChar() {
        displayCharInView()
        checkViewPopup.isHidden = false
        //setSubmitButtonTitle(title: "Continue")
    }
    
    func loadNextChar() {
        drawingView.clearCanvas()
        if !ls!.sessionFinished() {
            setupCharDisplay()
            setSubmitButtonTitle(title: "Check")
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "lessonFinishedViewController") as! LessonFinishedViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func setSubmitButtonTitle(title:String) {
        submitButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.54, green:0.07, blue:0.00, alpha:1.0)]), for: [.normal])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ls = LearningSesion(charsToPractice: module!.chineseChars,level: level)
        topView1.isHidden = true
        topView2.isHidden = true
        checkViewPopup.isHidden = true
        strokeComparisonCollectionView.delegate = self
        strokeComparisonCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFontSizes()
    }
    
    func drawPointOnCanvas(x:Double,y:Double) {
        let pointRadius = Double(drawingView.frame.height / 16)
        let pointUIImage = UIImage(named: "hintPoint")
        imageView = UIImageView(image: pointUIImage)
        imageView!.frame = CGRect(x: x - pointRadius/2, y: y - pointRadius/2, width: (pointRadius), height: (pointRadius))
        masterDrawingView.addSubview(imageView)
 
    }
    
    func setupCharDisplay() {
       guard let char = ls!.getCurrentChar() else {
            print("no char")
            return
        }
        if self.imageView != nil && self.imageView.isDescendant(of: masterDrawingView) {
            self.imageView.removeFromSuperview()
        }
        strokeComparisonCollectionView.reloadData()
        switch ls!.level {
        case 1:
            // if level is 0, display entire character in the background of the
            setLabelsInTop2(char: char)
            displayCharInView()
        case 2:
            hideCharInView()
            setLabelsInTop1(char: char)
            print("0")
        case 0:
            hideCharInView()
            setLabelsInTop1(char: char)
            hintButton.isEnabled = false
            print("2")
        case 3:
            hideCharInView()
            setLabelsInTop2(char: char)
            hintButton.isEnabled = false
            print("3")
        default:
            print("error: undefined level")
        }
    }
    
    func setLabelsInTop1(char:ChineseChar) {
        englishTop1.text = char.definition
        chineseCharTop1.text = char.char
        pinyinTop1.text = char.pinyin.count > 0 ? char.pinyin[0] : "none"
        showTop1()
    }
    
    func setLabelsInTop2(char:ChineseChar) {
        englishTop2.text = char.definition
        pinyinTop2.text = char.pinyin.count > 0 ? char.pinyin[0] : "none"
        showTop2()
    }
    
    func hideCharInView() {
        backgroundCharLabel.text = ""
    }
    
    func displayCharInView() {
        let char = ls!.getCurrentChar()
        //var charChar = char?.char
        //charChar = "门"
        backgroundCharLabel.text = char?.char
    }
    
    func showTop1() {
        topView1.isHidden = false
        topView2.isHidden = true
    }
    
    func showTop2() {
        topView1.isHidden = true
        topView2.isHidden = false
    }
    
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
    
    func Recognize() {
        let instanceOfRecognizer = Recognizer()
        let result = instanceOfRecognizer.recognize(source: [(2,5),(10,6),(15,5)], target:[(2,5),(15,5)], offset: 0)
        print(result.score)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(ls!.getCurrentChar()!.points.count)
        return ls!.getCurrentChar()!.points.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "strokeCell", for: indexPath) as! StrokeCollectionViewCell
        guard let char = ls!.getCurrentChar() else {
            print("no char")
            return cell
        }
        let scaleFactor =  Double(cell.strokeView.frame.width/295)
        let rowNumber : Int = indexPath.row
        cell.strokeLabel.text = String(rowNumber)
        let points = char.points[rowNumber][0]
        let x = Double(points[0]) * scaleFactor
        let y = Double(points[1]) * scaleFactor
        let pointRadius = Double(cell.strokeView.frame.height / 16)
        let pointUIImage = UIImage(named: "hintPoint")
        let imageView = UIImageView(image: pointUIImage!)
        imageView.frame = CGRect(x: x - pointRadius/2, y: y - pointRadius/2, width: (pointRadius), height: (pointRadius))
        //imageView.frame = CGRect(x: x , y: y, width: (pointRadius), height: (pointRadius))
        cell.strokeView.addSubview(imageView)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.imageView.isDescendant(of: masterDrawingView) {
            self.imageView.removeFromSuperview()
        }
        let rowNumber = indexPath.row
        //backgroundCharLabel.text = String(rowNumber)
        guard let char = ls!.getCurrentChar()
            else {
                print("no char")
                return
        }
        let scaleFactor =  Double(self.drawingView.frame.width/295)
        let points = char.points[rowNumber][0]
        self.drawPointOnCanvas(x: Double(points[0]) * scaleFactor, y:  Double(points[1]) * scaleFactor)
            }
}
