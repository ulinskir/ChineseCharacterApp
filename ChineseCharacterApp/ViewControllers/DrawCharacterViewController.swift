//
//  DrawCharacterViewController.swift
//  ChineseCharacterApp
//
//  A
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class DrawCharacterViewController: UIViewController {

    //top bar items
    @IBOutlet weak var progressBar: UIProgressView! //progress bar to display progress in the current learning session
    @IBOutlet weak var exitButton: UIButton! //button to exit current learning session
    @IBOutlet weak var optionsButton: UIButton! //TO DO: figure out what this does
    
    // Character information
    @IBOutlet weak var audioButton: UIButton! // Stretch goal-> get audio for characters
    
    @IBOutlet weak var drawingView: DrawingView! // a canvas to draw characters on
    
    // Controls for the drawing view
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var progress = 0.0
    var questions = 25.0
    
    
    var backgroundChar: UIImage!
    
    // When hint button is tapped, give the user the correct hint, based on their
    // level for the current character
    // TO DO: implement this
    @IBAction func hintButtonTapped(_ sender: Any) {
        drawingView.backgroundColor = UIColor(patternImage: backgroundChar)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.drawingView.backgroundColor = UIColor.white
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
        let alert:UIAlertController = UIAlertController(title:"Cancel", message:"Are you sure you want to cancel?", preferredStyle: .actionSheet)
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
        //drawingView.clearCanvas()
        progress += 4
        progressBar.setProgress(Float(progress/questions), animated: true)
        switchChar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundChar = UIImage(named: fire ? "kanji_mizu_water" : "fire")
        // Do any additional setup after loading the view.
    }
    
    var fire = false
    func switchChar() {
        backgroundChar = UIImage(named: fire ? "kanji_mizu_water" : "fire")
        fire = !fire
        //drawingView.clearCanvas()
    }
    
    func Recognize() {
        let instanceOfRecognizer = Recognizer()
        let result = instanceOfRecognizer.recognize(source: [(2,5),(10,6),(15,5)], target:[(2,5),(15,5)], offset: 0)
        print(result.score)
    }


}
