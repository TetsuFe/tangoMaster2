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

class ChapterListForNotificationCell:UITableViewCell{
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
    var chapterOrSetsuName = Int()
    
    func setCell(chapterOrSetsuName:Int, notificationFlag:String, nigateNumber:String) {
        print("setCell")

        self.notificationFlag = notificationFlag
        self.chapterOrSetsuName = chapterOrSetsuName
        self.nigateNumber = nigateNumber

        if(self.notificationFlag == "0"){
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
        }else{
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
        }
        self.chapterOrSetsuName = chapterOrSetsuName
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let preserveFileName = "nigateNotificationCheckMask"
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
            if let f = FileHandle(forReadingAtPath: path+"/"+preserveFileName+".txt"){
                if let nigateNotificationCheckMask:String = f.readLine() {
                    print("読み込んだマスクパターンです")
                    f.closeFile()
                    print(nigateNotificationCheckMask)
                    deleteFile(fileName:preserveFileName)
                    var preCount = 0
                    for i in 0..<appDelegate.problemCategory{
                        preCount += fileNames[i].count
                    }
                    var newMask = ""
                    var index = 0
                    for c in nigateNotificationCheckMask.characters{
                        if index == preCount+appDelegate.chapterNumber*5+chapterOrSetsuName{
                            newMask += self.notificationFlag
                        }else{
                            newMask += String(c)
                        }
                        index += 1
                    }
                    writeFile(fileName: preserveFileName+".txt", text: newMask)
                }
            }else{
                print("filehandle失敗")
                writeFile(fileName:preserveFileName+".txt",text:"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
            }
            setCell(chapterOrSetsuName:self.chapterOrSetsuName, notificationFlag:self.notificationFlag, nigateNumber:self.nigateNumber)
        }
        else{
            self.notificationFlag = "0"
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
            //OFF +"0"+
            if let f = FileHandle(forReadingAtPath: path+"/"+preserveFileName+".txt"){

                if let nigateNotificationCheckMask:String =  f.readLine() {
                    f.closeFile()
                    print("読み込んだマスクパターンです")
                    print(nigateNotificationCheckMask)
                    deleteFile(fileName:preserveFileName)
                    var preCount = 0
                    for i in 0..<appDelegate.problemCategory{
                        preCount += fileNames[i].count
                    }
                    var newMask = ""
                    var index = 0
                    for c in nigateNotificationCheckMask.characters{
                        if index == preCount+appDelegate.chapterNumber*5+chapterOrSetsuName{
                            newMask += self.notificationFlag
                        }else{
                            newMask += String(c)
                        }
                        index += 1
                    }

                    writeFile(fileName: preserveFileName+".txt", text: newMask)
                }
            }else{
                print("filehandle失敗")
                writeFile(fileName:preserveFileName+".txt",text:"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
            }
            setCell(chapterOrSetsuName:self.chapterOrSetsuName, notificationFlag:self.notificationFlag, nigateNumber:self.nigateNumber)
        }
    }
}

