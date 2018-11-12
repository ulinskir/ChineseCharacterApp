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
    @IBOutlet weak var Recognizer: Recognizer!
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
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        return
//        let char_data =  ["M 249 651 Q 277 675 354 752 Q 369 770 390 783 Q 408 796 395 810 Q 380 823 354 833 Q 329 842 318 838 Q 306 834 313 822 Q 320 800 239 663 Q 238 662 236 658 C 221 632 226 631 249 651 Z","M 225 313 Q 238 376 244 408 L 247 431 Q 251 473 253 513 L 255 540 Q 258 604 261 613 C 265 640 265 640 257 645 Q 253 649 249 651 L 236 658 Q 199 676 187 670 Q 177 663 183 651 Q 202 627 203 562 Q 203 394 173 283 Q 146 199 81 77 Q 77 70 75 65 Q 74 55 83 57 Q 114 64 178 181 Q 187 202 198 226 Q 208 256 218 288 L 225 313 Z","M 376 431 Q 391 409 405 402 Q 415 395 428 414 Q 441 439 470 580 Q 477 608 497 630 Q 507 640 497 653 Q 484 668 446 689 Q 437 692 285 655 Q 270 651 257 645 C 229 634 235 599 261 613 Q 271 625 391 649 Q 409 653 415 647 Q 428 632 425 616 Q 400 469 383 456 C 371 437 371 437 376 431 Z","M 253 513 Q 313 526 358 535 Q 377 539 369 550 Q 359 560 338 563 Q 311 566 255 540 C 228 527 224 507 253 513 Z","M 244 408 Q 248 408 256 409 Q 322 422 376 431 C 406 436 411 445 383 456 Q 377 459 369 460 Q 348 461 247 431 C 218 422 214 407 244 408 Z","M 218 288 Q 219 288 220 288 Q 238 276 266 285 Q 368 319 373 309 Q 382 296 376 260 Q 363 164 339 122 Q 323 97 301 101 Q 277 110 257 120 Q 236 129 250 107 Q 287 65 305 34 Q 321 15 339 30 Q 390 67 415 184 Q 430 289 447 308 Q 457 318 452 328 Q 445 338 399 357 Q 386 363 342 343 Q 284 328 225 313 C 196 306 190 298 218 288 Z"]
        
        
        
        
        //Recognize()
        //drawingView.clearCanvas()
//        switchChar()
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
//        let instanceOfRecognizer = Recognizer()
        let result = Recognizer.recognize(source: [(2,5),(10,6),(15,5)], target:[(2,5),(15,5)], offset: 0)
        print(result.score)
    }


}
