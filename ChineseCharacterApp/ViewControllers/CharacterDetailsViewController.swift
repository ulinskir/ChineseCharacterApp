//
//  CharacterDetailsViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/16/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit
import CoreData

class CharacterDetailsViewController: UIViewController {

    //@IBOutlet weak var chineseCharLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var charDisplayLabel: UILabel!
    
    var currModule:Module? = nil
    var currChar:ChineseChar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chineseCharLabel.text = currChar?.char
        englishLabel.text = currChar?.definition
        pinyinLabel.text = currChar!.pinyin.count > 0 ? currChar?.pinyin[0] : "none"
        charDisplayLabel.text = currChar?.char
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        charDisplayLabel.font = charDisplayLabel.font.withSize(charDisplayLabel.frame.size.height)
    }
    
    // If going back to the module details view, send the current module
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? ModuleDetailsViewController {
            destination.module = currModule
        }
    }
    

}


