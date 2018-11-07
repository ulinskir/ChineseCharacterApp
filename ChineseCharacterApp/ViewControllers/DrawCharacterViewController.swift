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
    @IBOutlet weak var backgroundCharLabel: UILabel! // for level 0 to display the curr char
    
    // Controls for the drawing view
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBOutlet weak var topView1: UIStackView!
    @IBOutlet weak var topView2: UIStackView!
    
    //top view 1
    @IBOutlet weak var chineseCharTop1: UILabel!
    @IBOutlet weak var englishTop1: UILabel!
    @IBOutlet weak var pinyinTop1: UILabel!
    @IBOutlet weak var audioTop1: UIButton!
    
    //top view 2
    @IBOutlet weak var englishTop2: UILabel!
    @IBOutlet weak var pinyinTop2: UILabel!
    @IBOutlet weak var audioTop2: UIButton!
    
    var module:Module? = nil
    var ls:LearningSesion? = nil
    
    // When hint button is tapped, give the user the correct hint, based on their
    // level for the current character
    // TO DO: implement this
    @IBAction func hintButtonTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("time up")
        }
        
        switch ls!.level {
        case 0:
            // if level is 0,
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        default:
            print("undefined level")
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
    }
    
    func checkUserChar() {
        displayCharInView()
        ls!.charPracticed(score: 0)
        progressBar.setProgress(Float(ls!.progress()), animated: true)
        //submitButton.setTitle("Continue", for: [.normal])
        
        setSubmitButtonTitle(title: "Continue")
    }
    
    func loadNextChar() {
        drawingView.clearCanvas()
        if !ls!.sessionFinished() {
            setupCharDisplay()
            setSubmitButtonTitle(title: "Check")
            //submitButton.setTitle("Check", for: [.normal])
        } else {
            setSubmitButtonTitle(title: "Done")
            //submitButton.setTitle("Done", for: [.normal])
        }
    }
    
    func setSubmitButtonTitle(title:String) {
        submitButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]), for: [.normal])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ls = LearningSesion(charsToPractice: module!.chineseChars,level: 0)
        print(module!.chineseChars)
        englishTop1.lineBreakMode = .byWordWrapping 
        englishTop1.numberOfLines = 0
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFontSizes()
        setupCharDisplay()
    }
    
    func setupCharDisplay() {
       guard let char = ls!.getCurrentChar() else {
            print("no char")
            return
        }
        //let char = ChineseChar(character: "门", strks: [""], def: "Door", pin: ["Men"], decomp: "", rad: "")
        switch ls!.level {
        case 0:
            // if level is 0, display entire character in the background of the
            setLabelsInTop2(char: char)
            displayCharInView()
        case 1:
            hideCharInView()
            setLabelsInTop1(char: char)
            print("1")
        case 2:
            hideCharInView()
            setLabelsInTop1(char: char)
            print("2")
        case 3:
            hideCharInView()
            setLabelsInTop2(char: char)
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
        chineseCharTop1.font = chineseCharTop1.font.withSize(topView1.frame.size.height * 0.75)
        /*englishTop2.font = englishTop2.font.withSize(englishTop2.frame.height * 0.9)
        pinyinTop2.font = pinyinTop2.font.withSize(pinyinTop2.frame.height * 0.8)
        pinyinTop1.font = pinyinTop1.font.withSize(pinyinTop1.frame.height * 0.8)
        englishTop1.font = englishTop1.font.withSize(englishTop1.frame.height * 0.9)
        */
    }
    
    func Recognize() {
        let instanceOfRecognizer = Recognizer()
        let result = instanceOfRecognizer.recognize(source: [(2,5),(10,6),(15,5)], target:[(2,5),(15,5)], offset: 0)
        print(result.score)
    }


}
