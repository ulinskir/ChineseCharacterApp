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
    
    
    var searching = false
    var Chars = [ChineseChar]()
    var searchTerm = [ChineseChar]()
    var module = Module()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set self as the delegate and datasource of browseCollectionView, so that it
        // can manage the data displays and interactions with it
        self.browseCollectionView.delegate = self
        self.browseCollectionView.dataSource = self
        
        // If going back to the draw character view, send the current module
        
        // Load all the characters to display to Chars
        //Open the dictionary file
        
        guard let Dictpath = Bundle.main.path(forResource: "full_with_defs", ofType: "json") else {return}
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
                guard let strokes = charDict["strokes"] as? [String] else {print("Missing strokes"); return}
                guard let pinyin = charDict["pinyin"] as? [String] else {print("Missing Pinyin"); return}
                guard let decomposition = charDict["decomposition"] as? String else {print("Missing Decomposition"); return}
                guard let radical = charDict["radical"] as? String else {print("Missing Radical"); return}
                
                
                let curChar = ChineseChar(character: hanzi, strks: strokes, def: definition, pin: pinyin, decomp: decomposition, rad: radical)
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
        }else{
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
        var modName = "ModuleTest4"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let newMod = NSEntityDescription.insertNewObject(forEntityName: "ModuleContent", into: context)
        newMod.setValue(modName, forKey: "name")
        var charsSet = newMod.mutableSetValue(forKey: "chars")
        
        for ch in module.chineseChars{
            if charExists(char: ch.char) == false
            {
                print("add CHAR to DB")
                let newChar = NSEntityDescription.insertNewObject(forEntityName: "Char", into: context)
                newChar.setValue(ch.char, forKey: "char")
                newChar.setValue(ch.definition, forKey: "definition")
                newChar.setValue(ch.decomposition, forKey:"decomposition")
                newChar.setValue(0, forKey: "learned")
                newChar.setValue(ch.radical, forKey: "radical")
            }
            
            do{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Char")
                fetchRequest.predicate = NSPredicate(format: "char = %@", ch.char)
                let charInDB = try context.fetch(fetchRequest) as! [Char]
                if charInDB.count > 1{
                    print("WHOOPS - TOO MANY")
                }
                else{
                    charsSet.add(charInDB[0])
                }
            }catch{
                print("FAIL")
            }
            
        }
        
        do{
            try context.save()
            print("SAVED")
        }
        catch{
            print("FAIL")
        }
    }
    
    @IBAction func PracticeSelectedPressed(_ sender: UIButton) {
        
    }
}

// Implements the search bar 
extension BrowseViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("TYPING")
        if searchText == ""{
            searching = false
        }else{
            searchTerm = Chars.filter({$0.definition.lowercased().contains(searchText.lowercased())})
            searching = true
        }
        self.browseCollectionView.reloadData()
    }
}

func charExists(char: String) -> Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Char")
    fetchRequest.includesSubentities = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    var entitiesCount = 0
    
    do {
        entitiesCount = try context.count(for: fetchRequest)
    }
    catch {
        print("error executing fetch request: \(error)")
    }
    
    return entitiesCount > 0
}
