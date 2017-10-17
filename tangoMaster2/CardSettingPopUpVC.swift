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
    
    @IBOutlet weak var alphaSettingsButton: UIButton!
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewAlphaManager = ViewAlphaManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        //ポップアップ処理のセット二行。ポップアップ以外部分を暗い透明にし、ポップアップ

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        print("appdelegate.cardSetting: \(appDelegate.canCardSwipe)")
        swipeSettingButton.addTarget(self, action: #selector(pushedSwipeButton), for: .touchUpInside)
        
        buttonSettingButton.addTarget(self, action: #selector(pushedButtonButton), for: .touchUpInside)
        if(appDelegate.canCardSwipe){
            swipeSettingButton.setImage(UIImage(named:"card_setting_pushed.png"), for: .normal)
            
            buttonSettingButton.setImage(UIImage(named: "card_setting_not_pushed.png"), for: .normal)

        }else{
            swipeSettingButton.setImage(UIImage(named:"card_setting_not_pushed.png"), for: .normal)
            
            buttonSettingButton.setImage(UIImage(named: "card_setting_pushed.png"), for: .normal)

        }
        updateButtonImage()
        alphaSettingsButton.addTarget(self, action: #selector(pushedAlphaSettingsButton), for: .touchUpInside)
        self.showAnimate()
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
                if(self.appDelegate.canCardSwipe){
                    if let parentViewController:CardVC = self.parent as! CardVC?{
                        parentViewController.leftSwipeButton.isEnabled = false
                        parentViewController.rightSwipeButton.isEnabled = false
                        parentViewController.leftSwipeButton.backgroundColor = UIColor.clear
                        parentViewController.rightSwipeButton.backgroundColor = UIColor.clear
                        parentViewController.updateTransparency()
                        
                    }
                }else{
                   if let parentViewController:CardVC = self.parent as! CardVC?{
                        parentViewController.leftSwipeButton.isEnabled = true
                        parentViewController.rightSwipeButton.isEnabled = true
                        parentViewController.leftSwipeButton.backgroundColor = UIColor.orange
                        parentViewController.rightSwipeButton.backgroundColor = UIColor(red:  0.225346 ,green: 0.870325, blue: 0.104825, alpha: 1)
                    }
                }
                self.view.removeFromSuperview()
            }
        });
    }

    
    @objc func pushedButtonButton(){
        print("push button button")

        appDelegate.canCardSwipe = false

        swipeSettingButton.setImage(UIImage(named: "card_setting_not_pushed.png"), for: .normal)
        buttonSettingButton.setImage(UIImage(named: "card_setting_pushed.png"), for: .normal)
        
    }
    
    @objc func pushedSwipeButton(){
        print("push swipe button")
        appDelegate.canCardSwipe = true
        
        buttonSettingButton.setImage(UIImage(named: "card_setting_not_pushed.png"), for: .normal)
        swipeSettingButton.setImage(UIImage(named: "card_setting_pushed.png"), for: .normal)
        
    }
    
    @objc func pushedAlphaSettingsButton(){
        print("push button")
        viewAlphaManager.switchTransparentSetting()
        updateButtonImage()
    }
    
    func updateButtonImage(){
        if(viewAlphaManager.getTransparentSetting()){
            alphaSettingsButton.setImage(UIImage(named:"card_setting_pushed.png"), for: .normal)
        }else{
            alphaSettingsButton.setImage(UIImage(named:"card_setting_not_pushed.png"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
