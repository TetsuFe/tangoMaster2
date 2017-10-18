//
//  AlphaManagePopUpVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/10/17.
//  Copyright © 2017年 Tetsu. All rights reserved.
//


enum ParentVCType{
    case problemVC
    case nigateListVC
    case listVC
}

import UIKit

class AlphaManagePopUpVC: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var alphaSettingsButton : UIButton!
    @IBAction func doneButton(_ sender: Any) {
        removeAnimate()
    }
    
    public static var parentVCType : ParentVCType?
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewAlphaManager = ViewAlphaManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        //ポップアップ処理のセット二行。ポップアップ以外部分を暗い透明にし、ポップアップ
        alphaSettingsButton.addTarget(self, action: #selector(pushedButtonButton), for: .touchUpInside)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        updateButtonImage()
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
                    switch AlphaManagePopUpVC.parentVCType!{
                    case .problemVC:
                        //親ビューに設定変更を適用
                        let parentViewController = self.parent as! ProblemVC
                        parentViewController.updateTransparency()

                    case .listVC:
                        //親ビューに設定変更を適用
                        let parentViewController = self.parent as! ListVC
                        parentViewController.updateTransparency()
                    case .nigateListVC:
                        //親ビューに設定変更を適用
                        let parentViewController = self.parent as! NigateListVC
                            parentViewController.updateTransparency()
                }
                
                self.view.removeFromSuperview()
 
            }
        });
    }
    
    
    @objc func pushedButtonButton(){
        print("push button button")
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
