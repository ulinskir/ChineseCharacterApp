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
    
    @IBAction func saveModuleButtonPressed(_ sender: Any) {
        
    }
    
}

func ModuleNameExists(name: String) -> Bool{
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
