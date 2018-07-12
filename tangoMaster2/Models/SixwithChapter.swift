//
//  SixwithChapter.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/03/08.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation

class SixWithChapter:NewImageReibun{
    var chapterNumber : String?
    init(eng: String, jpn: String, engReibun: String, jpnReibun: String, nigateFlag: String, partOfSpeech: String,chapterNumber:String){
        super.init(eng: eng, jpn: jpn, engReibun: engReibun, jpnReibun: jpnReibun, nigateFlag: nigateFlag, partOfSpeech: partOfSpeech)
        self.chapterNumber = chapterNumber
    }
}
