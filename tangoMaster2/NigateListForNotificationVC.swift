//
//  NigateListForNotificationVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/07/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class NigateListForNotificationVC: UIViewController, UITableViewDelegate,UITableViewDataSource{

    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var nigateNotificationCategorySelectTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        nigateNotificationCategorySelectTable.delegate = self
        nigateNotificationCategorySelectTable.dataSource = self
    }
    
    var is_category_top:Bool = true
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        if is_category_top {
            //section range = {0...9}
            //section range = {0}
            if section == 0{
                //mylistの時
                return chapterNames[appDelegate.problemCategory].count
            }else{
                return 0
            }
        }else {
            if section == 0{
                return 5
            }else{
                return 0
            }
        }
    }
    
   let zeroMask = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    
    func tableView(_ tableView : UITableView,cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        //ファイルからmaskを取り出す処理
        let preserveFileName = "nigateNotificationCheckMask.txt"
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
        var mask = String()
        if let f = FileHandle(forReadingAtPath: path+"/"+preserveFileName){
            if let nigateNotificationCheckMask:String = f.readLine() {
                mask = nigateNotificationCheckMask
                print("読み込んだマスクパターンです")
                print(nigateNotificationCheckMask)
                
            }else{
                mask = zeroMask
            }
        }else{
            print("tableViewin write zero mask")
            writeFile(fileName:"nigateNotificationCheckMask.txt",text:zeroMask)
        }
        let cell: ChapterListForNotificationCell = nigateNotificationCategorySelectTable.dequeueReusableCell(withIdentifier: "chapterListForNotificationCell") as! ChapterListForNotificationCell
        var preCount = 0

        for i in 0..<appDelegate.problemCategory{
            preCount += fileNames[i].count
        }
        var notificationFlag = "1"
        if is_category_top{
            var maskCharCount = 0
            for c in mask.characters{
                if maskCharCount >= preCount+indexPath.row*5 && maskCharCount < preCount+indexPath.row*5 + 5{
                    if String(c) == "0"{
                        notificationFlag = "0"
                    }
                }
                maskCharCount += 1
            }
            cell.setCell(chapterOrSetsuName:indexPath.row,notificationFlag:notificationFlag, nigateNumber:"1")
            return cell
        }else{
            var maskCharCount = 0
            for c in mask.characters{
                if maskCharCount == preCount+appDelegate.chapterNumber*5+indexPath.row{
                    if String(c) == "0"{
                        notificationFlag = "0"
                    }
                }
                maskCharCount += 1
            }
            cell.setCell(chapterOrSetsuName:indexPath.row,notificationFlag:notificationFlag, nigateNumber:"1")
            return cell
        }
    }
    
    
    //セクションの数を返す.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セクションのタイトルを返す.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if is_category_top{
            return sectionList[appDelegate.problemCategory]
        }else{
            return chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
        }
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_category_top{
            appDelegate.chapterNumber = indexPath.row
            is_category_top = false
            nigateNotificationCategorySelectTable.reloadData()
        }else{
            appDelegate.setsuNumber = indexPath.row
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}