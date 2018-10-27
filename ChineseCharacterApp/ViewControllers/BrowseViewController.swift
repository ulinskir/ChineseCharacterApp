//
//  BrowseViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/16/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var browseCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var saveButton: UIButton!
    
    
    var searching = false
    var Chars = [ChineseChar]()
    var searchTerm = [ChineseChar]()
    var module = Module()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.browseCollectionView.delegate = self
        self.browseCollectionView.dataSource = self
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
        
        print("LOADED")
        print(Chars.count)
        print("HELLO")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath) as! UICollectionViewCell
        
        var usingData = searching ? searchTerm : Chars
        
        var Charlabel = cell.viewWithTag(1) as! UILabel
        var Deflabel = cell.viewWithTag(2) as! UILabel
        
        if module.chineseChars.contains(where: {$0.char == usingData[indexPath.row].char}){
            cell.backgroundColor = UIColor.white
            Charlabel.textColor = UIColor.black
            Deflabel.textColor = UIColor.black
             
            module.chineseChars.removeAll(where: {$0.char == usingData[indexPath.row].char})
        }else{
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
    
     func numberOfSections(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searching ? searchTerm.count : Chars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as UICollectionViewCell
        
        var Charlabel = cell.viewWithTag(1) as! UILabel
        var Deflabel = cell.viewWithTag(2) as! UILabel
        
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("DUH")
    }
}

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

