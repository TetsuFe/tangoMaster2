//
//  CategorySelectCell.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation
import UIKit

class CategorySelectCell:UITableViewCell{
    @IBOutlet weak var chapterLabel: UILabel!
    func setCell(_ labelName:String) {
        chapterLabel.text = labelName
    }
}
