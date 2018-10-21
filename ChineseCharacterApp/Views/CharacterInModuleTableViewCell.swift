//
//  CharacterInModuleTableViewCell.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 10/9/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class CharacterInModuleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var chineseCharLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
