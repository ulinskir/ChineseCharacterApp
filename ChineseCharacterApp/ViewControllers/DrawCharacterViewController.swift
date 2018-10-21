//
//  DrawCharacterViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class DrawCharacterViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        drawingView.clearCanvas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var fire = false
    @IBAction func switchChar(_ sender: Any) {
        //drawingView.char.image = UIImage(named: fire ? "kanji_mizu_water" : "fire")
        fire = !fire
        drawingView.clearCanvas()
    }
    @IBAction func Recognize(_ sender: Any) {
        //let instanceOfRecognizer = Recognizer()
        //let result = instanceOfRecognizer.recognize(source: [(2,5),(10,6),(15,5)], target:[(2,5),(15,5)], offset: 0)
        //print(result.score)
    }


}
