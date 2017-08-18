//
//  CreateOriginalListPopUpVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/08/16.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class CreateOriginalListPopUpVC: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var inputErrorLabel: UILabel!
    
    @IBOutlet weak var listNameTextField: UITextField!
    
    @IBAction func createButton(_ sender: Any) {
        if listNameTextField.text!.characters.count <= 15 && listNameTextField.text!.characters.count > 0{
            createOriginalListAsLine(newListName: listNameTextField.text!)
            removeAnimate()
        }else if listNameTextField.text!.characters.count > 15{
            inputErrorLabel.text = "文字数は１５文字以内にしてください"
            inputErrorLabel.textColor = UIColor.red
            inputErrorLabel.alpha = 1.0
        }else{
            inputErrorLabel.text = "リスト名が入力されていません"
            inputErrorLabel.textColor = UIColor.red
            inputErrorLabel.alpha = 1.0
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        removeAnimate()
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputErrorLabel.alpha = 0.0
        //ポップアップ処理のセット二行。ポップアップ以外部分を暗い透明にし、ポップアップ
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        print("appdelegate.cardSetting: \(appDelegate.canCardSwipe)")
        //textViewのキーボードを閉じるためのツールバー作成
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action:
            #selector(commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        //textViewのキーボードの上にバーを設置
        listNameTextField.inputAccessoryView = kbToolBar
        listNameTextField.layer.borderWidth = 1
    }
    
    //textViewのキーボードの閉じるボタンが押されたとき、キーボードを閉じる
    func commitButtonTapped (){
        self.view.endEditing(true)
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
                let parentVC = self.parent as! OriginalListForNotificationVC
                    parentVC.cells = parentVC.readOriginalTangoFile()
                parentVC.originalNotificationSelectTable.reloadData()
                self.view.removeFromSuperview()
            }
        });
    }
    
    func createOriginalListAsLine(newListName:String){
        writeFileWithExtent(fileName: ORIGINAL_LIST_FILE_NAME, text: newListName+"@"+"prev"+newListName+"@"+"1"+"\n",extent:"txt")
        copyFile(from: ORIGINAL_LIST_FILE_NAME, to: PREV_ORIGINAL_LIST_FILE_NAME, extent: "txt")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
