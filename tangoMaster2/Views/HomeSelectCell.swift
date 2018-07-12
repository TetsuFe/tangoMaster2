//
//  HomeSelectCell.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//
import Foundation
import UIKit

class HomeSelectCell:UITableViewCell{
    @IBOutlet weak var sectionLabel: UILabel!
    
    
    @IBOutlet weak var sectionImage: UIImageView!
    
    func setCell(_ labelName:String,_ imageFileName:String) {
        sectionLabel.text = labelName
        sectionImage.image = UIImage(named: imageFileName)
        
    }
}
