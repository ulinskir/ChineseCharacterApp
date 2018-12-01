//
//  BrowseViewController.swift
//  ChineseCharacterApp
//
// Displays a collection of all the characters in the app
// It can be filtered by definition through the search bar
// Selected characters on this page can be saved as a module or used to
// start a practice session.
//
//  Created by Risa Ulinski on 10/16/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import CoreData
import UIKit

class BrowseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var browseCollectionView: UICollectionView!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var practiceSelectedButton: UIButton!
    
    //Practice Level View
    @IBOutlet weak var practiceLevelView: UIView!
    
    //Practice Level buttons
    @IBOutlet weak var levelOne: UIButton!
    @IBOutlet weak var levelTwo: UIButton!
    @IBOutlet weak var levelThree: UIButton!
    
    //default level is 1
    var level = 1
    
    var searching = false
    var Chars = [ChineseChar]()
    var searchTerm = [ChineseChar]()
    var module = Module()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        practiceSelectedButton.isEnabled = false
        saveButton.isEnabled = false
        // Set self as the delegate and datasource of browseCollectionView, so that it
        // can manage the data displays and interactions with it
        self.browseCollectionView.delegate = self
        self.browseCollectionView.dataSource = self
        
        // Load all the characters to display to Chars
        loadCharsFromJSON()
        
        practiceLevelView.isHidden = true
    
        self.searchBar.endEditing(true);
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func practiceLevelPopup(_ sender: Any) {
        practiceLevelView.isHidden = false
    }
    
    @IBAction func levelOneClicked(_ sender: Any) {
        level = 1
        self.performSegue(withIdentifier: "ModuleDraw", sender: self)
    }

    @IBAction func levelTwoClicked(_ sender: Any) {
        level = 2
        self.performSegue(withIdentifier: "ModuleDraw", sender: self)
    }
    
    @IBAction func levelThreeClicked(_ sender: Any) {
        level = 3
        self.performSegue(withIdentifier: "ModuleDraw", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadCharsFromJSON() {
        //Open the dictionary file

        guard let Dictpath = Bundle.main.path(forResource: "dictionary", ofType: "json") else {return}
        let Dicturl = URL(fileURLWithPath: Dictpath)
        
        //Get the contents of the dictionary file into the Chars array as object...obj.strokes wil; be an empty list
        do {
            let data = try Data(contentsOf: Dicturl)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let array = json as? [Any] else {return}
            
            for char in array{
                guard let charDict = char as? [String: Any] else {return}
                guard let definition = charDict["definition"] as? String else {print("Missing Def"); return}
                guard let hanzi = charDict["character"] as? String else {print("Missing Char"); return}
                guard let pts = charDict["points"] as? [[[Int]]] else {print("Missing Points"); return}
                guard let pinyin = charDict["pinyin"] as? [String] else {print("Missing Pinyin"); return}
                guard let decomposition = charDict["decomposition"] as? String else {print("Missing Decomposition"); return}
                guard let radical = charDict["radical"] as? String else {print("Missing Radical"); return}
                guard let strokes = charDict["strokes"] as? [String] else {print("Missing Strokes"); return}
                
                
                print("GOT PTS")
                let curChar = ChineseChar(character: hanzi, pts: pts, def: definition, pin: pinyin, decomp: decomposition, rad: radical, strks: strokes)
                Chars.append(curChar)
            }
            
            
        }
        catch{
            print(error)
        }
    }
    
    //Transition to draw character view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? DrawCharacterViewController {
            destination.module = module
            destination.level = level
        }
        if let destination = segue.destination as? CreateModuleViewController {
            destination.module = module
        }
    }

    // When a cell in the collection is selected, if it is not already selected
    // highlight it and add it to the selected characters list; if it is selected
    // unhighlight it and remove it from the list
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get the selected cell
        var cell = collectionView.cellForItem(at: indexPath) as! UICollectionViewCell
        
        //determine which dataSource to use
        var usingData = searching ? searchTerm : Chars
        
        //get access to the character's labels to use for highlighting
        let Charlabel = cell.viewWithTag(1) as! UILabel
        let Deflabel = cell.viewWithTag(2) as! UILabel
        
        //If character is already selected, deselected it; else, select it
        if module.chineseChars.contains(where: {$0.char == usingData[indexPath.row].char}){
            cell.backgroundColor = UIColor.white
            Charlabel.textColor = UIColor.black
            Deflabel.textColor = UIColor.black
             
            module.chineseChars.removeAll(where: {$0.char == usingData[indexPath.row].char})
        } else {
            cell.backgroundColor = UIColor(red:0.54, green:0.07, blue:0.00, alpha:1.0)
            Charlabel.textColor = UIColor.white
            Deflabel.textColor = UIColor.white
            
            module.chineseChars.append(usingData[indexPath.row])
        }
        
        print("MODULE: [")
        for ch in module.chineseChars{
            print(ch.char + " : " + ch.definition)
        }
        print("]")
        
        if module.chineseChars.count > 0 {
            saveButton.isEnabled = true
            practiceSelectedButton.isEnabled = true
            saveButton.backgroundColor = UIColor.groupTableViewBackground
            saveButton.setTitleColor(UIColor(red:0.54, green:0.07, blue:0.00, alpha:1.0), for: .normal)
            practiceSelectedButton.backgroundColor = UIColor.groupTableViewBackground
            practiceSelectedButton.setTitleColor(UIColor(red:0.54, green:0.07, blue:0.00, alpha:1.0), for: .normal)
        } else {
            saveButton.isEnabled = false
            practiceSelectedButton.isEnabled = false
            saveButton.backgroundColor = UIColor.darkGray
            saveButton.setTitleColor(UIColor.black, for: .disabled)
            practiceSelectedButton.backgroundColor = UIColor.darkGray
            practiceSelectedButton.setTitleColor(UIColor.black, for: .disabled)
        }
    }
    
    // there is only 1 section in our collection
    func numberOfSections(in: UICollectionView) -> Int {
        return 1
    }
    
    //The number of rows to display in the collection: either all characters if there is no search term
    // or the characters in the filtered list.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searching ? searchTerm.count : Chars.count
    }
    
    // format an appearing character's cell in the colleciton appropriately based on whether it is selected or not
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as UICollectionViewCell
        
        let Charlabel = cell.viewWithTag(1) as! UILabel
        let Deflabel = cell.viewWithTag(2) as! UILabel
        
        var usingData = searching ? searchTerm : Chars
        
        if module.chineseChars.contains(where: {$0.char == usingData[indexPath.row].char}){
            cell.backgroundColor = UIColor(red:0.54, green:0.07, blue:0.00, alpha:1.0)
            Charlabel.textColor = UIColor.white
            Deflabel.textColor = UIColor.white
        } else{
            cell.backgroundColor = UIColor.white
            Charlabel.textColor = UIColor.black
            Deflabel.textColor = UIColor.black
        }
        
        
        Deflabel.text = usingData[indexPath.row].definition
        Charlabel.text = usingData[indexPath.row].char
        return cell
    }
    
    // Send the selected characters to the save module screen to be saved as a module
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
}

// Implements the search bar 
extension BrowseViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("TYPING")
        if searchText == "" || searchBar.text == nil {
            searching = false
        } else{
            searchTerm = Chars.filter({$0.definition.lowercased().contains(searchText.lowercased())})
            searching = true
        }
        
        if searchBar.text == nil || searchBar.text == ""
        {
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
        self.browseCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

func charExists(char: String) -> Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Char")
    fetchRequest.includesSubentities = false
    fetchRequest.predicate = NSPredicate(format: "char = %@", char)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    var entitiesCount = 0
    
    do {
        entitiesCount = try context.count(for: fetchRequest)
    }
    catch {
        print("error executing fetch request: \(error)")
    }
    
    print("ENTITIES:")
    print(entitiesCount)
    return entitiesCount > 0
}
