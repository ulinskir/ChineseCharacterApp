//
//  ViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/22/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var browseButton: HomeViewButton!
    @IBOutlet weak var modulesButton: HomeViewButton!
    @IBOutlet weak var quickStartButton: HomeViewButton!
    @IBOutlet weak var settingsButton: HomeViewButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
    }
}
