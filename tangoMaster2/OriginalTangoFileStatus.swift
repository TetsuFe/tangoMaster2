//
//  File.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/16.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation

//形式が同じなので、オリジナル単語のファイルからArrayを取り出すものを利用
class OriginalTangoFileStatus{
    var fileName:String!
    var prevFileName:String!
    var notificationFlag:String!
    
    init(fileName:String, prevFileName:String, notificationFlag:String){
        self.fileName = fileName
        self.prevFileName = prevFileName
        self.notificationFlag = notificationFlag
    }
    
    func writeFileAdditioanally(fileName:String, extent:String){
        let path = defaultTextFileDirectoryPath
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        
        if !isDir.boolValue{
            try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
        }
        
        let fileObject:String = self.fileName+"@"+self.prevFileName+"@"+self.notificationFlag+"\n"
        
        let filepath1 = "\(path)/\(fileName)"+"."+extent
        
        let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
        
        // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
        if(filew == nil){
            try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
        }
        
        //読み込み用で開くforReadingAtPath
        let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
        if filer == nil {
            print("File open failed")
        } else {
            filer?.seekToEndOfFile()
            let endOffset = (filer?.offsetInFile)!
            filer?.seek(toFileOffset: 0)
            let databuffer = filer?.readData(ofLength: Int(endOffset))
            // NSData to String
            let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
            if !isInFile(cWord: fileName, str:out){
                fileWrite(filew: filew!, filepath:filepath1,fileObject:fileObject)
            }
            filer?.closeFile()
        }
    }
}
