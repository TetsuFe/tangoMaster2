//
//  NewAutoFadeVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2017/01/04.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class AutoFadeVC: UIViewController {

    @IBOutlet weak var jpnLabel: UILabel!
    @IBOutlet weak var engLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    //@IBOutlet weak var tangoImage: UIImageView!
    @IBOutlet weak var speedButton: UIButton!
    
    @IBOutlet weak var reverseButton: UIButton!
    
    var fileName = String()
    var tango = Array<String>()
    
    //次のセットが呼ばれるまでの秒数。timerで管理
    var timerInterval = 5.5
    //画像、英語（音声）、日本語、消えるの４つで４秒と言えそうだがどうやらそうもいかない
    var fudeDuration = 1.0
    
    // goPrevChapter(_ sender: Any) {
    
    @IBAction func goPrevChapter(_ sender: Any) {

        //ボタンをタップした時に実行するメソッドを指定
        if(appDelegate.modeTag == 0){
            if(appDelegate.chapterNumber > 0){
                appDelegate.chapterNumber -= 1
                changeFile()
            }else if appDelegate.chapterNumber == 0{
                appDelegate.chapterNumber = testFileNamesArray[appDelegate.problemCategory].count-1
                changeFile()
            }
            
        }else if(appDelegate.modeTag == 1){
            if(appDelegate.chapterNumber != 0){
                if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber-1]) != 0{
                    appDelegate.chapterNumber -= 1
                    changeFile()
                }
            }
        }
        if self.count == sortedImageReibunArray.count-1 &&  sortedImageReibunArray.count != 1{
            self.count -= 1
            changeFile()
        }
        changeCategoryLabel()
    }
    
   // @IBAction func goNextChapter(_ sender: Any) {
    
    @IBAction func goNextChapter(_ sender: Any) {
    //ボタンをタップした時に実行するメソッドを指定
        if(appDelegate.modeTag == 0){
            if(appDelegate.chapterNumber < testFileNamesArray[appDelegate.problemCategory].count-1){
                appDelegate.chapterNumber += 1
                changeFile()
            }else{
                appDelegate.chapterNumber = 0
                changeFile()
            }
        }else if(appDelegate.modeTag == 1){
            //次のchapterを調べるので、次があることを確認する
            if(appDelegate.chapterNumber < testNigateFileNamesArray[appDelegate.problemCategory].count-1){
                if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber+1]) != 0{
                    appDelegate.chapterNumber += 1
                    changeFile()
                }
            }
        }
        if self.count == sortedImageReibunArray.count-1 &&  sortedImageReibunArray.count != 1{
            self.count -= 1
            changeFile()
        }
        changeCategoryLabel()
    }
    func changeCategoryLabel(){
        categoryLabel.text = sectionList[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
    }
    
    func  changeFile(){
        //タイマーinvalidate
        timer.invalidate()
        self.count = -1
        //ファイル読み込み
        var list = Array<Array<NewImageReibun>>(repeating: [],count: 26)
        
        if appDelegate.modeTag == 0{
            fileName = testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            tango = readFileGetWordArray(fileName, extent: "txt")
            for r in 0..<tango.count/6{
                let hash = getHashNum(tango[6*r])
                list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
            }
            print("tokui")
        }else if appDelegate.modeTag == 1{
            
            fileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            tango = getfile(fileName:fileName)
            for r in 0..<tango.count/6{
                //苦手だけを代入
                if(tango[6*r+4] == "1"){
                    let hash = getHashNum(tango[6*r])
                    list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
                }
            }
            
            print("nigate")
        }else {
            
        }
        sortedImageReibunArray = getArrayNIRFromList(list: list)
        //sortedImageReibunArray = deleteWordFromArray(eng:engLabel.text!,list2:sortedImageReibunArray)
        print(sortedImageReibunArray.count-1)
        
        //音声取得
        //表示
        self.engLabel.alpha = 0
        self.engLabel.isHidden = false
        self.jpnLabel.alpha = 0
        self.jpnLabel.isHidden = false
        //self.tangoImage.alpha = 0
        //self.tangoImage.isHidden = false
        //タイマーfire
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
        timer.fire()
    }
    
    func changeSpeed(){
        if timerInterval > 1.0{
            timerInterval -= 0.5
            self.fudeDuration -= 0.1
            
        }else{
            timerInterval = 5.0
            self.fudeDuration = 1.0
        }
        speedButton.setTitle("速さ:\(timerInterval)", for: .normal)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
        timer.fire()
    }
   
    var timer = Timer()
    var count = -1
    var flag = true
    
    var sortedImageReibunArray : Array<NewImageReibun> = []
    
    //stopButton(_ sender: AnyObject)
    
    @IBOutlet weak var stopOrPlayButton: UIButton!
    
    func stopOrPlay(){
        if(timer.isValid){
            flag = false
            stopOrPlayButton.setTitle("停止中", for: .normal)
            //self.tangoImage.layer.removeAllAnimations()
            self.engLabel.layer.removeAllAnimations()
            self.jpnLabel.layer.removeAllAnimations()
            timer.invalidate()
        }
        else{
            flag = true
            stopOrPlayButton.setTitle("再生中", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
            timer.fire()
            
            print("fire!")
        }
    }
    
    @IBAction func goPrev(_ sender: AnyObject) {
        if(self.count > 0){
            flag = false
            //self.tangoImage.layer.removeAllAnimations()
            self.engLabel.layer.removeAllAnimations()
            self.jpnLabel.layer.removeAllAnimations()
            timer.invalidate()
            self.engLabel.alpha = 0
            self.engLabel.isHidden = false
            self.jpnLabel.alpha = 0
            self.jpnLabel.isHidden = false
            //self.tangoImage.alpha = 0
            //self.tangoImage.isHidden = false
            self.count -= 2
            flag = true
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
            timer.fire()
        }
    }
    
    @IBAction func goNext(_ sender: AnyObject) {
        if(self.count < sortedImageReibunArray.count-1){
            flag = false
            //self.tangoImage.layer.removeAllAnimations()
            self.engLabel.layer.removeAllAnimations()
            self.jpnLabel.layer.removeAllAnimations()
            timer.invalidate()
            self.engLabel.alpha = 0
            self.engLabel.isHidden = false
            self.jpnLabel.alpha = 0
            self.jpnLabel.isHidden = false
            //self.tangoImage.alpha = 0
            //self.tangoImage.isHidden = false
            flag = true
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
            timer.fire()
        }
    }
    
    var direction:Int = 1
    
    func update() {
        if(self.count < sortedImageReibunArray.count-1){
            self.count += self.direction
            self.engLabel.text = self.sortedImageReibunArray[self.count].eng!
            self.jpnLabel.text = self.sortedImageReibunArray[self.count].jpn!
            //self.tangoImage.image = UIImage(named:self.sortedImageReibunArray[self.count].imgPath!)
        }
        
        UIView.animate(
            withDuration: fudeDuration,
            animations: {
                if(self.flag == false){
                    return
                }
                //self.tangoImage.alpha = 1
        },completion: {(finished:Bool) in
            if(self.flag == false){
                return
            }
            UIView.animate(
                withDuration: self.fudeDuration,
                animations: {
                    self.engLabel.alpha = 1
            },completion: {(finished:Bool) in
                if(self.flag == false){
                    return
                }
                UIView.animate(
                    withDuration: self.fudeDuration,
                    animations: {
                        self.jpnLabel.alpha = 1
                },completion:{(finished:Bool)   in
                    if(self.flag == false){
                        return
                    }
                    UIView.animate(
                        withDuration:self.fudeDuration,
                        delay:self.fudeDuration,
                        animations:{
                            self.engLabel.alpha = 0
                            self.engLabel.isHidden = false
                            self.jpnLabel.alpha = 0
                            self.jpnLabel.isHidden = false
                            //self.tangoImage.alpha = 0
                            //self.tangoImage.isHidden = false
                    })
                })
            })
        })
        
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "問題選択画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            var secondViewController = UIViewController()
            if(self.appDelegate.autoFadeTag == 0){
                secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newList") as! ListVC
                
            }else if(self.appDelegate.autoFadeTag == 1){
                secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newMyList") as! NigateListVC
            }else{
                
            }
            // Viewの移動する.
            self.present(secondViewController, animated: true, completion: nil)
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    let chapterNames = [beginnerChapterNames,intermidChapterNames]
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //let chapterNumber = appDelegate.chapterNumber
        var list = Array<Array<NewImageReibun>>(repeating: [],count: 26)
        if appDelegate.modeTag == 0{
            fileName = testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            tango = readFileGetWordArray(fileName, extent: "txt")
            
            print("tokui")
        }else if appDelegate.modeTag == 1{
            fileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            tango = getfile(fileName:fileName)
            print("nigate")
        }else{
            
        }
        for r in 0..<tango.count/6{
            let hash = getHashNum(tango[6*r])
            //print(hash)
            list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
        }
        
        
        sortedImageReibunArray = getArrayNIRFromList(list: list)
        //sortedImageReibunArray = deleteWordFromArray(eng:engLabel.text!,list2:sortedImageReibunArray)
        print(sortedImageReibunArray.count-1)
        self.engLabel.alpha = 0
        self.engLabel.isHidden = false
        self.jpnLabel.alpha = 0
        self.jpnLabel.isHidden = false
        //self.tangoImage.alpha = 0
        //self.tangoImage.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
        timer.fire()
        
        speedButton.layer.borderWidth = 0
        speedButton.layer.cornerRadius = 10
        speedButton.addTarget(self, action: #selector
            (changeSpeed), for: .touchUpInside)
        reverseButton.layer.borderWidth = 0
        reverseButton.layer.cornerRadius = 10
        reverseButton.addTarget(self, action: #selector
            (reverse), for: .touchUpInside)
        
        categoryLabel.text = sectionList[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
        
        stopOrPlayButton.setTitle("再生中", for: .normal)
        stopOrPlayButton.addTarget(self, action: #selector(stopOrPlay), for: .touchUpInside)
    }
    
    func reverse(){
        self.direction *= -1
        if self.direction == -1{
            reverseButton.setTitle("逆再生中", for: .normal)
        }else{
            reverseButton.setTitle("順再生中", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
