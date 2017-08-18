//
//  NotificationOrderSuffuler.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/19.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation

class NotificationOrderSuffuler{
    private var engJpnArray = Array<EngJpn>()
    
    init(engJpnArray:Array<EngJpn>){
        self.engJpnArray = engJpnArray
    }
    
    func suffule()->Array<EngJpn>{
        if UserDefaults.standard.bool(forKey: SHUFFLE_ENABLED_KEY){
            for i in 0..<self.engJpnArray.count{
                let rand = Int(arc4random_uniform(UInt32(self.engJpnArray.count)))
                let temp = self.engJpnArray[i]
                self.engJpnArray[i] = self.engJpnArray[rand]
                self.engJpnArray[rand] = temp
            }
            return self.engJpnArray
        }else{
            return self.engJpnArray
        }
    }
}
