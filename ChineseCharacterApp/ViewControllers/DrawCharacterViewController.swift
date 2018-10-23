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
    var backgroundChar: UIImage!
    
    
    @IBAction func hintButtonTapped(_ sender: Any) {
        drawingView.backgroundColor = UIColor(patternImage: backgroundChar)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.drawingView.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        drawingView.clearCanvas()
    }
    
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
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        //Recognize()
        //drawingView.clearCanvas()
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
