//
//  ModuleDetailsViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/3/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class ModuleDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //top bar items
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topBarLabel: UILabel!
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    //Labels
    @IBOutlet weak var moduleNameLabel: UILabel!
    
    //Table to display characters
    @IBOutlet weak var moduleCharactersTableView: UITableView!
    let cellReuseIdentifier = "charCell"

    
    var module:Module? = nil
    //let module = Module(name:"test", chineseChars:[ChineseChar(chinese: "a", pinyin: "men", english: "door")])
    var selectedChar:ChineseChar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.moduleCharactersTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        //moduleCharactersTableView.delegate = self
        //moduleCharactersTableView.dataSource = self
        
        //let door = ChineseChar(chinese: "a", pinyin: "men", english: "door")

        //module = Module(name:"test", chineseChars:[door])
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let chars = self.module?.chineseChars {
           return chars.count
        }
        print(module?.chineseChars)
        print(module?.chineseChars.count)
        return 0    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("is called")
        // Create a new cell with the reuse identifier of our prototype cell
        // as our custom table cell class
        let cell = tableView.dequeueReusableCell(withIdentifier:"charCell") as! CharacterInModuleTableViewCell
        
        // Set the text label to the module name
        cell.chineseCharLabel.text = module?.chineseChars[indexPath.row].chinese
        cell.englishLabel.text = module?.chineseChars[indexPath.row].english
        cell.pinyinLabel.text = module?.chineseChars[indexPath.row].pinyin
        cell.clipsToBounds = true
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChar = module?.chineseChars[indexPath.row]
        print("You tapped cell number \(indexPath.row).")
        
    }

}
