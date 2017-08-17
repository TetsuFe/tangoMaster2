//
//  AddOriginalTangoVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class AddOriginalTangoVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var engTextField: UITextField!
    @IBOutlet weak var jpnTextField: UITextField!
    
    @IBOutlet weak var originalListTable: UITableView!

    //textViewのキーボードの閉じるボタンが押されたとき、キーボードを閉じる
    func endEdit(){
        self.view.endEditing(true)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var originalFileName = String()
    
    @IBAction func addNewTangoButton(_ sender: Any) {
        if engTextField.text != nil && jpnTextField.text != nil{
        let newOriginalTango = OriginalNotificationTango(eng: engTextField.text!, jpn: jpnTextField.text!, notificationFlag: "1")
            newOriginalTango.writeFileAdditioanally(fileName: self.originalFileName, extent: "txt")
        cells = readOriginalTangoFile()
        originalListTable.reloadData()
        }
        endEdit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalFileName = appDelegate.originalFileName
        //textViewのキーボードを閉じるためのツールバー作成
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action:#selector(endEdit))
        kbToolBar.items = [spacer, commitButton]
        //textViewのキーボードの上にバーを設置
        engTextField.inputAccessoryView = kbToolBar
        engTextField.layer.borderWidth = 1
        jpnTextField.inputAccessoryView = kbToolBar
        jpnTextField.layer.borderWidth = 1
        
        self.automaticallyAdjustsScrollViewInsets = false
        originalListTable.delegate = self
        originalListTable.dataSource = self

        cells = readOriginalTangoFile()
    }
    /*
     現在のオリジナル単語リスト（一番上にAddした単語が出るようにしたい
     */
    
    /*
     現在のファイルを保存
     delete
     writeadditionally
     writeFile
     */

    var cells = Array<OriginalListCell>()
    
    func readOriginalTangoFile()->Array<OriginalListCell>{
        let tango = getTangoArrayFromFile(fileName:appDelegate.originalFileName)
        var newCells = Array<OriginalListCell>()
        if tango.count != 0{
            for r in 0..<tango.count/3{
                newCells.append(originalListTable.dequeueReusableCell(withIdentifier: "originalListCell") as! OriginalListCell)
                newCells[r].setCell(originalNotificationTango: OriginalNotificationTango(eng: tango[3*r],jpn:tango[3*r+1],notificationFlag: tango[3*r+2]))
            }
        }
        return newCells
    }
    
    func preserveCurrentOriginalNotificaion(currentFileName:String, preservingFileNames:String, extent:String){
        copyFile(from: currentFileName, to: preservingFileNames, extent: extent)
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
        return "現在の単語リスト"
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
