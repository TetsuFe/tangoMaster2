//
//  AppDelegate.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/01/06.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate {
    
    var window: UIWindow?
    var chapterNumber:Int = 0
    var sectionName:String = ""
    var problemVolume:Int = 20
    //var problemStartPoint:Int = 0
    var problemCategory:Int = 0
    var sectionNumber:Int = 0
    var sceneTag:Int = 0
    var modeTag:Int = 0
    var cardMoveSetting:Bool = true
    //imagelist:0 mylist: 1
    // var audioSession : AVAudioSession = AVAudioSession.sharedInstance()
    
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
        // Override point for customization after application launch.
        return true
    }
    /*
     func applicationWillResignActive(_ application: UIApplication) {
     // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     }
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        }
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
