//
//  BackgroundImageView.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/10/16.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class BackgroundImageView : UIImageView{
    var idx : Int!
    var isSelected : Bool!
    init(image:UIImage?, isSelected: Bool, idx: Int){
        super.init(image: image)
        self.idx = idx
        self.isSelected = isSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
