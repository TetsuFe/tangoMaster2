//
//  StorySelectVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/10/29.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class StorySelectVC: UIViewController {

    
    // デバイスの向きを強制的に横画面に
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
