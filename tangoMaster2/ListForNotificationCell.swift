//
//  NigateListForNotificationCell.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/07/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//
//chapter・苦手の数・チェック欄（通知するかしないか）・一括チェック欄

import Foundation
import UIKit

class ListForNotificationCell:UITableViewCell{
    //ヘッダが必要（一括チェック欄）
    //chapter名
    //苦手の数
    //チェック欄（image）
    //
    @IBOutlet weak var chapterOrSectionLabel: UILabel!
    @IBOutlet weak var nigateNumberLabel: UILabel!
   
    @IBOutlet weak var checkButton: UIButton!
    var notificationFlag:String = "0"
    var nigateNumber = String()
    var chapterOrSetsuNumber = Int()
    var sectionType = String()
    
    func setCell(chapterOrSetsuNumber:Int, notificationFlag:String, nigateNumber:String, sectionType: String) {
        print("setCell")
        print("chapterOrSetsuNumber : \(chapterOrSetsuNumber)")
        
        self.notificationFlag = notificationFlag
        self.chapterOrSetsuNumber = chapterOrSetsuNumber
        self.nigateNumber = nigateNumber
        self.sectionType = sectionType

        if(self.notificationFlag == "0"){
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
        }else{
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
        }
        self.chapterOrSetsuNumber = chapterOrSetsuNumber
    }
    
    let maskFileName = "nigateNotificationCheckMask"
    let prevMaskFileName = "prevNigateNotificationCheckMask"

    let zeroMask = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        writeCurrectMask()
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
        //苦手のmask文字列を得る
        
        
        //今のchapter&sectionを頼りに文字列を区切り、該当箇所のマスクを更新する
        
        checkButton.isEnabled = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.checkButton.isEnabled = true
        })
        
        if(self.notificationFlag == "0"){
            self.notificationFlag = "1"
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
            //ON +"1"+
            if let f = FileHandle(forReadingAtPath: path+"/"+maskFileName+".txt"){
                if let nigateNotificationCheckMask:String = f.readLine() {
                    print("書き込み前のマスクパターンです")
                    f.closeFile()
                    print(nigateNotificationCheckMask)
                    deleteFile(fileName:maskFileName)
                    var preCount = 0
                    for i in 0..<appDelegate.problemCategory{
                        preCount += fileNames[i].count
                    }
                    var newMask = ""
                    var index = 0
                    for c in nigateNotificationCheckMask.characters{
                        if sectionType == "chapter"{
                            let chapterNumber = self.chapterOrSetsuNumber
                            if index >= preCount+chapterNumber*5 && index < preCount+chapterNumber*5+5{
                                newMask += self.notificationFlag
                            }else{
                                newMask += String(c)
                            }
                        }else{
                            let setsuNumber = self.chapterOrSetsuNumber
                            if index == preCount+appDelegate.chapterNumber*5+setsuNumber{
                                newMask += self.notificationFlag
                            }else{
                                newMask += String(c)
                            }
                        }
                        index += 1
                    }
                    writeFile(fileName: maskFileName+".txt", text: newMask)
                    if let f = FileHandle(forReadingAtPath: path+"/"+maskFileName+".txt"){
                        if let nigateNotificationCheckMaskAfter:String =  f.readLine() {
                            f.closeFile()
                            print("書き込み後のマスクパターンです")
                            print(nigateNotificationCheckMaskAfter)
                        }
                    }
                }
            }else{
                print("filehandle失敗")
                writeFile(fileName:maskFileName+".txt",text:zeroMask)
            }
            setCell(chapterOrSetsuNumber:self.chapterOrSetsuNumber, notificationFlag:self.notificationFlag, nigateNumber:self.nigateNumber,sectionType: self.sectionType)
        }
        else{
            self.notificationFlag = "0"
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
            //OFF +"0"+
            if let f = FileHandle(forReadingAtPath: path+"/"+maskFileName+".txt"){

                if let nigateNotificationCheckMask:String =  f.readLine() {
                    f.closeFile()
                    print("書き込み前のマスクパターンです")
                    print(nigateNotificationCheckMask)
                    deleteFile(fileName:maskFileName)
                    var preCount = 0
                    for i in 0..<appDelegate.problemCategory{
                        preCount += fileNames[i].count
                    }
                    var newMask = ""
                    var index = 0
                    for c in nigateNotificationCheckMask.characters{
                        if sectionType == "chapter"{
                            let chapterNumber = self.chapterOrSetsuNumber
                            if index >= preCount+chapterNumber*5 && index < preCount+chapterNumber*5+5{
                                newMask += self.notificationFlag
                            }else{
                                newMask += String(c)
                            }
                        }else{
                            let setsuNumber = self.chapterOrSetsuNumber
                            if index == preCount+appDelegate.chapterNumber*5+setsuNumber{
                                newMask += self.notificationFlag
                            }else{
                                newMask += String(c)
                            }
                        }
                        index += 1
                    }

                    writeFile(fileName: maskFileName+".txt", text: newMask)
                    if let f = FileHandle(forReadingAtPath: path+"/"+maskFileName+".txt"){
                        if let nigateNotificationCheckMaskAfter:String =  f.readLine() {
                            f.closeFile()
                            print("書き込み後のマスクパターンです")
                            print(nigateNotificationCheckMaskAfter)
                        }
                    }
                }
            }else{
                print("filehandle失敗")
                writeFile(fileName:maskFileName+".txt",text:zeroMask)
            }
            setCell(chapterOrSetsuNumber:self.chapterOrSetsuNumber, notificationFlag:self.notificationFlag, nigateNumber:self.nigateNumber,sectionType: self.sectionType)
        }
    }
    
    func writeCurrectMask(){
        var currectMask = String()
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
        if let f = FileHandle(forReadingAtPath: path+"/"+maskFileName+".txt"){
            
            if let mask = f.readLine(){
                currectMask = mask
            }else{
                currectMask = zeroMask
            }
            deleteFile(fileName:prevMaskFileName)
            writeFile(fileName: prevMaskFileName+".txt",text: currectMask)
        }
        print("書き込んだ現在のマスクパターンは\(currectMask)")
    }
}

