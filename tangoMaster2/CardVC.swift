//
//  NewCardVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class CardVC: UIViewController {
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var goProblemButton: UIButton!
    @IBOutlet weak var goNigateProblemButton: UIButton!
    @IBOutlet weak var leftSwipeButton: UIButton!
    @IBOutlet weak var rightSwipeButton: UIButton!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var superCardView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func backButton2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var sevenDatas = Array<SixWithChapter>()
    var cardWorkFlag:Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        newChapterNumber = getNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], chapterVolume: fileNames[appDelegate.problemCategory].count)

        var fileName = String()
       
        if(appDelegate.modeTag == 0){
            fileName = fileNames[appDelegate.problemCategory][appDelegate.chapterNumber]
            cardDatas = getAllTangos(fileName:fileName)
        }else if appDelegate.modeTag == 1{
            fileName = nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber]
            let tangos = getfile(fileName: fileName)
            for r in 0..<tangos.count/6{
                cardDatas.append(NewImageReibun(eng: tangos[6*r],jpn:tangos[6*r+1],engReibun:tangos[6*r+2],jpnReibun:tangos[6*r+3],nigateFlag:tangos[6*r+4],partOfSpeech:tangos[6*r+5]))
            }
        }else if appDelegate.modeTag == 2{
            var tango = Array<String>()
            //chpaterNumber
            for i in 0..<2{
                let fileName = nigateFileNames[appDelegate.problemCategory
                    ][i]
                let tempTango = getfile(fileName:fileName)
                for j in tempTango{
                    print(j)
                }
                tango = tango + tempTango
                for r in 0..<tempTango.count/6{
                    sevenDatas.append(SixWithChapter(eng: tempTango[6*r],jpn:tempTango[6*r+1],engReibun:tempTango[6*r+2],jpnReibun:tempTango[6*r+3],nigateFlag: tempTango[6*r+4],partOfSpeech:tempTango[6*r+5],chapterNumber:String(i)))
                }
            }
            for j in tango{
                print(j)
            }
        }else{
            
        }
        
        //sevendata,cardDataの苦手追加・削除のためのコピーリストの作成

        //テスト中なので、とりあえず、ファイルの全てを取れるようにしておく。基本、苦手もファイル名が変わるだけで形式は同じ
        //苦手配列の英語と同じ英語に苦手ラベルづけ
        let nigateArray:Array<String> = getfile(fileName: nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber])
        for r in 0..<nigateArray.count/6{
            if nigateArray[6*r+4] == "1"{
                for i in 0..<cardDatas.count{
                    if(nigateArray[6*r] == cardDatas[i].eng){
                        cardDatas[i].nigateFlag = "1"
                    }
                }
            }
        }

        //sevenDataに対しても同じように苦手ラベルをつける？必要ないきがするのでとりあえずこれはしない
        
        if(appDelegate.modeTag != 2){
            initialListCount = cardDatas.count
        
            self.listcount = cardDatas.count
            for _ in 0..<cardDatas.count {
                self.cardViews.append(UIView())
                self.myLabels.append(UILabel())
                self.myLabels2.append(UILabel())
                self.nigateButtons.append(UIButton())
            }
        }else{
            initialListCount = sevenDatas.count
            
            
            self.listcount = sevenDatas.count
            for _ in 0..<sevenDatas.count {
                self.cardViews.append(UIView())
                self.myLabels.append(UILabel())
                self.myLabels2.append(UILabel())
                self.nigateButtons.append(UIButton())
            }

        }
        
        if(appDelegate.modeTag != 2){
            for i in 0..<cardDatas.count {
                makeCardWithNigateStar(cardView: cardViews[listcount-1-i], myLabel: [myLabels[cardDatas.count-1-i],myLabels2[cardDatas.count-1-i]],myNigateButton:nigateButtons[listcount-1-i],eng: cardDatas[listcount-1-i].eng!,jpn: cardDatas[listcount-1-i].jpn!,nigateFlag:cardDatas[listcount-1-i].nigateFlag!)
            }
        }else{
            for i in 0..<sevenDatas.count {
                makeCardWithNigateStar(cardView: cardViews[listcount-1-i], myLabel: [myLabels[sevenDatas.count-1-i],myLabels2[sevenDatas.count-1-i]],myNigateButton:nigateButtons[listcount-1-i],eng: sevenDatas[listcount-1-i].eng!,jpn: sevenDatas[listcount-1-i].jpn!,nigateFlag:sevenDatas[listcount-1-i].nigateFlag!)
            }

        }
        if(appDelegate.modeTag != 2){
            progress.text = String(count+1) + "/" + String(cardDatas.count)
        }else{
            progress.text = String(count+1) + "/" + String(sevenDatas.count)

        }

        initializeButtonColor()
        initializeButtonAction()
        initializeButtonTitle()
        initializeButtonBorder()
        if(appDelegate.canCardSwipe){
            leftSwipeButton.isEnabled = false
            rightSwipeButton.isEnabled = false
            goNigateProblemButton.isEnabled = false
        }
        goNigateProblemButton.addTarget(self, action: #selector(goProblem2), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backToSelect), for: .touchUpInside)
        
    }

    func showJpn(){
        UIView.animate(withDuration: 0.1,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.myLabels2[self.count].alpha = 1
                //self.cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        { (Bool) -> Void in
            
        }
    }

    func fadeOutCard(){
        // Labelアニメーション.
        UIView.animate(withDuration: 0.1,
                       
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 拡大用アフィン行列を作成する.
                self.cardViews[self.count].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                // 縮小用アフィン行列を作成する.
                self.cardViews[self.count].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        { (Bool) -> Void in
            
        }
        
        UIView.animate(withDuration: 0.3,
                       // アニメーション中の処理.
            animations: { () -> Void in
                
                self.cardViews[self.count].alpha = 0
                
        })
        { (Bool) -> Void in
            
        }
        if(count > 0){
            self.cardViews[self.count-1].removeFromSuperview()
        }
    }
    
    func nextOrFinish(){
        if(listcount-1 > count){
            count += 1
            if(appDelegate.modeTag != 2){
                progress.text = String(count+1) + "/" + String(cardDatas.count)
            }else{
                progress.text = String(count+1) + "/" + String(sevenDatas.count)
            }
        }else{
            if(self.count == listcount-1){
                finishingProcess()
                //changeToFinishMode()
            }
        }
    }
    
    
    func changeCard(){
        fadeOutCard()
        nextOrFinish()
    }
    
    var retryIndexs:Array<Int> = []
    
    //新しくappendしたlabelなどを使って次のcardViewを作成し、一番後ろに配置する。ここでlistcountはappendしたタイミングでは増えていないこと、実際に配列にアクセスするための添え字は[labelsの数-1]が最後部になることを考えると、現在のlistcount（+1する前）が最後部のlabelsになる。この最後部のlabelなどを使って新しいcardViewを作成する。＜ーこれがlistcountが必要な理由！
    //すなわち、今の値はself.countにあり、それをself.listcount番目のcardに代入するという形になる（両者は最後のカードの時一致する。ややこしい！）
    func addBehind(){
        retryIndexs.append(count)
        cardViews.append(UIView())
        myLabels.append(UILabel())
        myLabels2.append(UILabel())
        nigateButtons.append(UIButton())
        if(appDelegate.modeTag != 2){
            makeCardWithNigateStar(cardView: cardViews[listcount], myLabel:[myLabels[self.listcount],myLabels2[self.listcount]], myNigateButton:nigateButtons[self.listcount],eng: myLabels[self.count].text!, jpn: myLabels2[self.count].text!,nigateFlag:cardDatas[count].nigateFlag!)
            superCardView.sendSubview(toBack: cardViews[listcount])
        
            //nigateaddでは苦手かどうかをみるだけなので、jpnreibunなどはとくに気にする必要はない
            cardDatas.append(NewImageReibun(eng: myLabels[self.count].text!, jpn: myLabels2[self.count].text!,engReibun:cardDatas[self.count].engReibun!,jpnReibun:cardDatas[self.count].jpnReibun!,nigateFlag:cardDatas[self.count].nigateFlag!,partOfSpeech:cardDatas[self.count].partOfSpeech!))
        }else{
            makeCardWithNigateStar(cardView: cardViews[listcount], myLabel:[myLabels[self.listcount],myLabels2[self.listcount]], myNigateButton:nigateButtons[self.listcount],eng: myLabels[self.count].text!, jpn: myLabels2[self.count].text!,nigateFlag:sevenDatas[count].nigateFlag!)
            superCardView.sendSubview(toBack: cardViews[listcount])
            
            //nigateaddでは苦手かどうかをみるだけなので、jpnreibunなどはとくに気にする必要はない
            sevenDatas.append(SixWithChapter(eng: myLabels[self.count].text!, jpn: myLabels2[self.count].text!,engReibun:sevenDatas[self.count].engReibun!,jpnReibun:sevenDatas[self.count].jpnReibun!,nigateFlag:sevenDatas[self.count].nigateFlag!,partOfSpeech:sevenDatas[self.count].partOfSpeech!,chapterNumber:sevenDatas[self.count].chapterNumber!))
        }
        listcount += 1
        retryCount += 1
    }

    
    func goNextCard(){
        UIView.animate(withDuration: 0.7,delay: 0,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.myLabels2[self.count].alpha = 1
                //self.cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        { (Bool) -> Void in
            self.changeCard()
        }
    }
    
    func goNextAndAddBehind(){
        UIView.animate(withDuration: 0.7,delay: 0,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.myLabels2[self.count].alpha = 1
                //self.cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        { (Bool) -> Void in
            self.fadeOutCard()
            self.addBehind()
            self.nextOrFinish()
        }
        
    }
    
    func nigateAdd(){
        var preserveFileName = String()
        print("count : " + String(count))
        if(appDelegate.modeTag != 2){
            preserveFileName = nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber]

            if cardDatas[count].nigateFlag! == "0"{
                print("nigate add")
                
                    writeSixFile(fileName:preserveFileName,eng:cardDatas[count].eng!,jpn:cardDatas[count].jpn!,engPhrase:cardDatas[count].engReibun!,jpnPhrase:cardDatas[count].jpnReibun!,nigateFlag:"1",partOfSpeech: cardDatas[count].partOfSpeech!)
                
                nigateButtons[count].setImage(UIImage(named:"nigate.png"), for: .normal)
                cardDatas[count].nigateFlag = "1"
            }else{
                nigateButtons[count].setImage(UIImage(named:"un_nigate.png"), for: .normal)
                cardDatas[count].nigateFlag = "0"
                
                let nigateArray = getfile(fileName:preserveFileName)
                var list = Array<NewImageReibun>()
                for r in 0..<nigateArray.count/6{
                    list.append(NewImageReibun(eng: nigateArray[6*r],jpn:nigateArray[6*r+1],engReibun:nigateArray[6*r+2],jpnReibun:nigateArray[6*r+3],nigateFlag: nigateArray[6*r+4],partOfSpeech: nigateArray[6*r+5]))
                }
                list = deleteWordFromNigateArray(eng:cardDatas[count].eng!,list:list)
                deleteFile(fileName:preserveFileName)
                for r in 0..<list.count{
                    writeSixFile(fileName:preserveFileName,eng: list[r].eng!, jpn: list[r].jpn!, engPhrase: list[r].engReibun!, jpnPhrase: list[r].jpnReibun!,nigateFlag:list[r].nigateFlag!,partOfSpeech: list[r].partOfSpeech!)
                }
/*
                print("nigate cancel")

                    writeSixFile(fileName:preserveFileName,eng:cardDatas[count].eng!,jpn:cardDatas[count].jpn!,engPhrase:cardDatas[count].engReibun!,jpnPhrase:cardDatas[count].jpnReibun!,nigateFlag:"0",partOfSpeech: cardDatas[count].partOfSpeech!)
                    */
                                        }
        }else{
            preserveFileName = nigateFileNames[appDelegate.problemCategory][Int(sevenDatas[count].chapterNumber!)!]
            print(preserveFileName)
            if sevenDatas[count].nigateFlag! == "0"{
                print("nigate add")
                
                    writeSixFile(fileName:preserveFileName,eng:sevenDatas[count].eng!,jpn:sevenDatas[count].jpn!,engPhrase:sevenDatas[count].engReibun!,jpnPhrase:sevenDatas[count].jpnReibun!,nigateFlag:"1",partOfSpeech: sevenDatas[count].partOfSpeech!)
                              nigateButtons[count].setImage(UIImage(named:"nigate.png"), for: .normal)
                sevenDatas[count].nigateFlag = "1"
            }else{
                print("nigate cancel")
                nigateButtons[count].setImage(UIImage(named:"un_nigate.png"), for: .normal)
                sevenDatas[count].nigateFlag = "0"
                let nigateArray = getfile(fileName:preserveFileName)
                var list = Array<NewImageReibun>()
                for r in 0..<nigateArray.count/6{
                    list.append(NewImageReibun(eng: nigateArray[6*r],jpn:nigateArray[6*r+1],engReibun:nigateArray[6*r+2],jpnReibun:nigateArray[6*r+3],nigateFlag: nigateArray[6*r+4],partOfSpeech: nigateArray[6*r+5]))
                }
                list = deleteWordFromNigateArray(eng:sevenDatas[count].eng!,list:list)
                deleteFile(fileName:preserveFileName)
                for r in 0..<list.count{
                    writeSixFile(fileName:preserveFileName,eng: list[r].eng!, jpn: list[r].jpn!, engPhrase: list[r].engReibun!, jpnPhrase: list[r].jpnReibun!,nigateFlag:list[r].nigateFlag!,partOfSpeech: list[r].partOfSpeech!)
                }
            }
        }
    }

    func goProblem2(){
        //苦手モードに変更
        appDelegate.modeTag = 1
        goProblem()
    }
    
    func finishingProcess(){
        //if(cardMode == 1){
        //makeFinishView(retryCount:retryCount)
        //カードへの操作を一時禁止
        cardWorkFlag = false
        
        //スワイプボタンの実行関数を変更
        leftSwipeButton.title = "もう一度"
        leftSwipeButton.removeTarget(self, action: #selector(goNextAndAddBehind), for: .touchUpInside)
        leftSwipeButton.addTarget(self, action: #selector(retry),for: .touchUpInside)
        leftSwipeButton.isEnabled = true
        leftSwipeButton.layer.borderWidth = 1.0
        
        rightSwipeButton.title = "次のchapterへ"
        rightSwipeButton.removeTarget(self, action: #selector(goNextCard), for: .touchUpInside)
        rightSwipeButton.addTarget(self, action: #selector(goNextChapter), for: .touchUpInside)
        rightSwipeButton.isEnabled = true
        rightSwipeButton.layer.borderWidth = 1.0
        
        
        goProblemButton.removeTarget(self, action: #selector(nigateAdd), for: .touchUpInside)
        goProblemButton.addTarget(self, action: #selector(goProblem), for: .touchUpInside)
        goNigateProblemButton.isEnabled = true
        goNigateProblemButton.title = "問題（苦手）"
        
        goProblemButton.title = "問題（全て）"
        
        goProblemButton.layer.borderWidth = 1
        goNigateProblemButton.layer.borderWidth = 1
        
        
        /*
         //苦手だけ探せば、存在するかどうかはわかる
         if(appDelegate.modeTag == 1){
         //次のchapterを調べるので、次があることを確認する
         if(appDelegate.chapterNumber < nigateFileNames[appDelegate.problemCategory].count-1){
         if getNigateTangoVolume(fileName: nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber+1]) == 0{
         goNigateProblemButton.layer.backgroundColor = UIColor.gray.cgColor
         goNigateProblemButton.isEnabled = false
         }
         }
         }
         */
        
        //次のchapterを調べる。
        //次のchapterがあればスワイプを有効に
        if(appDelegate.modeTag == 0){
            if appDelegate.chapterNumber == fileNames[appDelegate.problemCategory].count-1{
                rightSwipeButton.isEnabled = false
                rightSwipeButton.backgroundColor = UIColor.clear
            }
        }
            
        else if appDelegate.modeTag == 1{
            //rightSwipeButton.isEnabled = false
            //rightSwipeButton.backgroundColor = UIColor.clear
        }else if appDelegate.modeTag == 2{
            
        }
        
        
        
        //現在のchapterを調べる。こちらはProblemに行けるかを判定
        if(appDelegate.chapterNumber <= nigateFileNames[appDelegate.problemCategory].count-1){
            if getNigateTangoVolume(fileName: nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber]) == 0{
                print(getNigateTangoVolume(fileName: nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber]))
                goNigateProblemButton.isEnabled = false
                goNigateProblemButton.backgroundColor = UIColor.clear
            }else{
                goNigateProblemButton.isEnabled = true
            }
        }
        goProblemButton.isEnabled = true
        goProblemButton.layer.borderWidth = 1.0
    }

    
    func retry(){
        //if(appDelegate.chapterNumber-1 < newChapterNumber){
        if(appDelegate.chapterNumber-1 < fileNames[appDelegate.problemCategory].count-1){
            retryCount = 0
            self.count = 0
            var fileName = String()
            if(appDelegate.modeTag == 0){
                fileName = fileNames[appDelegate.problemCategory][appDelegate.chapterNumber]
                cardDatas = getAllTangos(fileName:fileName)
            }else if appDelegate.modeTag == 1{
                fileName = nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber]
                let tangos = getfile(fileName: fileName)
                cardDatas = Array<NewImageReibun>()
                for r in 0..<tangos.count/6{
                    cardDatas.append(NewImageReibun(eng: tangos[6*r],jpn:tangos[6*r+1],engReibun:tangos[6*r+2],jpnReibun:tangos[6*r+3],nigateFlag:tangos[6*r+4],partOfSpeech:tangos[6*r+5]))
                }
            }else if appDelegate.modeTag == 2{
                var tango = Array<String>()
                //chpaterNumber
                for i in 0..<2{
                    let fileName = nigateFileNames[appDelegate.problemCategory
                        ][i]
                    let tempTango = getfile(fileName:fileName)
                    for j in tempTango{
                        print(j)
                    }
                    tango = tango + tempTango
                    sevenDatas = Array<SixWithChapter>()
                    for r in 0..<tempTango.count/6{
                        sevenDatas.append(SixWithChapter(eng: tempTango[6*r],jpn:tempTango[6*r+1],engReibun:tempTango[6*r+2],jpnReibun:tempTango[6*r+3],nigateFlag: tempTango[6*r+4],partOfSpeech:tempTango[6*r+5],chapterNumber:String(i)))
                    }
                }
                for j in tango{
                    print(j)
                }
            }else{
                
            }
            
            if(appDelegate.modeTag != 2){
                progress.text = String(count+1) + "/" + String(cardDatas.count)
            }else{
                progress.text = String(count+1) + "/" + String(sevenDatas.count)
            }
            
            //苦手配列の英語と同じ英語に苦手ラベルづけ
            let nigateArray:Array<String> = getfile(fileName: nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber])
            for r in 0..<nigateArray.count/6{
                if nigateArray[6*r+4] == "1"{
                    for i in 0..<cardDatas.count{
                        if(nigateArray[6*r] == cardDatas[i].eng){
                            cardDatas[i].nigateFlag = "1"
                        }
                    }
                }
            }
            
            print(fileName)
            //テスト中なので、とりあえず、ファイルの全てを取れるようにしておく。基本、苦手もファイル名が変わるだけで形式は同じ
            self.cardViews = [UIView()]
            self.myLabels = [UILabel()]
            self.myLabels2 = [UILabel()]
            self.nigateButtons = [UIButton()]
            
            
            if(appDelegate.modeTag != 2){
                initialListCount = cardDatas.count
                
                
                self.listcount = cardDatas.count
                for _ in 0..<cardDatas.count {
                    self.cardViews.append(UIView())
                    self.myLabels.append(UILabel())
                    self.myLabels2.append(UILabel())
                    self.nigateButtons.append(UIButton())
                }
            }else{
                initialListCount = sevenDatas.count
                
                self.listcount = sevenDatas.count
                for _ in 0..<sevenDatas.count {
                    self.cardViews.append(UIView())
                    self.myLabels.append(UILabel())
                    self.myLabels2.append(UILabel())
                    self.nigateButtons.append(UIButton())
                }
                
            }
            
            
            if(appDelegate.modeTag != 2){
                for i in 0..<cardDatas.count {
                    //makeCard(cardView: cardViews[listcount-1-i], myLabel: [myLabels[cardDatas.count-1-i],myLabels2[cardDatas.count-1-i]],eng: cardDatas[listcount-1-i].eng!,jpn: cardDatas[listcount-1-i].jpn!)
                    makeCardWithNigateStar(cardView: cardViews[listcount-1-i], myLabel: [myLabels[cardDatas.count-1-i],myLabels2[cardDatas.count-1-i]],myNigateButton:nigateButtons[listcount-1-i],eng: cardDatas[listcount-1-i].eng!,jpn: cardDatas[listcount-1-i].jpn!,nigateFlag:cardDatas[listcount-1-i].nigateFlag!)
                }
            }else{
                for i in 0..<sevenDatas.count {
                    //makeCard(cardView: cardViews[listcount-1-i], myLabel: [myLabels[cardDatas.count-1-i],myLabels2[cardDatas.count-1-i]],eng: cardDatas[listcount-1-i].eng!,jpn: cardDatas[listcount-1-i].jpn!)
                    makeCardWithNigateStar(cardView: cardViews[listcount-1-i], myLabel: [myLabels[sevenDatas.count-1-i],myLabels2[sevenDatas.count-1-i]],myNigateButton:nigateButtons[listcount-1-i],eng: sevenDatas[listcount-1-i].eng!,jpn: sevenDatas[listcount-1-i].jpn!,nigateFlag:sevenDatas[listcount-1-i].nigateFlag!)
                }
            }
            
            finishView.removeFromSuperview()
            initializeButtonColor()
            //initializeButtonAction()
            //initializeButtonBorder()
            goNigateProblemButton.layer.borderWidth = 0.0
            goProblemButton.layer.borderWidth = 0.0
            goProblemButton.isEnabled = false
            initializeButtonTitle()
            changeButtonTargeEndToRunning()
            goNigateProblemButton.isEnabled = false
            //カードへの操作を復活
            cardWorkFlag = true
            
        }else{
            appDelegate.chapterNumber -= 1
        }
        //}
    }
    
    
    func initializeButtonColor(){
        goProblemButton.backgroundColor = UIColor.clear
        goNigateProblemButton.backgroundColor = UIColor.clear
        if(appDelegate.canCardSwipe){
            leftSwipeButton.backgroundColor = UIColor.clear
            rightSwipeButton.backgroundColor = UIColor.clear
        }else{
            leftSwipeButton.backgroundColor = UIColor.orange
            rightSwipeButton.backgroundColor = UIColor.green
        }
    }
    
    func changeButtonTargetRunningToEnd(){
        leftSwipeButton.removeTarget(self, action: #selector(goNextAndAddBehind), for: .touchUpInside)
        rightSwipeButton.removeTarget(self, action: #selector(goNextCard), for: .touchUpInside)
        leftSwipeButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
        rightSwipeButton.addTarget(self, action: #selector(goNextChapter), for: .touchUpInside)
    }
    
    func changeButtonTargeEndToRunning(){
        leftSwipeButton.removeTarget(self, action:  #selector(retry), for: .touchUpInside)
        rightSwipeButton.removeTarget(self, action: #selector(goNextChapter), for: .touchUpInside)
        leftSwipeButton.addTarget(self, action: #selector(goNextAndAddBehind), for: .touchUpInside)
        rightSwipeButton.addTarget(self, action:#selector(goNextCard), for: .touchUpInside)
    }
    
    func initializeButtonAction(){
        leftSwipeButton.addTarget(self, action: #selector(goNextAndAddBehind), for: .touchUpInside)
        rightSwipeButton.addTarget(self, action: #selector(goNextCard), for: .touchUpInside)
    }
    
    func initializeButtonTitle(){
        goProblemButton.title = ""
        goNigateProblemButton.title = ""
        leftSwipeButton.title = "<-後でもう一度"
        rightSwipeButton.title = "次へ->"
    }
    
    func initializeButtonBorder(){
        goProblemButton.layer.borderColor = UIColor.white.cgColor
        goNigateProblemButton.layer.borderColor = UIColor.white.cgColor
        leftSwipeButton.layer.borderColor = UIColor.white.cgColor
        rightSwipeButton.layer.borderColor = UIColor.white.cgColor
        
        if !appDelegate.canCardSwipe {
            leftSwipeButton.layer.borderWidth = 1
            rightSwipeButton.layer.borderWidth = 1
        }
    }
    
    var newChapterNumber = Int()

    func goProblem(){
        
        //if(cardMode == 0){
            //goProblem
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newProblem") as!  ProblemVC
            
            // Viewの移動する.
            //UIApplication.shared.keyWindow?.rootViewController = secondViewController
            self.present(secondViewController, animated: true, completion: nil)
            
        //}
    }
    
    func goNextChapter(){
        appDelegate.chapterNumber += 1
        retry()
    }
    
    
    //var cardMode:Int = 1
    
    
    var retryCount = 0
    //最初に問題数を得ておく。listcountは変動するので。それとretryCountを比較する。(同じものを何回やったかは考慮しない)
    //最後まで行ったら
    var finishView = UIView()
    
    /*
    func changeToFinishMode(){
        cardMode = 0
    }
    */
    
    func makeCardWithNigateStar(cardView:UIView,myLabel:Array<UILabel>,myNigateButton:UIButton,eng:String,jpn:String,nigateFlag:String){
        
        
        cardView.frame.size = CGSize(width: superCardView.frame.width, height: superCardView.frame.height)
        cardView.center = CGPoint(x: superCardView.frame.size.width/2, y: superCardView.frame.height/2)
        cardView.backgroundColor = UIColor.white
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 0.0
        cardView.layer.borderWidth = 1
        print(superCardView.center)
        print(cardView.center)
        
        
        // Labelを生成.
        myLabel[0].frame.size = CGSize(width: cardView.frame.size.width, height: cardView.frame.size.height/3)
        myLabel[0].center = CGPoint(x: cardView.frame.size.width/2, y: cardView.frame.size.height/2.5)
        myLabel[0].text = eng
        myLabel[0].font = UIFont.systemFont(ofSize: CGFloat(26))
        myLabel[0].alpha = 1
        
        myLabel[1].frame.size = CGSize(width: cardView.frame.size.width, height: cardView.frame.size.height/3)
        myLabel[1].center = CGPoint(x: cardView.frame.size.width/2, y: cardView.frame.size.height/1.5)
        myLabel[1].text = jpn
        myLabel[1].font = UIFont.systemFont(ofSize: CGFloat(18))
        myLabel[1].alpha = 0
        
        for i in 0...1{
            myLabel[i].textColor = UIColor.black
            myLabel[i].textAlignment = NSTextAlignment.center
            myLabel[i].backgroundColor = UIColor.white
            myLabel[i].layer.masksToBounds = true
            myLabel[i].layer.cornerRadius = 0.0
        }
        superCardView.addSubview(cardView)
        cardView.addSubview(myLabel[1])
        cardView.addSubview(myLabel[0])
        
        //同じlabelを参照していないかを確認(名前を間違えていた)
        //print(Unmanaged.passRetained(myLabel[0]))
        // print(Unmanaged.passRetained(myLabel[1]))
        //cardMode = 1
        
        myNigateButton.addTarget(self, action: #selector(nigateAdd), for: .touchUpInside)
        if(nigateFlag == "0"){
            myNigateButton.setImage(UIImage(named:"un_nigate.png"), for: .normal)
        }else{
            myNigateButton.setImage(UIImage(named:"nigate.png"), for: .normal)
        }
        myNigateButton.frame = CGRect(x: 6*cardView.frame.width/7, y: 0, width: cardView.frame.width/7, height: cardView.frame.width/7)
        cardView.addSubview(myNigateButton)
    }

    var cardViews = Array<UIView>()
    var myLabels = Array<UILabel>()
    var myLabels2 = Array<UILabel>()
    var nigateButtons = Array<UIButton>()
    var count = 0
    var listcount = 0
    var jpnVisible : CGFloat = CGFloat(0)
    
    func backToSelect() {
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "範囲選択画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            //let secondViewController: CategorySelectVC = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
            
            
            // Viewの移動する.
            //self.present(secondViewController, animated: true, completion: nil)
            /*
            let newRootVC = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as!  CategorySelectVC
            let navigationController = UINavigationController(rootViewController: newRootVC)
            
            UIApplication.shared.keyWindow?.rootViewController = navigationController
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
    /*
     タッチを感知した際に呼ばれるメソッド.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(appDelegate.canCardSwipe){
            showJpn()
        }
    }
    
    /*
     ドラッグを感知した際に呼ばれるメソッド.
     (ドラッグ中何度も呼ばれる)
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
         if(appDelegate.canCardSwipe){
            if(cardWorkFlag){
            //print("touchesMoved")
            
            // タッチイベントを取得.
            let aTouch: UITouch = touches.first!
            
            // 移動した先の座標を取得.
            let location = aTouch.location(in: superCardView)
            
            // 移動する前の座標を取得.
            let prevLocation = aTouch.previousLocation(in: superCardView)
            
            // CGRect生成.
            var myFrame: CGRect = self.cardViews[self.count].frame
            
            // ドラッグで移動したx, y距離をとる.
            let deltaX: CGFloat = location.x - prevLocation.x
            let deltaY: CGFloat = location.y - prevLocation.y
            
            // 移動した分の距離をmyFrameの座標にプラスする.
            myFrame.origin.x += deltaX
            myFrame.origin.y += deltaY
            
            // frameにmyFrameを追加.
            self.cardViews[self.count].frame = myFrame
            }
        }
    }
    
    /*
     指が離れたことを感知した際に呼ばれるメソッド.
     */
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(appDelegate.canCardSwipe){
            if(cardWorkFlag){
            //print("touchesEnded")
            // Labelアニメーション.
            UIView.animate(withDuration: 0.1,
                           
                           // アニメーション中の処理.
                animations: { () -> Void in
                    // 拡大用アフィン行列を作成する.
                    self.cardViews[self.count].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    // 縮小用アフィン行列を作成する.
                    self.cardViews[self.count].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            { (Bool) -> Void in
                
            }
            if(self.cardViews[self.count].frame.origin.x > superCardView.bounds.size.width/2.2 || self.cardViews[self.count].frame.origin.x < -self.cardViews[self.count].frame.width/3.5){
                self.fadeOutCard()
                if(self.cardViews[self.count].frame.origin.x < -self.cardViews[self.count].frame.width/2){
                    self.addBehind()
                }
                self.nextOrFinish()
            }
            }
        }
    }
    
    var cardDatas = Array<NewImageReibun>()
    var initialListCount = 0
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //苦手ファイルをゲット
    func getNigateTangos(fileName:String)->Array<NewImageReibun>{
        //ファイルをゲット、区切られたArray<String>を得る
        let nigateArray = getfile(fileName: fileName)
        //var nigateFlagArray = Array<Int>(repeating:0,count:nigateArray.count/8)
        var nigateTangos = Array<NewImageReibun>()
        //区切られたArray<String>の一部の情報を得る
        for r in 0..<nigateArray.count/6{
            print(nigateArray[6*r+5])
            nigateTangos.append(NewImageReibun(eng: nigateArray[6*r],jpn:nigateArray[6*r+1],engReibun:nigateArray[6*r+2],jpnReibun:nigateArray[6*r+3],nigateFlag: nigateArray[6*r+4],partOfSpeech: nigateArray[6*r+5]))
        }
        return nigateTangos
    }
    
    func getAllTangos(fileName:String)->Array<NewImageReibun>{
        //ファイルをゲット、区切られたArray<String>を得る
        let fileWholeTangos = readFileGetWordArray(fileName, extent: "txt",inDirectory: "tango/seedtango")
        var cardDatas = Array<NewImageReibun>()
        //区切られたArray<String>の一部の情報を得る
        for r in 0..<fileWholeTangos.count/6{
            cardDatas.append(NewImageReibun(eng: fileWholeTangos[6*r],jpn:fileWholeTangos[6*r+1],engReibun:fileWholeTangos[6*r+2],jpnReibun:fileWholeTangos[6*r+3],nigateFlag:fileWholeTangos[6*r+4],partOfSpeech:fileWholeTangos[6*r+5]))
            //print( cardDatas[r].eng,cardDatas[r].jpn,cardDatas[r].soundPath)
        }
        return cardDatas
    }
    
    @IBAction func settingButton(_ sender: Any) {
        showPopUpProgressView()
    }
    
    func showPopUpProgressView(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardSettingPopUp") as! CardSettingPopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        print("popOverVC : \(popOverVC.view.frame)")
        self.view.addSubview(popOverVC.view)
        
        popOverVC.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
