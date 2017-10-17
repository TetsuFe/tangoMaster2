//
//  BackgroundImageViewManager.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/10/16.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

func fitWidthOfImageView(changingImageView: UIImageView, parentView:UIView){
    // 画像の幅・高さの取得
    let imageViewWidth = changingImageView.frame.width
    let imageViewHeight = changingImageView.frame.height
    let screenWidth = parentView.frame.width
    let screenHeight = parentView.frame.height
    
    let tempScale = screenWidth/imageViewWidth
    let rect:CGRect = CGRect(x:0, y:0, width:tempScale*imageViewWidth, height:tempScale*imageViewHeight)
    // ImageView frame をCGRectで作った矩形に合わせる
    changingImageView.frame = rect
    if imageViewHeight > screenHeight{
        changingImageView.frame.origin = CGPoint(x:0,y:0)
    }else{
        // 画像の中心をスクリーンの中心位置に設定
        changingImageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
    }
}
