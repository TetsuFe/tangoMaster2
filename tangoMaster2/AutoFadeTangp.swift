//
//  AutoFadeTangp.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/10/29.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation

class AutoFadeTangp:CardTango{
    var imagaPath:String?
    init(eng:String,jpn:String,soundPath:String,imagePath:String){
        super.init(eng:eng,jpn:jpn,soundPath:soundPath)
        self.soundPath = soundPath
    }
}
