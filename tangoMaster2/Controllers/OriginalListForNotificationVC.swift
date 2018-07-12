//
//  OriginalListForNotificationVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

/*
 オリジナル通知リストのデータ構造
 1. 英単語 
 2. 訳
 3. 通知するかどうか
 例：apple@りんご@
 *
 getTangoArrayFromFile(fileName: ORIGINAL_TANGO_FILE_NAME)
 */

import UIKit

class OriginalListForNotificationVC: UIViewController, UITableViewDelegate,UITableViewDataSource{

    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    func showPopUpView(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createOriginalListPopUp") as! CreateOriginalListPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        print("popOverVC : \(popOverVC.view.frame)")
        self.view.addSubview(popOverVC.view)
        
        popOverVC.didMove(toParentViewController: self)
    }

    @IBAction func createOriginalListButton(_ sender: Any) {
        showPopUpView()
    }
    
    @IBOutlet weak var originalNotificationSelectTable: UITableView!
    
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var deselectAllButton: UIButton!
    
    @IBAction func rollbackCheckButton(_ sender: Any) {
        rollbackCheck(prevMaskFileName: PREV_ORIGINAL_LIST_FILE_NAME)
        cells = readOriginalTangoFile()
        originalNotificationSelectTable.reloadData()
    }

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated:false)
        self.automaticallyAdjustsScrollViewInsets = false
        originalNotificationSelectTable.delegate = self
        originalNotificationSelectTable.dataSource = self
        selectAllButton.addTarget(self, action: #selector(selectAllAndSaveCurrent), for: .touchUpInside)
        deselectAllButton.addTarget(self, action: #selector(deselectAllAndSaveCurrent), for: .touchUpInside)
        preserveCurrentOriginalNotificaion(currentFileName:ORIGINAL_LIST_FILE_NAME, preservingFileNames: PREV_ORIGINAL_LIST_FILE_NAME, extent:"txt")
        cells = readOriginalTangoFile()
    }
    
    var cells = Array<OriginalNotificationListCell>()
    
    func readOriginalTangoFile()->Array<OriginalNotificationListCell>{
        let tango = getTangoArrayFromFile(fileName:ORIGINAL_LIST_FILE_NAME)
        for t in tango{
            print("element: \(t)")
        }
        var newCells = Array<OriginalNotificationListCell>()
        if tango.count != 0{
            for r in 0..<tango.count/3{
                newCells.append(originalNotificationSelectTable.dequeueReusableCell(withIdentifier: "originalNotificationListCell") as! OriginalNotificationListCell)
                newCells[r].setCell(originaltangoFileStatus:OriginalTangoFileStatus(fileName: tango[3*r], prevFileName: tango[3*r+1], notificationFlag: tango[3*r+2]))
            }
        }
        return newCells
    }

    func preserveCurrentOriginalNotificaion(currentFileName:String, preservingFileNames:String, extent:String){
        copyFile(from: currentFileName, to: preservingFileNames, extent: extent)
    }

    func selectAll(){
        deleteFile(fileName:ORIGINAL_LIST_FILE_NAME)
        var preservedText = String()
        for i in 0..<cells.count{
            cells[i].originaltangoFileStatus.notificationFlag = "1"
            preservedText += cells[i].originaltangoFileStatus.fileName+"@"+cells[i].originaltangoFileStatus.prevFileName+"@"+cells[i].originaltangoFileStatus.notificationFlag+"\n"
        }
        writeFileWithExtent(fileName: ORIGINAL_LIST_FILE_NAME, text: preservedText, extent: "txt")

        cells = readOriginalTangoFile()
        originalNotificationSelectTable.reloadData()
    }
    
    func deselectAll(){
        deleteFile(fileName:ORIGINAL_LIST_FILE_NAME)
        var preservedText = String()
        for i in 0..<cells.count{
            cells[i].originaltangoFileStatus.notificationFlag = "0"
            preservedText += cells[i].originaltangoFileStatus.fileName+"@"+cells[i].originaltangoFileStatus.prevFileName+"@"+cells[i].originaltangoFileStatus.notificationFlag+"\n"
        }
        writeFileWithExtent(fileName: ORIGINAL_LIST_FILE_NAME, text: preservedText, extent: "txt")
        cells = readOriginalTangoFile()
        originalNotificationSelectTable.reloadData()
    }
    
    @objc func selectAllAndSaveCurrent(){
        preserveCurrentOriginalNotificaion(currentFileName:ORIGINAL_LIST_FILE_NAME, preservingFileNames: PREV_ORIGINAL_LIST_FILE_NAME, extent:"txt")
        selectAll()
    }
    
    @objc func deselectAllAndSaveCurrent(){
        preserveCurrentOriginalNotificaion(currentFileName:ORIGINAL_LIST_FILE_NAME, preservingFileNames: PREV_ORIGINAL_LIST_FILE_NAME, extent:"txt")
        deselectAll()
    }
    
    func rollbackCheck(prevMaskFileName:String){
        deleteFile(fileName: ORIGINAL_LIST_FILE_NAME)
        copyFile(from: prevMaskFileName, to: ORIGINAL_LIST_FILE_NAME, extent: "txt")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        //苦手が一個も登録されていないときは0を返す
        if cells.count == 0{
            return 0
        }else{
            return cells.count
        }
    }

    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }

    //Cellが選択された際に呼び出される.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "manageOriginalList") as! ManageOriginalListVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
        appDelegate.originalFileName = cells[indexPath.row].originaltangoFileStatus.fileName
        
        //通知ON・OFF状態にする？
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
