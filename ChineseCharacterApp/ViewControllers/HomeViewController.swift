//
//  ViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/22/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var modulesButton: UIButton!
    @IBOutlet weak var quickStartButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.Day.neutralGray
        titleLabel.textColor = UIColor.Day.maroon
        browseButton.backgroundColor = UIColor.Day.carbonGray
        modulesButton.backgroundColor = UIColor.Day.carbonGray
        quickStartButton.backgroundColor = UIColor.Day.carbonGray
        settingsButton.backgroundColor = UIColor.Day.carbonGray
    }
}
