//
//  ListForNotificationCell.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/07/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//
//chapter・苦手の数・チェック欄（通知するかしないか）・一括チェック欄

import Foundation
import UIKit

class ListForNotificationCell:UITableViewCell{

    @IBOutlet weak var chapterOrSectionLabel: UILabel!
   
    @IBOutlet weak var checkButton: UIButton!
    
    var notificationFlag:String = "0"
    var chapterOrSetsuNumber = Int()
    var sectionType = String()
    var maskFileName = String()
    private var parentVC:ListForNotificationVC!

    
    func setCell(chapterOrSetsuNumber:Int, notificationFlag:String, sectionType: String, maskFileName:String,parentVC:ListForNotificationVC) {
        print("setCell")
        print("chapterOrSetsuNumber : \(chapterOrSetsuNumber)")
        
        self.notificationFlag = notificationFlag
        self.chapterOrSetsuNumber = chapterOrSetsuNumber
        self.sectionType = sectionType
        self.maskFileName = maskFileName
        self.parentVC = parentVC

        if(self.notificationFlag == "0"){
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
        }else{
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if sectionType == "chapter"{
            chapterOrSectionLabel.text = chapterNames[appDelegate.problemCategory][self.chapterOrSetsuNumber]
        }else{
            chapterOrSectionLabel.text = NORMAL_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+chapterOrSetsuNumber]
        }

        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func buttonTapped(_ sender: AnyObject) {
        writeCurrectMask()
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let path = defaultTextFileDirectoryPath
        
        checkButton.isEnabled = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.checkButton.isEnabled = true
        })
        
        if(self.notificationFlag == "0"){
            self.notificationFlag = "1"
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
            //ON +"1"+
            if let f = FileHandle(forReadingAtPath: path+"/"+self.maskFileName+".txt"){
                if let notificationCheckMask:String = f.readLine() {
                    print("書き込み前のマスクパターンです")
                    f.closeFile()
                    print(notificationCheckMask)
                    var preCount = 0
                    for i in 0..<appDelegate.problemCategory{
                        preCount += NORMAL_FILE_NAMES[i].count
                    }
                    var newMask = ""
                    var index = 0
                    for c in notificationCheckMask.characters{
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
                    deleteFile(fileName:self.maskFileName)
                    writeFile(fileName: self.maskFileName+".txt", text: newMask)
                    if let f = FileHandle(forReadingAtPath: path+"/"+self.maskFileName+".txt"){
                        if let notificationCheckMaskAfter:String =  f.readLine() {
                            f.closeFile()
                            print("書き込み後のマスクパターンです")
                            print(notificationCheckMaskAfter)
                        }
                    }
                }
            }else{
                print("filehandle失敗")
                writeFile(fileName:self.maskFileName+".txt",text:zeroMask)
            }
            setCell(chapterOrSetsuNumber:self.chapterOrSetsuNumber, notificationFlag:self.notificationFlag ,sectionType: self.sectionType, maskFileName: self.maskFileName,parentVC: self.parentVC)
        }
        else{
            self.notificationFlag = "0"
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
            //OFF +"0"+
            if let f = FileHandle(forReadingAtPath: path+"/"+self.maskFileName+".txt"){

                if let nigateNotificationCheckMask:String =  f.readLine() {
                    f.closeFile()
                    print("書き込み前のマスクパターンです")
                    print(nigateNotificationCheckMask)
                    var preCount = 0
                    for i in 0..<appDelegate.problemCategory{
                        preCount += NORMAL_FILE_NAMES[i].count
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
                    deleteFile(fileName:self.maskFileName)
                    writeFile(fileName: self.maskFileName+".txt", text: newMask)
                    if let f = FileHandle(forReadingAtPath: path+"/"+self.maskFileName+".txt"){
                        if let nigateNotificationCheckMaskAfter:String =  f.readLine() {
                            f.closeFile()
                            print("書き込み後のマスクパターンです")
                            print(nigateNotificationCheckMaskAfter)
                        }
                    }
                }
            }else{
                print("filehandle失敗")
                writeFile(fileName:self.maskFileName+".txt",text:zeroMask)
            }
            setCell(chapterOrSetsuNumber:self.chapterOrSetsuNumber, notificationFlag:self.notificationFlag,sectionType: self.sectionType, maskFileName: self.maskFileName,parentVC: self.parentVC)
        }
        self.parentVC.drawGraphWirhAnimation()
    }
    
    func writeCurrectMask(){
        var currectMask = String()
        let path = defaultTextFileDirectoryPath
        if let f = FileHandle(forReadingAtPath: path+"/"+self.maskFileName+".txt"){
            
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

