//
//  TangoNotificationLoader.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/06.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation

class TangoNotificationMaskLoader{
    
    private var maskFileName:String
    
    init(maskFileName:String){
        self.maskFileName = maskFileName
    }
    
    func readNotificationFileMask()->String{
        let path = defaultTextFileDirectoryPath
        var mask = String()
        if let maskFileObject = FileHandle(forReadingAtPath: path+"/"+self.maskFileName+".txt"){
            if let nigateNotificationCheckMask:String = maskFileObject.readline() {
                mask = nigateNotificationCheckMask
                print("読み込んだマスクパターンです")
                print(nigateNotificationCheckMask)
            }else{
                mask = zeroMask
            }
        }else{
            mask = zeroMask
        }
        return mask
    }
    
    
    func convertMaskToNotificationFileName(notificationType:Int, maskString:String)->Array<String>{
        var notificationFileNames = Array<String>()
        for (i, c) in maskString.characters.enumerated(){
            if c == "1"{
                if notificationType == 0{
                    notificationFileNames.append(transArrayDimension2to1(array2D: NORMAL_FILE_NAMES)[i])
                }else if notificationType == 1{
                    notificationFileNames.append(transArrayDimension2to1(array2D: NIGATE_FILE_NAMES)[i])
                }else{
                    
                }
            }
        }
        return notificationFileNames
    }
    
    func transArrayDimension2to1<T>(array2D :Array<Array<T>>)->Array<T>{
        var array1D = Array<T>()
        for elementArray in array2D{
            for element in elementArray{
                array1D.append(element)
            }
        }
        return array1D
    }
    
    
}

