//
//  CardSettingPopUpVC.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/03/01.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class CardSettingPopUpVC: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var swipeSettingButton: UIButton!
    @IBOutlet weak var buttonSettingButton: UIButton!
    @IBAction func doneButton(_ sender: Any) {
        removeAnimate()
    }
    
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        //ポップアップ処理のセット二行。ポップアップ以外部分を暗い透明にし、ポップアップ

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        print("appdelegate.cardSetting: \(appDelegate.cardMoveSetting)")
        swipeSettingButton.addTarget(self, action: #selector(pushedSwipeButton), for: .touchUpInside)
        
        buttonSettingButton.addTarget(self, action: #selector(pushedButtonButton), for: .touchUpInside)
        if(appDelegate.cardMoveSetting){
            swipeSettingButton.setImage(UIImage(named:"card_setting_pushed.png"), for: .normal)
            
            buttonSettingButton.setImage(UIImage(named: "card_setting_not_pushed.png"), for: .normal)

        }else{
            swipeSettingButton.setImage(UIImage(named:"card_setting_not_pushed.png"), for: .normal)
            
            buttonSettingButton.setImage(UIImage(named: "card_setting_pushed.png"), for: .normal)

        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                //あやビューに設定変更を適用
                if(self.appDelegate.cardMoveSetting){
                    if let parentViewController:CardVC = self.parent as! CardVC?{
                        parentViewController.leftSwipeButton.isEnabled = false
                        parentViewController.rightSwipeButton.isEnabled = false
                        parentViewController.leftSwipeButton.backgroundColor = UIColor.clear
                        parentViewController.rightSwipeButton.backgroundColor = UIColor.clear
                        
                    }
                }else{
                   if let parentViewController:CardVC = self.parent as! CardVC?{
                        parentViewController.leftSwipeButton.isEnabled = true
                        parentViewController.rightSwipeButton.isEnabled = true
                        parentViewController.leftSwipeButton.backgroundColor = UIColor.orange
                        parentViewController.rightSwipeButton.backgroundColor = UIColor.green
                    }
                }
                self.view.removeFromSuperview()
            }
        });
    }

    
    func pushedButtonButton(){
        print("push button button")

        appDelegate.cardMoveSetting = false

        swipeSettingButton.setImage(UIImage(named: "card_setting_not_pushed.png"), for: .normal)
        buttonSettingButton.setImage(UIImage(named: "card_setting_pushed.png"), for: .normal)
        
    }
    
    func pushedSwipeButton(){
        print("push swipe button")
        appDelegate.cardMoveSetting = true
        
        buttonSettingButton.setImage(UIImage(named: "card_setting_not_pushed.png"), for: .normal)
        swipeSettingButton.setImage(UIImage(named: "card_setting_pushed.png"), for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
