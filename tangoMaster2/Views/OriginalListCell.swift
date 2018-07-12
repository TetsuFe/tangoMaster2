//
//  OriginalListForNotifcationCell.swift
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

class OriginalListCell:UITableViewCell{
    
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var jpnLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var originalNotificationTango:OriginalNotificationTango!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func setCell(originalNotificationTango:OriginalNotificationTango) {
        print("setCell")
        
        self.originalNotificationTango = originalNotificationTango
        self.engLabel.text = self.originalNotificationTango.eng
        self.jpnLabel.text = self.originalNotificationTango.jpn
        if(self.originalNotificationTango.notificationFlag == "0"){
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
        }else{
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
        }
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        copyFile(from: appDelegate.originalFileName, to: "prev"+appDelegate.originalFileName, extent: "txt")
        checkButton.isEnabled = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.checkButton.isEnabled = true
        })
        
        if(self.originalNotificationTango.notificationFlag == "0"){
            // OFF -> ON
            self.originalNotificationTango.notificationFlag = "1"
            checkButton.setImage(UIImage(named:"bell")!, for: UIControlState())
            updateOriginalTangoList()
            setCell(originalNotificationTango:self.originalNotificationTango)
        }else{
            // ON -> OFF
            self.originalNotificationTango.notificationFlag = "0"
            checkButton.setImage(UIImage(named:"bell_colored")!, for: UIControlState())
            updateOriginalTangoList()
            setCell(originalNotificationTango:self.originalNotificationTango)
        }
    }
    
    
    func updateOriginalTangoList(){
        let originalTangos = getTangoArrayFromFile(fileName:appDelegate.originalFileName)
        var originalTangoList = Array<OriginalNotificationTango>()
        for r in 0..<originalTangos.count/3{
            if originalTangos[3*r] == self.originalNotificationTango.eng{
                originalTangoList.append(OriginalNotificationTango(eng: self.originalNotificationTango.eng,jpn:self.originalNotificationTango.jpn, notificationFlag: self.originalNotificationTango.notificationFlag))
            }else{
                originalTangoList.append(OriginalNotificationTango(eng: originalTangos[3*r],jpn:originalTangos[3*r+1],notificationFlag: originalTangos[3*r+2]))
            }
        }
        deleteFile(fileName:appDelegate.originalFileName)
        for originalTango in originalTangoList{
            originalTango.writeFileAdditioanally(fileName: appDelegate.originalFileName, extent: "txt")
        }
    }
}
