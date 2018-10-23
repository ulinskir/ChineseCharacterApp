//
//  ViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/22/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var Profilebutton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var browseButton: HomeViewButton!
    @IBOutlet weak var modulesButton: HomeViewButton!
    @IBOutlet weak var quickStartButton: HomeViewButton!
    @IBOutlet weak var settingsButton: HomeViewButton!
    
    let defaultProfiles = ["Zebra", "Monkey", "Giraffe", "Lion"]
    let randomNum = Int.random(in: 0 ... 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Profilebutton.setImage(UIImage(named: defaultProfiles[randomNum] + ".jpg"), for: .normal)
        Profilebutton.layer.cornerRadius = Profilebutton.bounds.size.width / 2
        Profilebutton.clipsToBounds = true
        Profilebutton.layer.borderWidth = 1
        Profilebutton.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? ProfileViewController {
            destination.image = defaultProfiles[randomNum]
        }
    }
}
