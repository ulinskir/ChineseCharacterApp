//
//  CreateModuleViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/9/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit
import CoreData


class CreateModuleViewController: UIViewController {

    @IBOutlet weak var newModuleName: UITextField!
    @IBOutlet weak var newModuleAuthor: UITextField!
    @IBOutlet weak var newModuleDescription: UITextView!
    
    var module: Module? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelCreateModuleButtonPressed(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title:"Cancel", message:"Are you sure you want to cancel?", preferredStyle: .actionSheet)
        let yesAction:UIAlertAction = UIAlertAction(title:"Yes", style: .destructive)
        { (_:UIAlertAction) in
            self.performSegue(withIdentifier: "CreateCancel", sender: self)
        }
        let noAction:UIAlertAction = UIAlertAction(title:"No", style: .cancel)
        { (_:UIAlertAction) in
            print("No")
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated:true)
    }
    
    func saveModule() {
        let modName = newModuleName.text
        if moduleNameExists(name: modName!) {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let newMod = NSEntityDescription.insertNewObject(forEntityName: "ModuleContent", into: context)
        newMod.setValue(modName, forKey: "name")
        var charsSet = newMod.mutableSetValue(forKey: "chars")
        
        for ch in module!.chineseChars{
            print(ch.char)
            if charExists(char: ch.char) == false
            {
                print("add CHAR to DB")
                let newChar = NSEntityDescription.insertNewObject(forEntityName: "Char", into: context)
                newChar.setValue(ch.char, forKey: "char")
                newChar.setValue(ch.definition, forKey: "definition")
                newChar.setValue(ch.decomposition, forKey:"decomposition")
                newChar.setValue(0, forKey: "learned")
                newChar.setValue(ch.radical, forKey: "radical")
                do{
                    print("Save")
                    try context.save()
                }
                catch{
                    print(error)
                }
            }
            
            do{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Char")
                fetchRequest.predicate = NSPredicate(format: "char = %@", ch.char)
                let charInDB = try context.fetch(fetchRequest) as! [Char]
                print("IN DB")
                print(charInDB.count)
                if charInDB.count > 1{
                    print("WHOOPS - TOO MANY")
                }
                else if charInDB.count > 0{
                    charsSet.add(charInDB[0])
                }
                else{
                    print("NONE")
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
    
    @IBAction func saveModuleButtonPressed(_ sender: Any) {
        if !moduleNameExists(name: newModuleName.text!) {
            saveModule()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ModulesViewController") as! ModulesViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        else {
            //do something
        }
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ModulesViewController {
            saveModule()
        }
    }*/
    
}

func moduleNameExists(name: String) -> Bool{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ModuleContent")
    fetchRequest.includesSubentities = false
    fetchRequest.predicate = NSPredicate(format: "name = %@", name)
    
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
