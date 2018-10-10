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
    
    var module:Module? = nil
    var selectedChar:ChineseChar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    let cellReuseIdentifier = "cell"
    
    
    //Add a section for each module in modules
    func numberOfSections(in tableView: UITableView) -> Int {
            if let chars = self.module?.chineseChars {
                return chars.count
            }
            return 0
    }
    
    //Each section contains 1 row --> the module
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a new cell with the reuse identifier of our prototype cell
        // as our custom table cell class
        let cell = tableView.dequeueReusableCell(withIdentifier:"modulesTableCell") as! ModulesTableViewCell
        // Set the text label to the module name
        //cell.moduleNameLabel.text = modules[indexPath.row].name
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
            selectedChar = module?.chineseChars[indexPath.row]
        
        
        print("You tapped cell number \(indexPath.row).")
        
        //performSegue(withIdentifier:"moduleTapped", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
