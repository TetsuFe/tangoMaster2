//
//  OriginalNotificationListCell.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

//chapter・苦手の数・チェック欄（通知するかしないか）・一括チェック欄
//chapterという概念が存在しない
//単語・日本語という単純な構造

import Foundation
import UIKit

class OriginalNotificationListCell:UITableViewCell{
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var originaltangoFileStatus:OriginalTangoFileStatus!
    
    func setCell(originaltangoFileStatus:OriginalTangoFileStatus) {
        print("setCell")
        self.originaltangoFileStatus = originaltangoFileStatus
        listNameLabel.text = self.originaltangoFileStatus.fileName
        if(self.originaltangoFileStatus.notificationFlag == "0"){
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
        }else{
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
        }
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func buttonTapped() {
        copyFile(from: ORIGINAL_LIST_FILE_NAME, to: PREV_ORIGINAL_LIST_FILE_NAME, extent: "txt")
        checkButton.isEnabled = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.checkButton.isEnabled = true
        })
        
        if(self.originaltangoFileStatus.notificationFlag == "0"){
            // OFF -> ON
            self.originaltangoFileStatus.notificationFlag = "1"
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
            updateOriginalFileStatus()
            setCell(originaltangoFileStatus:self.originaltangoFileStatus)
        }else{
            // ON -> OFF
            self.originaltangoFileStatus.notificationFlag = "0"
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
            updateOriginalFileStatus()
            setCell(originaltangoFileStatus:self.originaltangoFileStatus)
        }
    }
    
    func updateOriginalFileStatus(){
        let originalListsFIleElements = getTangoArrayFromFile(fileName:ORIGINAL_LIST_FILE_NAME)
        var originalListFileStatuses = Array<OriginalTangoFileStatus>()
        for t in originalListsFIleElements{
            print("tangoElemet: \(t)")
        }
        for r in 0..<originalListsFIleElements.count/3{
            if originalListsFIleElements[3*r] == self.originaltangoFileStatus.fileName{
                originalListFileStatuses.append(OriginalTangoFileStatus(fileName: self.originaltangoFileStatus.fileName, prevFileName: self.originaltangoFileStatus.prevFileName, notificationFlag: self.originaltangoFileStatus.notificationFlag))
            }else{
                originalListFileStatuses.append(OriginalTangoFileStatus(fileName: originalListsFIleElements[3*r], prevFileName: originalListsFIleElements[3*r+1], notificationFlag: originalListsFIleElements[3*r+2]))
            }
        }
        deleteFile(fileName:ORIGINAL_LIST_FILE_NAME)
        for originalListFileStatus in originalListFileStatuses{
            print("in")
            originalListFileStatus.writeFileAdditioanally(fileName: ORIGINAL_LIST_FILE_NAME, extent: "txt")
        }
        let originalListsFIleElements2 = getTangoArrayFromFile(fileName:ORIGINAL_LIST_FILE_NAME)
        for t in originalListsFIleElements2{
            print("tangoElemet: \(t)")
        }
    }
 
}
