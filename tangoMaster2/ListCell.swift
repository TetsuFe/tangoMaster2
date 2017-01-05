//
//  ListCell.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/23.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation
import UIKit

class ListCell:UITableViewCell{
    @IBOutlet weak var engLabel: UILabel!
    @IBOutlet weak var jpnLabel: UILabel!
    @IBOutlet weak var engPhrase: UILabel!
    @IBOutlet weak var jpnPhrase: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var partOfSpeech = String()
    
    var list = Array<NewImageReibun>()
    
    private var nigateFlag = "0"
    
    func setCell(_ tangoImageReibun: NewImageReibun) {
        print("setCell")
        engLabel.text = tangoImageReibun.eng
        jpnLabel.text = tangoImageReibun.jpn
        engPhrase.text = tangoImageReibun.engReibun
        jpnPhrase.text = tangoImageReibun.jpnReibun
        nigateFlag = tangoImageReibun.nigateFlag!
        partOfSpeech = tangoImageReibun.partOfSpeech!
        if(self.nigateFlag == "0"){
            checkButton.setImage(UIImage(named:"un_nigate")!, for: UIControlState())
        }else{
            checkButton.setImage(UIImage(named:"nigate")!, for: UIControlState())
        }
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let preserveFileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
        checkButton.isEnabled = false //login_btnはUIButtonです
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.checkButton.isEnabled = true
        })
        
        if(self.nigateFlag == "0"){
            self.nigateFlag = "1"
            checkButton.setImage(UIImage(named:"un_nigate")!, for: UIControlState())
            //ON
            writeSixFile(fileName:preserveFileName,eng:engLabel.text!,jpn:jpnLabel.text!,engPhrase:engPhrase.text!,jpnPhrase:jpnPhrase.text!,nigateFlag:nigateFlag,partOfSpeech: partOfSpeech)
            setCell(NewImageReibun(eng:engLabel.text!,jpn:jpnLabel.text!,engReibun:engPhrase.text!,jpnReibun:jpnPhrase.text!,nigateFlag:nigateFlag,partOfSpeech:partOfSpeech))
        }
        else{
            self.nigateFlag = "0"
            checkButton.setImage(UIImage(named:"nigate")!, for: UIControlState())
            //OFF
            let nigateArray = getfile(fileName:preserveFileName)
            for r in 0..<nigateArray.count/6{
                list.append(NewImageReibun(eng: nigateArray[8*r],jpn:nigateArray[8*r+1],engReibun:nigateArray[8*r+3],jpnReibun:nigateArray[8*r+4],nigateFlag: nigateArray[8*r+5],partOfSpeech: nigateArray[8*r+6]))
            }
            list = deleteWordFromNigateArray(eng:engLabel.text!,list:list)
            deleteFile(fileName:preserveFileName)
            for r in 0..<list.count{
                writeSixFile(fileName:preserveFileName,eng: list[r].eng!, jpn: list[r].jpn!, engPhrase: list[r].engReibun!, jpnPhrase: list[r].jpnReibun!,nigateFlag:list[r].nigateFlag!,partOfSpeech: list[r].partOfSpeech!)
            }
            setCell(NewImageReibun(eng:engLabel.text!,jpn:jpnLabel.text!,engReibun:engPhrase.text!,jpnReibun:jpnPhrase.text!,nigateFlag:nigateFlag,partOfSpeech:partOfSpeech))
        }
 
    }
    
    func deleteWordFromNigateArray(eng:String,list:Array<NewImageReibun>)->Array<NewImageReibun>{
        var deletedArray = list
        for i in 0..<deletedArray.count{
            if deletedArray[i].eng == eng{
                deletedArray.remove(at: i)
            }
        }
        return deletedArray
    }
   /*
    func readFile(fileName:String)->Array<String>{
    }
 */
    /*****以降はファイル関連******/
}
