//
//  LocalNotificationHomeVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/06/03.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class NotificationHomeVC: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate,UITableViewDataSource{

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
        
        //cancelButton.addTarget(self,action: #selector(cancelChangeDuration),for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var notificationDurationPicker: UIPickerView!
    
    @IBOutlet weak var notificationHomeTable: UITableView!
    
    //let notificationLabelNames = ["自由に選ぶ","苦手","自分で登録"]
    let notificationLabelNames = ["自由に選ぶ","苦手"]
    let imageNames = ["normallist.png","nigatelist.png"]
    
    
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
        if component == 0{
            UserDefaults.standard.set(row,forKey:NOTIFICATION_HOURS_INDEX_KEY)
            print("時の行は\(row)")
        }else{
            //if component == 1{
            UserDefaults.standard.set(row,forKey:NOTIFICATION_MINUTES_INDEX_KEY)
            print("分の行は\(row)")
        }
    }
    
    func readStoredDurationAndSetPicker(){
        if UserDefaults.standard.object(forKey: NOTIFICATION_HOURS_INDEX_KEY) != nil {
            notificationDurationPicker.selectRow(UserDefaults.standard.integer(forKey: NOTIFICATION_HOURS_INDEX_KEY), inComponent: 0, animated: true)
            //oldHours = UserDefaults.standard.integer(forKey: "notificationHours")
            oldHoursIndex = UserDefaults.standard.integer(forKey: NOTIFICATION_HOURS_INDEX_KEY)
        }else{
            UserDefaults.standard.set(0,forKey: NOTIFICATION_HOURS_INDEX_KEY)
            notificationDurationPicker.selectRow(UserDefaults.standard.integer(forKey: NOTIFICATION_HOURS_INDEX_KEY), inComponent: 0, animated: true)
           

        }
        if UserDefaults.standard.object(forKey: NOTIFICATION_MINUTES_INDEX_KEY) != nil {
            notificationDurationPicker.selectRow(UserDefaults.standard.integer(forKey: NOTIFICATION_MINUTES_INDEX_KEY), inComponent: 1, animated: true)
            //oldMinutes = UserDefaults.standard.integer(forKey: "notificationMinutes")
            oldMinutesIndex = UserDefaults.standard.integer(forKey: NOTIFICATION_MINUTES_INDEX_KEY)
        }else{
            UserDefaults.standard.set(0,forKey: NOTIFICATION_MINUTES_INDEX_KEY)
            notificationDurationPicker.selectRow(UserDefaults.standard.integer(forKey: NOTIFICATION_MINUTES_INDEX_KEY), inComponent: 1, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return notificationLabelNames.count
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        let cell: NotificationHomeSelectCell = notificationHomeTable.dequeueReusableCell(withIdentifier: "notificationHomeSelectCell") as! NotificationHomeSelectCell
        
        cell.setCell(notificationLabelNames[indexPath.row],imageNames[indexPath.row],notificationType: indexPath.row, parentTableView:notificationHomeTable, parentVC: self)
        return cell
    }
    
    //Cellが選択された際に呼び出される
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //func moveToSeleceVC(){
         print("notificaion home cell button tapped")
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.notificationSceneTag = indexPath.row
         var nextViewController = UIViewController()
         if indexPath.row == 0{
         
         nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "listForNotification") as! ListForNotificationVC
         }else if indexPath.row == 1{
         nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "nigateListForNotification") as! NigateListForNotificationVC
         
         }else if indexPath.row == 2{
         
         }else if indexPath.row == 3{
         //nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
         //self.present(nextViewController, animated: true, completion: nil)
         }
         self.navigationController?.pushViewController(nextViewController, animated: true)
         //選択時の色の変更をすぐ消す
         tableView.deselectRow(at: indexPath, animated: true)
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


//@IBOutlet weak var cancelButton: UIButton!
/*
 func cancelChangeDuration(){
 
 //let notificationHoursUserDefaults = UserDefaults.standard
 //notificationHoursUserDefaults.set(oldHours,forKey:"notificationHours")
 //let notificationHoursIndexUserDefaults = UserDefaults.standard
 //notificationHoursIndexUserDefaults.set(oldHoursIndex,forKey:"notificationHoursIndex")
 UserDefaults.standard.set(oldHoursIndex,forKey:NOTIFICATION_HOURS_INDEX_KEY)
 
 //let notificationMinutesUserDefaults = UserDefaults.standard
 //notificationMinutesUserDefaults.set(oldMinutes,forKey:"notificationMinutes")
 //let notificationMinutesIndexUserDefaults = UserDefaults.standard
 //notificationMinutesIndexUserDefaults.set(oldMinutesIndex,forKey:"notificationMinutesIndex")
 UserDefaults.standard.set(oldMinutesIndex,forKey:NOTIFICATION_MINUTES_INDEX_KEY)
 
 
 readStoredDurationAndSetPicker()
 }
 */


/*
 @IBAction func decideCategoryButton(_ sender: Any) {
 let userDefaults = UserDefaults.standard
 // -1は初期値。tableの中の何も選択していないとエラーにする
 if appDelegate.notificationSceneTag != -1{
 //アラートビューを使って「選択してください！」と警告する
 }else if appDelegate.notificationSceneTag == 0{
 userDefaults.set("normal", forKey: NOTIFICATION_TYPE_KEY)
 }else if appDelegate.notificationSceneTag == 1{
 userDefaults.set("nigate", forKey: NOTIFICATION_TYPE_KEY)
 }else if appDelegate.notificationSceneTag == 2{
 userDefaults.set("manual", forKey: NOTIFICATION_TYPE_KEY)
 }
 //読み込みのとき
 //let userDefaults = UserDefaults.standard
 //.string(forKey: "notificationCategory1")
 //if (userDefaults.object(forKey: "notificationCategory1") != nil) {
 //print("データ有り")
 //}
 }
 */

    
