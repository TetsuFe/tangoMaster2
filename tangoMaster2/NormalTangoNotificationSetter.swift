//
//  TangoNotificationSetter.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/08.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

//AppDelegateで使う通知設定の有効化を担うクラス
//通知に使いたい単語ファイル一覧から(init)、通知する単語を取得し、その単語を通知に登録する

class NormalTangoNotificationSetter{
    
    private var notificationFileNames:Array<String>
    private var notificationType:Int
    
    init(notificationFileNames:Array<String>,notificationType:Int){
        self.notificationFileNames = notificationFileNames
        self.notificationType = notificationType
    }
    
    func convertFileIntoTangoArray2D(notificationFileNames:Array<String>)->Array<Array<String>>{
        var wordArray2D = Array<Array<String>>()
        for notificationFileName in notificationFileNames{
            if self.notificationType == 0{
                wordArray2D.append(readFilegetTangoArray(notificationFileName, extent: "txt",inDirectory: "tango/seedtango"))
            }else if self.notificationType == 1{
                wordArray2D.append(getTangoArrayFromFile(fileName: notificationFileName))
            }else{
                
            }
        }
        return wordArray2D
    }
    
    func convertFileIntoTangoArray(notificationFileNames:Array<String>)->Array<String>{
        let tangoArray2D = convertFileIntoTangoArray2D(notificationFileNames:notificationFileNames)
        return transArrayDimension2to1(array2D: tangoArray2D)
    }
    
    //何分おきかの保存済みデータを読み取り
    func readNotificaionDurationUserDefault(notificationDurationKey:String="notificationMinutes")->Int{
        
        if UserDefaults.standard.integer(forKey: notificationDurationKey) == 0{
            UserDefaults.standard.set(1,forKey: notificationDurationKey)
        }
        let notificationDurationMinutes : Int = UserDefaults.standard.integer(forKey: notificationDurationKey)
        print(notificationDurationMinutes)
        print(UserDefaults.standard.integer(forKey: notificationDurationKey))
        return notificationDurationMinutes
    }
    
    //abstract English and Japanese word only  from  SixTangoArray
    func abstractEngJpnWord(sixTangoArray:Array<String>)->Array<EngJpn>{
        var engJpnArray = Array<EngJpn>()
        for r in 0..<sixTangoArray.count/6{
            //setNotification(engWord:sixTangoArray[6*r],jpnWord:sixTangoArray[6*r+1],index:count)
            engJpnArray.append(EngJpn(eng:sixTangoArray[6*r], jpn: sixTangoArray[6*r+1]))
        }
        return engJpnArray
    }
    
    /*
    //AppDelegateで使う どう使う？　とりあえず関数としては使わない？
    func setAllNotification(engJpnArray: Array<EngJpn>){
        for (i, engJpn) in engJpnArray.enumerated(){
            setNotification(engWord: engJpn.eng, jpnWord: engJpn.jpn, index: i)
        }
    }
    */
    
    @available(iOS, deprecated: 10.0)
    func setAllNotificationBeforeios10(application:UIApplication, durationHours:Int, durationMinutes:Int, engJpnArray: Array<EngJpn>){
        for (i, engJpn) in engJpnArray.enumerated(){
            setNotificationBeforeios10(application: application, durationHours: durationHours, durationMinutes: durationMinutes, engWord: engJpn.eng, jpnWord: engJpn.jpn, index: i)
        }
    }
    
    @available(iOS 10.0, *)
    func setAllNotificationAfterios10(durationHours:Int, durationMinutes:Int, engJpnArray: Array<EngJpn>){
        for (i, engJpn) in engJpnArray.enumerated(){
            setNotificationAfterios10(durationHours: durationHours, durationMinutes: durationMinutes,engWord: engJpn.eng, jpnWord: engJpn.jpn, index: i)
        }
    }

    @available(iOS 10.0, *)
    func setNotificationAfterios10(durationHours:Int, durationMinutes:Int, engWord:String,jpnWord:String,index:Int){
           let notificationRequest = getNotificationRequestAfterios10(titleText:engWord, bodyText:jpnWord, actionText1:"開く", actionText2:"通知削除", timerDuration:(index+1)*(3600*durationHours+60*durationMinutes), index:index)
            UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
    }
    
    @available(iOS, deprecated: 10.0)
    func setNotificationBeforeios10(application:UIApplication, durationHours:Int, durationMinutes:Int, engWord:String, jpnWord:String, index:Int){
        let localNotification = getNotificationBeforeios10(actionText:"アプリを開く", bodyText:engWord+": "+jpnWord, timerDuration:(index+1)*(3600*durationHours+60*durationMinutes), notifyID:String(index), index:index)
        application.scheduleLocalNotification(localNotification)
    }
    
    @available(iOS, deprecated: 10.0)
    func getNotificationBeforeios10(actionText:String, bodyText:String, timerDuration:Int, notifyID:String, index:Int)->UILocalNotification{
        //ローカル通知
        let notification = UILocalNotification()
        //ロック中にスライドで〜〜のところの文字
        notification.alertAction = actionText//"アプリを開く"など
        //通知の本文
        notification.alertBody = bodyText//"ごはんたべよう！"など
        //通知される時間（とりあえず10秒後に設定）
        notification.fireDate = NSDate(timeIntervalSinceNow:TimeInterval(timerDuration)) as Date
        //通知音
        //notification.soundName = UILocalNotificationDefaultSoundName //うるさいので削除
        //アインコンバッジの数字
        notification.applicationIconBadgeNumber = index+1
        //通知を識別するID
        notification.userInfo = ["notifyID":notifyID]
        return notification
    }
    
    
    @available(iOS 10.0, *)
    func getNotificationRequestAfterios10(titleText:String, bodyText:String, actionText1:String, actionText2:String, timerDuration:Int, index:Int)->UNNotificationRequest{
        enum ActionIdentifier: String {
            case attend
            case absent
        }
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: () -> Void) {
            
            //リファクタリングの余地あり。.attendとかでも書けるはず
            switch response.actionIdentifier {
            case ActionIdentifier.attend.rawValue:
                debugPrint("出席します")
            case ActionIdentifier.absent.rawValue:
                debugPrint("欠席します")
            default:
                ()
            }
            completionHandler()
        }
        
        let attend = UNNotificationAction(identifier: ActionIdentifier.attend.rawValue,
                                          title: actionText1, options: [])
        let absent = UNNotificationAction(identifier: ActionIdentifier.absent.rawValue,
                                          title: actionText2,
                                          options: [])
        let category = UNNotificationCategory(identifier: "message",actions: [attend, absent],intentIdentifiers: [],options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        
        content.title = titleText
        content.body = bodyText
        //content.sound = UNNotificationSound.default() うるさいので削除
        content.badge = NSNumber(value: index+1)

        // categoryIdentifierを設定
        content.categoryIdentifier = "message"
        
        // n*60秒後
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerDuration), repeats: false)
        print("timerDuration: \(timerDuration)")
        
        let request = UNNotificationRequest(identifier: "\(timerDuration)",
            content: content,
            trigger: trigger)
        return request
    }
}
