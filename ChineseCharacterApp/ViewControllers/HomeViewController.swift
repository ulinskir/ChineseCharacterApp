//
//  ViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/22/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setBackgroundColor()
    }
}

extension UIViewController {
    func setBackgroundColor() {
        view.backgroundColor = UIColor.Day.neutralGray
        label.textColor = UIColor.Day.maroon
    }
}
