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
    
    @IBOutlet weak var browseButton: HomeViewButton!
    @IBOutlet weak var modulesButton: HomeViewButton!
    @IBOutlet weak var quickStartButton: HomeViewButton!
    @IBOutlet weak var settingsButton: HomeViewButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.Day.neutralGray
        titleLabel.textColor = UIColor.Day.maroon
        titleLabel.font = UIFont(name: "Baskerville", size: 20)
        titleLabel!.adjustsFontSizeToFitWidth = true
    }
}
