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
    
}

