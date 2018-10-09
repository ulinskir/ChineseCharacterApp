//
//  ModulesViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class ModulesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //data
    var modules: [Module] = []
    
    //Top bar objects
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var modulesTitleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    //table of modules
    @IBOutlet weak var modulesTableView: UITableView!
    
    
    //bottom bar items - module management
    @IBOutlet weak var addModuleButton: UIButton!
    @IBOutlet weak var deleteModuleButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load modules from data???
        // These tasks can also be done in IB if you prefer.
        self.modulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        modulesTableView.delegate = self
        modulesTableView.dataSource = self
        
        let mod = ["names", "colors", "numbers", "food", "family", "emotions", "sports", "weather", "interests", "school", "shopping", "travel", "places"]
        
        for i in mod {
            modules.append(Module(name:"\(i)", chineseChars:[]))
        }

    }

    
//----------------------Table Controller functions-------------------------------
    let cellSpacingHeight: CGFloat = 40
    
    
    
    let cellReuseIdentifier = "cell"
    
    
    //Add a section for each module in modules
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modules.count
    }
    
    //Each section contains 1 row --> the module
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //add space between modules
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
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
        cell.moduleNameLabel.text = modules[indexPath.section].name
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.section).")
    }

//----------------------module management functions------------------------------
    
    @IBAction func unwindToModulesList(sender: UIStoryboardSegue) {
        // Capture the new or updated module from the ModuleDetailViewController and save it to the modules property
    }
    
    
    func saveModules() {
        // Save the meals model data to the disk
   
    }
    
    func loadModules() {
        // Load modules data from the disk and assign it to the modules property
    }

} // end ModulesViewController class
