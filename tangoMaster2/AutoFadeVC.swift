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
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var stopOrPlayButton: UIButton!
    
    
    var fileName = String()
    var tango = Array<String>()
    
    //次のセットが呼ばれるまでの秒数。timerで管理
    var timerInterval = 5.5
    //画像、英語（音声）、日本語、消えるの４つで４秒と言えそうだがどうやらそうもいかない
    var fudeDuration = 1.0
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var nigateExistingFileNames = Array<String>()
    
    var nigate2FileIndex:Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var list = Array<Array<NewImageReibun>>(repeating: [],count: 26)
        if appDelegate.modeTag == 0{
            fileName = NORMAL_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber]
            tango = readFilegetTangoArray(fileName, extent: "txt",inDirectory: "tango/seedtango")
            
            print("tokui")
        }else if appDelegate.modeTag == 1{
            appDelegate.setsuNumber = 0
            fileName = NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber]
            tango = getTangoArrayFromFile(fileName:fileName)
            print("nigate")
        } //苦手chpaterの全範囲のProblem
        else if appDelegate.modeTag == 2{
            for setsu in 0..<5{
                for chapter in 0..<NIGATE_FILE_NAMES[appDelegate.problemCategory].count/5{
                    if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][chapter*5+setsu]) != 0{
                        
                        nigateExistingFileNames.append(NIGATE_FILE_NAMES[appDelegate.problemCategory
                            ][chapter*5+setsu])
                        /*
                        let tempTango = getTangoArrayFromFile(fileName:fileName)
                        for j in tempTango{
                            print(j)
                        }
                        tango = tango + tempTango
 */
                    }
                }
            }
            /*
            for j in tango{
                print(j)
            }
 */
            fileName = nigateExistingFileNames[0]
            tango = getTangoArrayFromFile(fileName: fileName)
        }else{
            
        }
        
        //tangoが0だった時の例外処理
        if(tango.count == 0){
            //emptyArrayError()
        }
        
        for r in 0..<tango.count/6{
            let hash = getHashNum(tango[6*r])
            //print(hash)
            list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
        }
        
        
        sortedImageReibunArray = getArrayNIRFromList(list: list)
        print(sortedImageReibunArray.count-1)
        self.engLabel.alpha = 0
        self.engLabel.isHidden = false
        self.jpnLabel.alpha = 0
        self.jpnLabel.isHidden = false

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
        
        if(appDelegate.modeTag != 2){
        categoryLabel.text = categoryNames[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]+"-"+String(appDelegate.setsuNumber+1)
        }else{
            //categoryLabel.text =  categoryNames[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]+"-苦手"
            categoryLabel.text =  categoryNames[appDelegate.problemCategory]+" "+"chapter"+nigateExistingFileNames[0].substring(from: nigateExistingFileNames[0].index(nigateExistingFileNames[0].startIndex,offsetBy:4))
        }
        
        //stopOrPlayButton.title("一時停止")
        speedButton.title = "速さ:\(timerInterval)"
        stopOrPlayButton.addTarget(self, action: #selector(stopOrPlay), for: .touchUpInside)
    }
    
    /*空のときはautofadeに入れないので必要ない
     func emptyArrayError(){
     // ① UIAlertControllerクラスのインスタンスを生成
     let alert: UIAlertController = UIAlertController(title: "エラー", message: "苦手リストに単語がありません。ホーム画面に戻ります。", preferredStyle:  UIAlertControllerStyle.alert)
     
     // ② Actionの設定
     // OKボタン
     let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
     // ボタンが押された時の処理を書く（クロージャ実装）
     (action: UIAlertAction!) -> Void in
     print("OK")
     var secondViewController = UIViewController()
     if(self.appDelegate.modeTag == 0){
     secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newList") as! ListVC
     
     }else{
     secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newMyList") as! NigateListVC
     }
     // Viewの移動する.
     self.present(secondViewController, animated: true, completion: nil)
     
     })
     alert.addAction(defaultAction)
     
     present(alert, animated: true, completion: nil)
     }
     */
    var direction:Int = 1
    
    func update() {
        if self.direction == 1{
            //順再生のとき
            if(self.count < sortedImageReibunArray.count-1){
                self.count += self.direction
            }
        }else{
            //逆再生のとき。out of rangeに注意
            if(self.count > 0){
                self.count += self.direction
            }
        }
        self.engLabel.text = self.sortedImageReibunArray[self.count].eng!
        self.jpnLabel.text = self.sortedImageReibunArray[self.count].jpn!
        progress.text = String(count+1) + "/" + String(sortedImageReibunArray.count)
        
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
    
    func reverse(){
        self.direction *= -1
        if self.direction == -1{
            reverseButton.title = "順再生に"
        }else{
            reverseButton.title = "逆再生に"
        }
    }
    
    @IBAction func goPrevChapter(_ sender: Any) {
        if(appDelegate.modeTag != 2){
            //ボタンをタップした時に実行するメソッドを指定
            if(appDelegate.modeTag == 0){
                if appDelegate.chapterNumber*5+appDelegate.setsuNumber > 0{
                    if appDelegate.setsuNumber == 0{
                        appDelegate.setsuNumber = 4
                        appDelegate.chapterNumber -= 1
                    }else{
                        appDelegate.setsuNumber -= 1
                    }
                    changeFile()
                }else if appDelegate.chapterNumber*5+appDelegate.setsuNumber == 0{
                    appDelegate.chapterNumber = chapterNames[appDelegate.problemCategory].count-1
                    appDelegate.setsuNumber = 4
                    changeFile()
                }
                
            }else if(appDelegate.modeTag == 1){
                if(appDelegate.chapterNumber*5+appDelegate.setsuNumber != 0){
                    while(true){
                        if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber-1]) != 0{
                            if appDelegate.setsuNumber == 0{
                                appDelegate.setsuNumber = 4
                                appDelegate.chapterNumber -= 1
                            }else{
                                appDelegate.setsuNumber -= 1
                            }
                            changeFile()
                            break
                        }else{
                            if appDelegate.setsuNumber == 0{
                                appDelegate.setsuNumber = 4
                                appDelegate.chapterNumber -= 1
                            }else{
                                appDelegate.setsuNumber -= 1
                            }
                        }
                    }
                }else{
                    //nigateMode == 2
                    
                }
            }
            /*
            if self.count == sortedImageReibunArray.count-1 && sortedImageReibunArray.count != 1{
                self.count -= 1
                changeFile()
            }
 */
            
        }else{
            if nigate2FileIndex > 0{
                nigate2FileIndex -= 1
                changeFile()
            }else{
                nigate2FileIndex = nigateExistingFileNames.count-1
                changeFile()
            }
        }
        changeCategoryLabel()
    }
    
    @IBAction func goNextChapter(_ sender: Any) {
        //ボタンをタップした時に実行するメソッドを指定
        if(appDelegate.modeTag != 2){
            if(appDelegate.modeTag == 0){
                if(appDelegate.chapterNumber < chapterNames[appDelegate.problemCategory].count-1){
                    if appDelegate.setsuNumber == 4{
                        appDelegate.setsuNumber = 0
                        appDelegate.chapterNumber += 1
                    }else{
                        appDelegate.setsuNumber += 1
                    }
                    changeFile()
                }else{
                    appDelegate.chapterNumber = 0
                    appDelegate.setsuNumber = 0
                    changeFile()
                }
            }else if(appDelegate.modeTag == 1){
                //次のchapterを調べるので、次があることを確認する
                if(appDelegate.chapterNumber*5+appDelegate.setsuNumber != chapterNames[appDelegate.problemCategory].count-1){
                    while(true){
                        if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber+1]) != 0{
                            if appDelegate.setsuNumber == 4{
                                appDelegate.setsuNumber = 0
                                appDelegate.chapterNumber += 1
                            }else{
                                appDelegate.setsuNumber += 1
                            }
                            changeFile()
                            break
                        }else{
                            if appDelegate.setsuNumber == 4{
                                appDelegate.setsuNumber = 0
                                appDelegate.chapterNumber += 1
                            }else{
                                appDelegate.setsuNumber += 1
                            }
                        }
                    }
                
                }/*
                if(appDelegate.chapterNumber < chapterNames[appDelegate.problemCategory].count-1){
                    if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber+1]) != 0{
                        appDelegate.chapterNumber += 1
                        changeFile()
                    }
                }
 */
            }
            /*
            if self.count == sortedImageReibunArray.count-1 && sortedImageReibunArray.count != 1{
                self.count -= 1
                changeFile()
            }
 */
            
        }else{
            if nigate2FileIndex < nigateExistingFileNames.count-1{
                nigate2FileIndex += 1
                changeFile()
            }else{
                nigate2FileIndex = 0
                changeFile()
            }
        }
        changeCategoryLabel()
    }
    
    
    func changeCategoryLabel(){
        
        if appDelegate.modeTag != 2{
            categoryLabel.text = categoryNames[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]+"-"+String(appDelegate.setsuNumber+1)
        }else{
            categoryLabel.text =  categoryNames[appDelegate.problemCategory]+" "+"chapter"+nigateExistingFileNames[nigate2FileIndex].substring(from: nigateExistingFileNames[nigate2FileIndex].index(nigateExistingFileNames[nigate2FileIndex].startIndex,offsetBy:4))
        }
    }
    
    func  changeFile(){
        //タイマーinvalidate
        timer.invalidate()
        self.count = -1
        //ファイル読み込み
        var list = Array<Array<NewImageReibun>>(repeating: [],count: 26)
        
        if appDelegate.modeTag == 0{
            fileName = NORMAL_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber]
            tango = readFilegetTangoArray(fileName, extent: "txt",inDirectory: "tango/seedtango")
            for r in 0..<tango.count/6{
                let hash = getHashNum(tango[6*r])
                list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
            }
            print("tokui")
        }else if appDelegate.modeTag == 1{
            
            fileName = NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber]
            tango = getTangoArrayFromFile(fileName:fileName)
            for r in 0..<tango.count/6{
                //苦手だけを代入
                if(tango[6*r+4] == "1"){
                    let hash = getHashNum(tango[6*r])
                    list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
                }
            }
            
            print("nigate")
        }else {
            
            fileName = nigateExistingFileNames[nigate2FileIndex]
            tango = getTangoArrayFromFile(fileName:fileName)
            for r in 0..<tango.count/6{
                //苦手だけを代入
                if(tango[6*r+4] == "1"){
                    let hash = getHashNum(tango[6*r])
                    list[hash] = addListNIR(list: list,eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5])
                }
            }

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
        speedButton.title = "速さ:\(timerInterval)"
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
        timer.fire()
    }
    
    var timer = Timer()
    var count = -1
    var flag = true
    
    var sortedImageReibunArray : Array<NewImageReibun> = []
    
    func stopOrPlay(){
        if(timer.isValid){
            flag = false
            stopOrPlayButton.title = "再生"
            //self.tangoImage.layer.removeAllAnimations()
            self.engLabel.layer.removeAllAnimations()
            self.jpnLabel.layer.removeAllAnimations()
            //停止時に全ラベルを表示状態に
            self.engLabel.alpha = 1
            self.jpnLabel.alpha = 1
            timer.invalidate()
        }
        else{
            flag = true
            stopOrPlayButton.title = "一時停止"
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target:self, selector:#selector(update), userInfo:nil, repeats: true)
            timer.fire()
            //再生開始時には全ラベルを非表示の状態にし、そこからアニメーションスタート
            self.engLabel.alpha = 0
            self.jpnLabel.alpha = 0
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
    
    @IBAction func backButton(_ sender: AnyObject) {
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "単語リストに戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            //var secondViewController = UIViewController()
            /*
            if(self.appDelegate.modeTag == 0){
                secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newList") as! ListVC
            }else{
                secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newMyList") as! NigateListVC
            }
 
            // Viewの移動する.
            self.present(secondViewController, animated: true, completion: nil)
 */
            self.dismiss(animated: true, completion: nil)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
