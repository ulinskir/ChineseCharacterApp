//
//  ModuleDetailsViewController.swift
//  Called from the modulesview scene, this view displays the details of a module
//  including the following
//  -name
//  -a list of the characters in the module
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleNameLabel.text = (module != nil) ?  module!.name : ""
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let chars = self.module?.chineseChars {
           return chars.count
        }
        return 0    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a new cell with the reuse identifier of our prototype cell
        // as our custom table cell class
        let cell = tableView.dequeueReusableCell(withIdentifier:"charCell") as! CharacterInModuleTableViewCell
        
        // Set the text label to the module name
        cell.chineseCharLabel.text = module?.chineseChars[indexPath.row].char
        cell.englishLabel.text = module?.chineseChars[indexPath.row].definition
        cell.pinyinLabel.text = module?.chineseChars[indexPath.row].pinyin[0]
        cell.clipsToBounds = true
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedChar = module?.chineseChars[indexPath.row]
        
        print("You tapped cell number \(indexPath.section).")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? CharacterDetailsViewController {
            destination.currModule = module!
            let selectedrow = moduleCharactersTableView.indexPathForSelectedRow!.section
            destination.currChar = module?.chineseChars[selectedrow]
        }
    }
}
