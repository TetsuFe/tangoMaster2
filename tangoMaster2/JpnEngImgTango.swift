//
//  JpnEngTango.swift
//  tangoMaster
//
//  Created by Tetsu on 2016/10/03.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation

class JpnEngImgTango:NSObject{
    var eng:String?
    var jpn:String?
    var imgPath:String?
    init(eng:String,jpn:String,imgPath:String){
        self.eng = eng
        self.jpn = jpn
        self.imgPath = imgPath
    }
}
