//
//  ModulesViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 9/25/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit
import CoreData

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
    
    
    var selectedModule:Module? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load modules from data???
        // These tasks can also be done in IB if you prefer.
        self.modulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        modulesTableView.delegate = self
        modulesTableView.dataSource = self
        
        addModuleButton.layer.cornerRadius = addModuleButton.bounds.size.height / 2
        addModuleButton.clipsToBounds = true
        addModuleButton.layer.borderWidth = 1
        addModuleButton.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        //Commenting out fake Modules
        //let mod = ["names", "colors", "numbers", "food", "family", "emotions", "sports", "weather", "interests", "school", "shopping", "travel", "places"]
        //let door = ChineseChar(character: "a", strks: [""], def: "door", pin: ["pin"], decomp: "d-o-o-r", rad: "sure")
        
        //for i in mod {
        //    modules.append(Module(name:"\(i)", chineseChars:[door]))
        //}
        
        //Get the Database
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Get the JSON file
        guard let Dictpath = Bundle.main.path(forResource: "full_with_dots", ofType: "json") else {return}
        let Dicturl = URL(fileURLWithPath: Dictpath)
        
        //Get all of the Modules
        let moduleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ModuleContent")
        do {
            //Query the DB for the Modules
            let result = try context.fetch(moduleRequest)
            
            //For each Module
            for module in result as! [NSManagedObject] {
                
                //Get name and list of chars
                let modName = module.value(forKey: "name") as! String
                let chars = module.value(forKey: "chars") as! Set<Char>
                
                //set up a list of ChineseChars to create Module
                var curChars = [ChineseChar]()
                
                //for every char
                for char in chars{
                    do {
                        //Go through the JSON file
                        let data = try Data(contentsOf: Dicturl)
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        guard let array = json as? [Any] else {return}
                        
                        lookJson : for jsonLine in array{
                            guard let charDict = jsonLine as? [String: Any] else {return}
                            guard let hanzi = charDict["character"] as? String else {print("Missing Char"); return}
                            
                            //When we find the correct char in the JSON
                            if hanzi == char.char{
                                guard let pinyin = charDict["pinyin"] as? [String] else {print("Missing Pinyin"); return}
                                guard let points = charDict["points"] as? [[[Int]]] else {print("Missing points"); return}
                                //Get the extra info we need from the JSON and add the current char to the curChars array
                                curChars.append(ChineseChar(character: hanzi, pts: points, def: char.definition as! String, pin: pinyin, decomp: char.decomposition as! String, rad: char.radical as! String))
                                
                                //Stop looking through the JSON
                                break lookJson
                            }
                            
                            
                        }
                        
                        
                    }
                    catch{
                        print(error)
                    }
                    
                }
                
                //Create a new Module with correct name and chars
                modules.append(Module(name: modName, chineseChars: curChars))
            }
            
        } catch {
            print("Failed")
        }
    }
    
    @IBAction func deleteModule(_ sender: UIButton) {
        let alert:UIAlertController = UIAlertController(title:"Cancel", message:"Are you sure you want to delete this \(String(describing: selectedModule))?", preferredStyle: .actionSheet)
        let deleteAction:UIAlertAction = UIAlertAction(title:"Delete", style: .destructive)
        { (_:UIAlertAction) in
            print("Delete")
        }
        let cancelAction:UIAlertAction = UIAlertAction(title:"Cancel", style: .cancel)
        { (_:UIAlertAction) in
            print("Cancel")
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated:true)
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
        cell.clipsToBounds = true
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
         //selectedModule = modules[indexPath.section]


        print("You tapped cell number \(indexPath.section).")
       // performSegue(withIdentifier: "moduleTapped", sender: self)
        //performSegue(withIdentifier:"moduleTapped", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? ModuleDetailsViewController {
            let selectedRow = modulesTableView.indexPathForSelectedRow!.section
            destination.module = modules[selectedRow]
        }
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

