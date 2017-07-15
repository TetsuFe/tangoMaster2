//
//  LocalNotificationHomeVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/06/03.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class LocalNotificationHomeVC: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate,UITableViewDataSource{

    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
        return orientation
    }
    
    //指定方向に自動的に変更
    override var shouldAutorotate : Bool{
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationDurationPicker.delegate = self
        notificationDurationPicker.dataSource = self
        notificationHomeTable.delegate = self
        notificationHomeTable.dataSource = self
        //保存した値を読み込み、pickerに反映
        readStoredDurationAndSetPicker()
        
        cancelButton.addTarget(self,action: #selector(cancelChangeDuration),for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let hoursList:Array<UInt> = [0,1,2,3,4,5,6,7,8,9,10,11,12,24]
    let minutesList:Array<UInt> = [1,5,10,20,30,60,120,180]
    
    @IBOutlet weak var notificationDurationPicker: UIPickerView!
    
    @IBOutlet weak var notificationHomeTable: UITableView!
    
    let notificationLabelNames = ["自由に選ぶ","苦手","自分で登録"]
    let imageNames = ["normallist.png","nigatelist.png","manual.png"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return hoursList.count
        }else{
            //if component == 1{
            return minutesList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return String(hoursList[row])+"時間"
        }else{
            //if component == 1{
            return String(minutesList[row])+"分"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let notificationMinutesUserDefaults = UserDefaults.standard
        if component == 0{
            notificationMinutesUserDefaults.set(hoursList[row],forKey:"notificationHours")
            let notificationMinutesIndexUserDefaults = UserDefaults.standard
            notificationMinutesIndexUserDefaults.set(row,forKey:"notificationHoursIndex")
        }else{
            //if component == 1{
            notificationMinutesUserDefaults.set(minutesList[row],forKey:"notificationMinutes")
            let notificationMinutesIndexUserDefaults = UserDefaults.standard
            notificationMinutesIndexUserDefaults.set(row,forKey:"notificationMinutesIndex")
            print("分の行は\(row)")
        }
    }
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    func cancelChangeDuration(){
        
        let notificationHoursUserDefaults = UserDefaults.standard
        notificationHoursUserDefaults.set(oldHours,forKey:"notificationHours")
        let notificationHoursIndexUserDefaults = UserDefaults.standard
        notificationHoursIndexUserDefaults.set(oldHoursIndex,forKey:"notificationHoursIndex")

        let notificationMinutesUserDefaults = UserDefaults.standard
        notificationMinutesUserDefaults.set(oldMinutes,forKey:"notificationMinutes")
        let notificationMinutesIndexUserDefaults = UserDefaults.standard
        notificationMinutesIndexUserDefaults.set(oldMinutesIndex,forKey:"notificationMinutesIndex")
        
        readStoredDurationAndSetPicker()
    }
    
    func readStoredDurationAndSetPicker(){
        if UserDefaults.standard.object(forKey: "notificationHoursIndex") != nil {
            notificationDurationPicker.selectRow(UserDefaults.standard.integer(forKey: "notificationHoursIndex"), inComponent: 0, animated: true)
            oldHours = UserDefaults.standard.integer(forKey: "notificationHours")
            oldHoursIndex = UserDefaults.standard.integer(forKey: "notificationHoursIndex")
        }
        if UserDefaults.standard.object(forKey: "notificationMinutesIndex") != nil {
            notificationDurationPicker.selectRow(UserDefaults.standard.integer(forKey: "notificationMinutesIndex"), inComponent: 1, animated: true)
            oldMinutes = UserDefaults.standard.integer(forKey: "notificationMinutes")
            oldMinutesIndex = UserDefaults.standard.integer(forKey: "notificationMinutesIndex")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return notificationLabelNames.count
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        let cell: HomeSelectCell = notificationHomeTable.dequeueReusableCell(withIdentifier: "HomeSelectCell") as! HomeSelectCell
        
        cell.setCell(notificationLabelNames[indexPath.row],imageNames[indexPath.row])
        return cell
    }
    
    //Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.notificationSceneTag = indexPath.row
        var secondViewController = UIViewController()
        if indexPath.row == 0{
            
        }else if indexPath.row == 1{
            
        }else if indexPath.row == 2{
            
        }else if indexPath.row == 3{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
            //self.present(secondViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        //選択時の色の変更をすぐ消す
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func decideCategoryButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        // -1は初期値。tableの中の何も選択していないとエラーにする
        if appDelegate.notificationSceneTag != -1{
            //アラートビューを使って「選択してください！」と警告する
        }else if appDelegate.notificationSceneTag == 0{
            userDefaults.set("free", forKey: "notificationCategory1")
        }else if appDelegate.notificationSceneTag == 1{
            userDefaults.set("nigate", forKey: "notificationCategory1")
        }else if appDelegate.notificationSceneTag == 2{
            userDefaults.set("manual", forKey: "notificationCategory1")
        }
        //読み込みのとき
        //let userDefaults = UserDefaults.standard
        //.string(forKey: "notificationCategory1")
        //if (userDefaults.object(forKey: "notificationCategory1") != nil) {
        //print("データ有り")
        //}
    }
    
    var oldHours:Int = 1
    var oldHoursIndex:Int = 0
    var oldMinutes:Int = 1
    var oldMinutesIndex:Int = 0
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
