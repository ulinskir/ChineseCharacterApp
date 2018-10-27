//
//  ViewController.swift
//  Canvas
//
//  Created by Thomas (Tom) Parker on 9/22/18.
//  Copyright © 2018 Tom Parker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CView!
//    
    @IBOutlet weak var char: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func clearCanvas(_ sender: Any) {
        canvasView.clearCanvas()
    }
//
//    @IBAction func switchChar(_ sender: Any) {
//        char.image = UIImage(named: "fire")
//        canvasView.clearCanvas()
//    }
//
//    @IBAction func Switch_water(_ sender: Any) {
//        char.image = UIImage(named:"kanji_mizu_water")
//        canvasView.clearCanvas()
//    }
    
    var fire = false
    @IBAction func switchChar(_ sender: Any) {
        char.image = UIImage(named: fire ? "kanji_mizu_water" : "fire")
        fire = !fire
        canvasView.clearCanvas()
        
    }
    var source:[(Int,Int)] = []
    var target:[(Int,Int)] = []

//    @IBAction func Recognize(_ sender: Any) {
//        let instanceOfRecognizer = Recognizer()
//        let result = instanceOfRecognizer.recognize(source: [(2,5),(9,6),(15,5)], target:[(2,5),(15,5)], offset: 0)
//        print(result.score)
//        if(result.warning != nil){
//            print("warnings:",result.warning!)
//        }
//        if(result.penalties != nil){
//            print("penalties:",result.penalties!)
//        }
//        
//    }
    
}

