//
//  ProfileViewController.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/3/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userPropertiesTableView: UITableView!
    
    var user:User? = nil
    var image:String = "Monkey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User(fullName: "Tosa Rosa", password: "123", email: "BillyBob@hamilton.edu")
        
        userNameLabel.text = "Profile"
        
        userImage.image = UIImage(named: image + ".jpg")
        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.2
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a new cell with the reuse identifier of our prototype cell
        // as our custom table cell class
         let cell = tableView.dequeueReusableCell(withIdentifier:"profileCell") as! ProfileTableViewCell
        if indexPath.row == 0 {
            cell.profileFieldnameLabel.text = "Full Name:\t"
            cell.profileFieldvalueLabel.text = user?.fullName
        } else if indexPath.row == 1 {
            cell.profileFieldnameLabel.text = "email:\t"
            cell.profileFieldvalueLabel.text = user?.email
        }

        
        // Return our new cell for display
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("You tapped cell number \(indexPath.row).")
        // performSegue(withIdentifier: "moduleTapped", sender: self)
        //performSegue(withIdentifier:"moduleTapped", sender: self)
    }
    
}
