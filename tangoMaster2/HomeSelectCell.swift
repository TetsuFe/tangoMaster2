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
    
    func setCell(_ labelName:String) {
        sectionLabel.text = labelName
    }
}
