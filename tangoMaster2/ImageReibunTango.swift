//
//  EightTango.swift
//  tangoMaster
//
//  Created by Tetsu on 2016/10/03.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation

class ImageReibunTango:JpnEngImgTango{
    var engReibun:String?
    var jpnReibun:String?
    init(eng:String,jpn:String,imgPath:String,engReibun:String,jpnReibun:String){
        super.init(eng:eng,jpn:jpn,imgPath:imgPath)
        self.engReibun = engReibun
        self.jpnReibun = jpnReibun
    }
}
