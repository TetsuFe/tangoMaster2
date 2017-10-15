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
        rollbackCheck(prevMaskFileName: "prev"+appDelegate.originalFileName)
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
        preserveCurrentOriginalNotificaion(currentFileName:appDelegate.originalFileName, preservingFileNames: "prev"+appDelegate.originalFileName, extent:"txt")
    }
    
    override func viewWillAppear(_ animated : Bool){
        super.viewWillAppear(true)
        cells = readOriginalTangoFile()
        originalListTable.reloadData()
    }
    
    var cells = Array<OriginalListCell>()
    
    func readOriginalTangoFile()->Array<OriginalListCell>{
        let tango = getTangoArrayFromFile(fileName:appDelegate.originalFileName)
        var mewCells = Array<OriginalListCell>()
        if tango.count != 0{
            for r in 0..<tango.count/3{
                mewCells.append(originalListTable.dequeueReusableCell(withIdentifier: "originalListCell") as! OriginalListCell)
                mewCells[r].setCell(originalNotificationTango: OriginalNotificationTango(eng: tango[3*r],jpn:tango[3*r+1],notificationFlag: tango[3*r+2]))
            }
        }
        return mewCells
    }
    
    func preserveCurrentOriginalNotificaion(currentFileName:String, preservingFileNames:String, extent:String){
        copyFile(from: currentFileName, to: preservingFileNames, extent: extent)
    }
    
    func selectAll(){
        deleteFile(fileName:appDelegate.originalFileName)
        for i in 0..<cells.count{
            cells[i].originalNotificationTango.notificationFlag = "1"
            cells[i].originalNotificationTango.writeFileAdditioanally(fileName: appDelegate.originalFileName, extent: "txt")
        }
        cells = readOriginalTangoFile()
        originalListTable.reloadData()
    }
    
    func deselectAll(){
        deleteFile(fileName:appDelegate.originalFileName)
        for i in 0..<cells.count{
            cells[i].originalNotificationTango.notificationFlag = "0"
            cells[i].originalNotificationTango.writeFileAdditioanally(fileName: appDelegate.originalFileName, extent: "txt")
        }
        cells = readOriginalTangoFile()
        originalListTable.reloadData()
    }
    
    @objc func selectAllAndSaveCurrent(){
        preserveCurrentOriginalNotificaion(currentFileName:appDelegate.originalFileName, preservingFileNames: "prev"+appDelegate.originalFileName, extent:"txt")
        selectAll()
    }
    @objc  
    func deselectAllAndSaveCurrent(){
        preserveCurrentOriginalNotificaion(currentFileName:appDelegate.originalFileName, preservingFileNames: "prev"+appDelegate.originalFileName, extent:"txt")
        deselectAll()
    }
    
    func rollbackCheck(prevMaskFileName:String){
        deleteFile(fileName: appDelegate.originalFileName)
        copyFile(from: prevMaskFileName, to: appDelegate.originalFileName, extent: "txt")
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
    
    //セクションの数を返す.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セクションのタイトルを返す.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appDelegate.originalFileName
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
