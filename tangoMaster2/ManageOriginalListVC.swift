//
//  OriginalListVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/16.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class ManageOriginalListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func moveAddOriginalTangoVCButton(_ sender: Any) {
        print("notificaion home cell button tapped")
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addOriginalTango") as! AddOriginalTangoVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBOutlet weak var originalListTable: UITableView!
    
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var deselectAllButton: UIButton!
    
    @IBAction func rollbackCheckButton(_ sender: Any) {
        rollbackCheck(prevMaskFileName: PREV_ORIGINAL_LIST_FILE_NAME)
        originalListTable.reloadData()
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        originalListTable.delegate = self
        originalListTable.dataSource = self
        selectAllButton.addTarget(self, action: #selector(selectAllAndSaveCurrent), for: .touchUpInside)
        deselectAllButton.addTarget(self, action: #selector(deselectAllAndSaveCurrent), for: .touchUpInside)
        preserveCurrentOriginalNotificaion(currentFileName:ORIGINAL_LIST_FILE_NAME, preservingFileNames: PREV_ORIGINAL_LIST_FILE_NAME, extent:"txt")
        cells = readOriginalTangoFile()
    }
    
    var cells = Array<OriginalListCell>()
    
    func readOriginalTangoFile()->Array<OriginalListCell>{
        let tango = getTangoArrayFromFile(fileName:appDelegate.originalFileName)
        if tango.count != 0{
            for r in 0..<tango.count/3{
                cells.append(originalListTable.dequeueReusableCell(withIdentifier: "originalListCell") as! OriginalListCell)
                cells[r].setCell(originalNotificationTango: OriginalNotificationTango(eng: tango[3*r],jpn:tango[3*r+1],notificationFlag: tango[3*r+2]))
            }
        }
        return cells
    }
    
    func preserveCurrentOriginalNotificaion(currentFileName:String, preservingFileNames:String, extent:String){
        copyFile(from: currentFileName, to: preservingFileNames, extent: extent)
    }
    
    func selectAll(){
        deleteFile(fileName:ORIGINAL_LIST_FILE_NAME)
        for i in 0..<cells.count{
            cells[i].originalNotificationTango.notificationFlag = "1"
            cells[i].originalNotificationTango.writeFileAdditioanally(fileName: ORIGINAL_LIST_FILE_NAME, extent: "txt")
        }
        originalListTable.reloadData()
    }
    
    func deselectAll(){
        deleteFile(fileName:ORIGINAL_LIST_FILE_NAME)
        for i in 0..<cells.count{
            cells[i].originalNotificationTango.notificationFlag = "0"
            cells[i].originalNotificationTango.writeFileAdditioanally(fileName: ORIGINAL_LIST_FILE_NAME, extent: "txt")
        }
        originalListTable.reloadData()
    }
    
    
    
    func selectAllAndSaveCurrent(){
        preserveCurrentOriginalNotificaion(currentFileName:ORIGINAL_LIST_FILE_NAME, preservingFileNames: PREV_ORIGINAL_LIST_FILE_NAME, extent:"txt")
        selectAll()
    }
    
    func deselectAllAndSaveCurrent(){
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
        //通知ON・OFF状態にする？
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
