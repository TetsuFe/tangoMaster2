//
//  NewImageReibun.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/23.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation

class NewImageReibun : AnyObject{
    var eng:String?
    var jpn:String?
    var engReibun:String?
    var jpnReibun:String?
    var nigateFlag:String?
    var partOfSpeech:String?
    init(eng:String,jpn:String,engReibun:String,jpnReibun:String,nigateFlag:String,partOfSpeech:String){
        self.eng = eng
        self.jpn = jpn
        self.engReibun = engReibun
        self.jpnReibun = jpnReibun
        self.nigateFlag = nigateFlag
        self.partOfSpeech = partOfSpeech
    }
}
