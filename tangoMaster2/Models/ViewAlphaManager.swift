//
//  ViewAlphaManager.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/10/17.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation

struct ViewAlphaManager{
    let IS_TRANSPARENT_KEY = "is_transparent_key"
    func switchTransparentSetting(){
        //現在の設定を反転させる
        UserDefaults.standard.set(!getTransparentSetting(), forKey: IS_TRANSPARENT_KEY)
    }
    func getTransparentSetting()->Bool{
        //未設定時は、falseが返る。
        return UserDefaults.standard.bool(forKey: IS_TRANSPARENT_KEY)
    }
}
