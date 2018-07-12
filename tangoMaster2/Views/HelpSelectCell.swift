//
//  HelpSelectCell.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/02/27.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation
import UIKit

class HelpSelectCell:UITableViewCell{
    
    @IBOutlet weak var selectOptionLabel: UILabel!
    
    func setCell(_ labelName:String) {
        selectOptionLabel.text = labelName
    }
}
