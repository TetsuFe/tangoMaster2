//
//  AppDelegate.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/01/06.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

extension AppDelegate:UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラート&音で通知
        completionHandler([.alert])
    }
}

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate {
    
    var window: UIWindow?
    var chapterNumber:Int = 0
    var sectionName:String = ""
    var problemVolume:Int = 20
    //var problemStartPoint:Int = 0
    var problemCategory:Int = 0
    var setsuNumber:Int = 0
    var sceneTag:Int = 0
    var modeTag:Int = 0
    var canCardSwipe:Bool = true
    var isProblemCleared:Bool = false
    var notificationSceneTag: Int = -1
    var originalFileName = String()
    var photoLibraryImage : UIImage!
    //imagelist:0 mylist: 1
    // var audioSession : AVAudioSession = AVAudioSession.sharedInstance()
    
    var flag = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // try! audioSession.setActive(true)
       
        /*バックグラウンド小さい音
        let audioSession : AVAudioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)
        try! audioSession.setActive(true)
        */
       
        /*
         try! audioSession.setCategory(AVAudioSessionCategoryAmbient)
         try! audioSession.setActive(true)
         
         // observer追加
         audioSession.addObserver(self, forKeyPath: "outputVolume",
         options: NSKeyValueObservingOptions.new, context: nil)
         print(audioSession.outputVolume)
         */

        //すでに通知が設定済みであれば、通知が被らないように、NOTIFICATION_TYPE_KEYに-1（本アプリでは、アプリ終了時に-1の場合、通知を設定しないようになっている）を設定する
        /*
        if UserDefaults.standard.object(forKey: NOTIFICATION_TYPE_KEY) != nil{
            if UserDefaults.standard.integer(forKey: NOTIFICATION_TYPE_KEY) != -1{
                UserDefaults.standard.set(-1, forKey: NOTIFICATION_TYPE_KEY)
            }
        }
 */
        
        //通知許可・不許可かをユーザに選んでもらう
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    debugPrint("通知許可")
                    UNUserNotificationCenter.current().delegate = self
                } else {
                    debugPrint("通知拒否")
                }
            })
            
        } else {
            // iOS 9
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //通知バッジを0に初期化
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //有効なのか、無効なのかを取得
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                if requests.count > 0{
                    return
                }else{
                    self.validateNotification()
                }
            }
        } else {
            if let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications{
                if scheduledNotifications.count > 0{
                    return
                }else{
                    validateNotification()
                }
            }
        }
        //単語ファイルー＞単語
        //単語ー＞[英語・日本語]
        //[英語・日本語]ー＞通知の設定
        //tangoNotificationSetter.setNotification(engWord:String,jpnWord:String,index:Int)
    }
    
    func validateNotification(){
        let notificationType = UserDefaults.standard.integer(forKey: NOTIFICATION_TYPE_KEY)
        if notificationType != -1{
            //普通リスト・苦手リスト・カスタムのどれかを判別
            var notificationFileNames = Array<String>()
            if notificationType < 2{
                //UserDefaultでもともと保存しておいたものを使用
                let maskFileName = NOTIFICATION_MASK_FILE_NAMES[notificationType]
                //maskから単語ファイル集に変換　：　どのクラスだっけか
                let tangoNotificationMaskLoader = TangoNotificationMaskLoader(maskFileName: maskFileName)
                let notificationMask = tangoNotificationMaskLoader.readNotificationFileMask()
                print("mask: \(notificationMask)")
                notificationFileNames = tangoNotificationMaskLoader.convertMaskToNotificationFileName(notificationType: notificationType, maskString: notificationMask)
            }else{
                let fileStatuses = getTangoArrayFromFile(fileName: ORIGINAL_LIST_FILE_NAME)
                for r in 0..<fileStatuses.count/3{
                    if fileStatuses[3*r+2] == "1"{
                        notificationFileNames.append(fileStatuses[3*r])
                    }
                }
            }
            let tangoNotificationSetter = NormalTangoNotificationSetter(notificationFileNames: notificationFileNames, notificationType: notificationType)
            for fileName in notificationFileNames{
                print("f: \(fileName)")
            }
            let tangoArray = tangoNotificationSetter.convertFileIntoTangoArray(notificationFileNames: notificationFileNames)
            print("tangoArray.count: \(tangoArray.count)")
            var engJpnArray = Array<EngJpn>()
            if notificationType < 2{
                engJpnArray = tangoNotificationSetter.abstractEngJpnWord(sixTangoArray: tangoArray)
            }else{
                engJpnArray = tangoNotificationSetter.abstractEngJpnWord(originalThreeTangoArray: tangoArray)
            }
            //シャッフル？
            engJpnArray = NotificationOrderSuffuler(engJpnArray:engJpnArray).suffule()
            let durationHoursIndex = UserDefaults.standard.integer(forKey: NOTIFICATION_HOURS_INDEX_KEY)
            let durationMinutesIndex = UserDefaults.standard.integer(forKey: NOTIFICATION_MINUTES_INDEX_KEY)
            let durationHours = hoursList[durationHoursIndex]
            let durationMinutes = minutesList[durationMinutesIndex]
            if #available(iOS 10.0, *){
                tangoNotificationSetter.setAllNotificationAfterios10(durationHours: durationHours,durationMinutes: durationMinutes, engJpnArray:engJpnArray)
            }else{
                tangoNotificationSetter.setAllNotificationBeforeios10(application:UIApplication.shared, durationHours: durationHours,durationMinutes: durationMinutes, engJpnArray:engJpnArray)
            }
            UserDefaults.standard.set(true,forKey: NOTIFICATION_ISENABLED_KEY)
        }
    }
    
    
    //var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    func applicationWillResignActive(_ application: UIApplication) {
        /*
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        }
 */
    }
 
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
