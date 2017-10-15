//
//  NotificationHomeSelectCell.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/08.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationHomeSelectCell:UITableViewCell{
    
    private var notificationType:Int!
    private var parentVC:UIViewController!
    private var parentTableView:UITableView!
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var sectionImage: UIImageView!
    
    //@IBOutlet weak var moveToSeleceVCButton: UIButton!
    
    @IBOutlet weak var activateSwitch: UISwitch!
    
    func setCell(_ labelName:String,_ imageFileName:String, notificationType:Int, parentTableView:UITableView,parentVC:UIViewController) {
        self.notificationType = notificationType
        self.parentTableView = parentTableView
        self.parentVC = parentVC
        
        activateSwitch.addTarget(self, action: #selector(switchActivateOrDeactivate), for: .valueChanged)
        
        sectionLabel.text = labelName
        sectionImage.image = UIImage(named: imageFileName)
        if UserDefaults.standard.object(forKey:NOTIFICATION_TYPE_KEY) != nil{
            if self.notificationType == UserDefaults.standard.integer(forKey: NOTIFICATION_TYPE_KEY){
                activateSwitch.setOn(true, animated: false)
            }else{
                activateSwitch.setOn(false, animated: false)
            }
        }else{
            UserDefaults.standard.set(-1, forKey:NOTIFICATION_TYPE_KEY)
            activateSwitch.setOn(false, animated: false)
        }
    }
    
    @objc func switchActivateOrDeactivate(){
        //valueChangedで発火するので、switchの値は変化した後を考えればよい
        if UserDefaults.standard.object(forKey: NOTIFICATION_ISENABLED_KEY) == nil{
            UserDefaults.standard.set(false,forKey: NOTIFICATION_ISENABLED_KEY)
        }
        if #available(iOS 10.0, *) {
            //UNUserNotificationCenter.current().getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                //if requests.count > 0{
            if UserDefaults.standard.bool(forKey: NOTIFICATION_ISENABLED_KEY){
                if self.activateSwitch.isOn{
                    self.showActivateAlertView()
                }else{
                    self.showDeactivateAlertView()
                }
            }else{
                
                if self.activateSwitch.isOn{
                    self.prepareToActivateNotification()
                }else{
                    self.deactivateNotification()
                }
            }
        //}
        } else {
            //if let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications{
                //if scheduledNotifications.count > 0{
            if UserDefaults.standard.bool(forKey: NOTIFICATION_ISENABLED_KEY){
                    if self.activateSwitch.isOn{
                        self.showActivateAlertView()
                    }else{
                        self.showDeactivateAlertView()
                    }
                }else{
                    if self.activateSwitch.isOn{
                        self.prepareToActivateNotification()
                    }else{
                        self.deactivateNotification()
                    }
                }
            }
        //}
    }
    
    func deactivateNotification(){
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }else{
            UIApplication.shared.cancelAllLocalNotifications()
        }
        UserDefaults.standard.set(-1, forKey:NOTIFICATION_TYPE_KEY)
        self.parentTableView.reloadData()
    }
    
    func prepareToActivateNotification(){
        UserDefaults.standard.set(self.notificationType, forKey:NOTIFICATION_TYPE_KEY)
        showGuideNotificationTrigger()
        DispatchQueue.main.async() {
            self.parentTableView.reloadData()
        }
    }
    
    func showGuideNotificationTrigger(){
        if UserDefaults.standard.object(forKey: "GuideNotificationTrigger") == nil{
            UserDefaults.standard.set(true, forKey: "GuideNotificationTrigger")
        }
        if UserDefaults.standard.bool(forKey: "GuideNotificationTrigger"){
            let alert: UIAlertController = UIAlertController(title: "注意", message: "タイマーが始まるのはアプリ終了後です。今すぐタイマーを開始したい場合は、ホームボタンを押してアプリを終了させてください。", preferredStyle:  UIAlertControllerStyle.alert)
            
            // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            let doNotRepeatAction: UIAlertAction = UIAlertAction(title: "以降表示しない", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("以降表示しません")
                UserDefaults.standard.set(false, forKey: "GuideNotificationTrigger")
            })

            alert.addAction(defaultAction)
            alert.addAction(doNotRepeatAction)
            self.parentVC.present(alert, animated: true, completion: nil)
        }
    }
   
    
    func showActivateAlertView(){
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "現在設定済みのタイマーは上書きされます。続けますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.deactivateNotification()
            self.prepareToActivateNotification()
            UserDefaults.standard.set(false,forKey: NOTIFICATION_ISENABLED_KEY)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self.activateSwitch.setOn(false, animated: false)
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        DispatchQueue.main.async() {
            self.parentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func showDeactivateAlertView(){
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "現在設定済みのタイマーは解除されます。続けますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.deactivateNotification()
            UserDefaults.standard.set(false,forKey: NOTIFICATION_ISENABLED_KEY)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self.activateSwitch.setOn(true, animated: false)
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.parentVC.present(alert, animated: true, completion: nil)
    }
}
