//
//  ModuleDetailsViewController.swift
//
//  Called from the modulesVie, this view displays the details of a module
//  including the following:
//    - name
//    - a list of the characters in the module.
// Also allows the user to begin a practice session for the characters
//  in the module: either learned, unlearned, or all.
//
//  ChineseCharacterApp
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
    
    //Start Practice Session Buttons
    @IBOutlet weak var learnNewCharactersButton: UIButton!
    @IBOutlet weak var reviewOldCharactersButton: UIButton!
    @IBOutlet weak var practiceAllCharactersButton: UIButton!
    
    //Table to display characters
    @IBOutlet weak var moduleCharactersTableView: UITableView!
    let cellReuseIdentifier = "charCell"
    
    //Other
    var module:Module? = nil //the module to display
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleNameLabel.text = (module != nil) ?  module!.name : ""
        
        //TO DO: if no characters are learned yet, disable reviewOldCharactersButton
        //TO DO: if all characters are learned, disable learnNewCharactersButton
        
    }
    
    //Create a row in the table view for each character in the module
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
        
        // Set the text labels to the chinese, english and pinyin respectively
        cell.chineseCharLabel.text = module?.chineseChars[indexPath.row].char
        cell.englishLabel.text = module?.chineseChars[indexPath.row].definition
        cell.pinyinLabel.text = module?.chineseChars[indexPath.row].pinyin.joined()
        //cell.pinyinLabel.text = "DON'T KNOW YET"
        cell.clipsToBounds = true
        
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.section).")
    }
    
    // If view transitions to the characterDetailsView (ie a table cell is selected),
    // get character from the selected row and send it to the new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? CharacterDetailsViewController {
            destination.currModule = module!
            let selectedrow = moduleCharactersTableView.indexPathForSelectedRow!.row
            destination.currChar = module?.chineseChars[selectedrow]
        }
        else if let destination = segue.destination as? DrawCharacterViewController {
            destination.module = module
        }
    }
}
