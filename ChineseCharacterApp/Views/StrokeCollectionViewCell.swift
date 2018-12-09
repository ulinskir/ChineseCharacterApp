//
//  StrokeCollectionViewCell.swift
//  ChineseCharacterApp
//
//  Created by Risa Ulinski on 11/28/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import UIKit

class StrokeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var strokeShapeView: ShapeView!
    @IBOutlet weak var strokeLabel: UILabel!
    @IBOutlet weak var strokeView: UIView!
    
    override func prepareForReuse() {
       super.prepareForReuse()
        strokeShapeView.clearCanvas()
    }
    
    override var isSelected: Bool {
        didSet {
            self.strokeView.backgroundColor = isSelected ? UIColor.gray : UIColor.white
        }
    }

}
