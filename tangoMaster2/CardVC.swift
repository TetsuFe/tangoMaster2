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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        newChapterNumber = getNewChapter(fileName: checkFileNamesArray[appDelegate.problemCategory], chapterVolume: testFileNamesArray[appDelegate.problemCategory].count)

        var fileName = String()
        if(appDelegate.modeTag == 0){
            fileName = testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            cardDatas = getAllTangos(fileName:fileName)
        }else if appDelegate.modeTag == 1{
            fileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            let tangos = getfile(fileName: fileName)
            for r in 0..<tangos.count/6{
                cardDatas.append(NewImageReibun(eng: tangos[6*r],jpn:tangos[6*r+1],engReibun:tangos[6*r+2],jpnReibun:tangos[6*r+3],nigateFlag:tangos[6*r+4],partOfSpeech:tangos[6*r+5]))
            }
        }else{
            //fileName = matomeFileNamesArray[appDelegate.problemCategory]
        }
        //テスト中なので、とりあえず、ファイルの全てを取れるようにしておく。基本、苦手もファイル名が変わるだけで形式は同じ
        
        initialListCount = cardDatas.count
        
        
        self.listcount = cardDatas.count
        for _ in 0..<cardDatas.count {
            self.cardViews.append(UIView())
            self.myLabels.append(UILabel())
            self.myLabels2.append(UILabel())
        }
        
        for i in 0..<cardDatas.count {
            makeCard(cardView: cardViews[listcount-1-i], myLabel: [myLabels[cardDatas.count-1-i],myLabels2[cardDatas.count-1-i]],eng: cardDatas[listcount-1-i].eng!,jpn: cardDatas[listcount-1-i].jpn!)
        }
        
        //nigateAddOrGoProblem.layer.borderWidth = 1
        nigateAddOrGoProblem.layer.cornerRadius = 10
        
        //goNextChapButton.layer.borderWidth = 1
        goNextChapButton.layer.cornerRadius = 10
        
        //ボタンをタップした時に実行するメソッドを指定
        //goNextChapButton.addTarget(self, action: #selector(goNextChapter), for: .touchUpInside)
        
        nigateAddOrGoProblem.addTarget(self, action: #selector(nigateAdd), for: .touchUpInside)
        
        progress.text = String(count+1) + "/" + String(cardDatas.count)
       
        nigateFlags = getNigateFlagArray(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber])
        
        leftSwipeButton.addTarget(self, action: #selector(goNextAndAddBehind), for: .touchUpInside)
        rightSwipeButton.addTarget(self, action: #selector(goNextCard), for: .touchUpInside)
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
            progress.text = String(count+1) + "/" + String(cardDatas.count)
        }else{
            if(self.count == listcount-1){
                finishingProcess()
                changeToFinishMode()
            }
        }
    }
    
    func finishingProcess(){
        if(cardMode == 1){
            //makeFinishView(retryCount:retryCount)
            
            //スワイプボタンの実行関数を変更
            
            leftSwipeButton.removeTarget(self, action: #selector(goNextAndAddBehind), for: .touchUpInside)
            
            leftSwipeButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
            
             rightSwipeButton.removeTarget(self, action: #selector(goNextCard), for: .touchUpInside)
            
            rightSwipeButton.addTarget(self, action: #selector(goNextChapter), for: .touchUpInside)
            
            leftSwipeButton.setTitle("もう一度", for: .normal)
            
            rightSwipeButton.setTitle("次のchapterへ", for: .normal)
            
             nigateAddOrGoProblem.removeTarget(self, action: #selector(nigateAdd), for: .touchUpInside)
            
            nigateAddOrGoProblem.addTarget(self, action: #selector(goProblem), for: .touchUpInside)
            
       
            
            goNextChapButton.setTitle("問題(苦手)", for: .normal)
            
                goNextChapButton.addTarget(self, action: #selector(goProblem2), for: .touchUpInside)
            
            nigateAddOrGoProblem.setTitle("問題に挑戦！", for: .normal)
            /*
            //苦手だけ探せば、存在するかどうかはわかる
            if(appDelegate.modeTag == 1){
                //次のchapterを調べるので、次があることを確認する
                if(appDelegate.chapterNumber < testNigateFileNamesArray[appDelegate.problemCategory].count-1){
                    if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber+1]) == 0{
                        goNextChapButton.layer.backgroundColor = UIColor.gray.cgColor
                        goNextChapButton.isEnabled = false
                    }
                }
            }
            */
            
            if(appDelegate.modeTag == 0){
                if appDelegate.chapterNumber == testFileNamesArray[appDelegate.problemCategory].count-1{
                    rightSwipeButton.isEnabled = false
                }
            }
 
            
            //次のchapterを調べるので、次があることを確認する
            if(appDelegate.chapterNumber < testNigateFileNamesArray[appDelegate.problemCategory].count-1){
                if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]) == 0{
                    
                    goNextChapButton.isEnabled = false
                    if appDelegate.modeTag == 1{
                        rightSwipeButton.isEnabled = false
                    }
                }
            }
            

        }
    }
    
    func changeCard(){
        fadeOutCard()
        nextOrFinish()
    }
    
    var retryIndexs:Array<Int> = []
    
    func addBehind(){
        retryIndexs.append(count)
        cardViews.append(UIView())
        myLabels.append(UILabel())
        myLabels2.append(UILabel())
        makeCard(cardView: cardViews[listcount], myLabel:[myLabels[self.listcount],myLabels2[self.listcount]], eng: myLabels[self.count].text!, jpn: myLabels2[self.count].text!)
        superCardView.sendSubview(toBack: cardViews[listcount])
        cardDatas.append(NewImageReibun(eng:"a",jpn:"あ",engReibun:"e",jpnReibun:"え",nigateFlag:"1",partOfSpeech:"a"))
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
    
    func getNigateFlagArray(fileName:String)->Array<String>{
        let nigateArray = getfile(fileName: fileName)
        var nigateFlagArray = Array<String>()
        for r in 0..<nigateArray.count/6{
            print(nigateArray[6*r+5])
            if(nigateArray[6*r+5] == "1"){
                nigateFlagArray.append("1")
            }else{
                nigateFlagArray.append("0")
            }
        }
        return nigateFlagArray
    }
    
    
    var nigateFlags = Array<String>()
    
    func nigateAdd(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let preserveFileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
        
        nigateAddOrGoProblem.isEnabled = false //login_btnはUIButtonです
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.nigateAddOrGoProblem.isEnabled = true
        })
        
        
        if cardDatas[count].nigateFlag == "0"{
            writeSixFile(fileName:preserveFileName,eng:cardDatas[count].eng!,jpn:cardDatas[count].jpn!,engPhrase:cardDatas[count].engReibun!,jpnPhrase:cardDatas[count].jpnReibun!,nigateFlag:"1",partOfSpeech: cardDatas[count].partOfSpeech!)
        }
    }


    func goProblem2(){
        //cardDatas[retryIndexs]
        //苦手モードに変更
        appDelegate.modeTag = 1
        goProblem()
    }
    
    func retry(){
        if(appDelegate.chapterNumber-1 < newChapterNumber){
            if(appDelegate.chapterNumber-1 < testFileNamesArray[appDelegate.problemCategory].count-1){
                retryCount = 0
                var fileName = String()
                self.count = 0
                progress.text = String(count+1) + "/" + String(cardDatas.count)
                
                if(appDelegate.modeTag == 0){
                    fileName = testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
                    cardDatas = getAllTangos(fileName:fileName)
                }else if appDelegate.modeTag == 1{
                    fileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
                    let tangos = getfile(fileName: fileName)
                    for r in 0..<tangos.count/6{
                        cardDatas.append(NewImageReibun(eng: tangos[6*r],jpn:tangos[6*r+1],engReibun:tangos[6*r+2],jpnReibun:tangos[6*r+3],nigateFlag:tangos[6*r+4],partOfSpeech:tangos[6*r+5]))
                        
                    }
                    
                }else{
                    //fileName = matomeFileNamesArray[appDelegate.problemCategory]
                }
                print(fileName)
                //テスト中なので、とりあえず、ファイルの全てを取れるようにしておく。基本、苦手もファイル名が変わるだけで形式は同じ
                initialListCount = cardDatas.count
                self.listcount = cardDatas.count
                cardViews = [UIView()]
                myLabels = [UILabel()]
                myLabels2 = [UILabel()]
                
                for _ in 0..<cardDatas.count {
                    self.cardViews.append(UIView())
                    self.myLabels.append(UILabel())
                    self.myLabels2.append(UILabel())
                }
                
                for i in 0..<cardDatas.count {
                    makeCard(cardView: cardViews[listcount-1-i], myLabel: [myLabels[cardDatas.count-1-i],myLabels2[cardDatas.count-1-i]],eng: cardDatas[listcount-1-i].eng!,jpn: cardDatas[listcount-1-i].jpn!)
                }
                
                nigateFlags = getNigateFlagArray(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber])
                finishView.removeFromSuperview()
            }
        }else{
            appDelegate.chapterNumber -= 1
        }
    }
    
    var newChapterNumber = Int()

    func goProblem(){
        
        if(cardMode == 0){
            //goProblem
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newProblem") as!  ProblemVC
            
            // Viewの移動する.
            //UIApplication.shared.keyWindow?.rootViewController = secondViewController
            self.present(secondViewController, animated: true, completion: nil)
            
        }
    }
    
    func goNextChapter(){
        appDelegate.chapterNumber += 1
        retry()
    }
    
    
    var cardMode:Int = 1
    
    @IBOutlet weak var nigateAddOrGoProblem: UIButton!
    
    @IBOutlet weak var goNextChapButton: UIButton!
    
    @IBOutlet weak var leftSwipeButton: UIButton!
    @IBOutlet weak var rightSwipeButton: UIButton!
    
    @IBOutlet weak var progress: UILabel!
    
    @IBOutlet weak var superCardView: UIView!
    
    var retryCount = 0
    //最初に問題数を得ておく。listcountは変動するので。それとretryCountを比較する。(同じものを何回やったかは考慮しない)
    //最後まで行ったら
    var finishView = UIView()
    
    func changeToFinishMode(){
        //leftSwipeButton.isEnabled = false
        //rightSwipeButton.isEnabled = false
        cardMode = 0
    }
    
    func makeFinishView(retryCount : Int){
        
        /*
        finishView.frame.size = CGSize(width: superCardView.frame.width, height: superCardView.frame.height)
        finishView.center = CGPoint(x: superCardView.frame.size.width/2, y: superCardView.frame.height/2)
        //print(finishView.center)
        finishView.backgroundColor = UIColor.white
        finishView.layer.masksToBounds = true
        finishView.layer.cornerRadius = 0.0
        finishView.layer.borderWidth = 1
        
        // Labelを生成.
        var comment:[String] = ["",""]
        print(retryCount)

        
        print(100*retryCount/cardDatas.count)
        if(100*retryCount/cardDatas.count == 0){
            comment[0] = "Perfect"
            comment[1] = "完璧だ。さすが我が下僕よ。"
        }else if(100*retryCount/cardDatas.count > 0 && 100*retryCount/cardDatas.count <= 10 ){
            comment[0] = "Excellent"
            comment[1] = "あと少しだ。気を抜かずまた挑戦だ。"
        }else if(100*retryCount/cardDatas.count > 10 && 100*retryCount/cardDatas.count <= 20 ){
            comment[0] = "Good"
            comment[1] = "まあ良い。今日中にまた挑戦せよ。"
        }else if(100*retryCount/cardDatas.count > 20  && 100*retryCount/cardDatas.count <= 30){
            comment[0] = "Not Bad"
            comment[1] = "悪くない。だがこれでは魔界を生き抜けぬぞ。"
        }else if(100*retryCount/cardDatas.count > 30){
            comment[0] = "No Sence"
            comment[1] = "お主には失望したわ。勉強して出直してこい"
        }
 
        
        print(comment[0],comment[1])
        let finishLabel = [UILabel(),UILabel()]
        finishLabel[0].frame.size = CGSize(width: finishView.frame.size.width, height: finishView.frame.size.height/3)
        finishLabel[0].center = CGPoint(x: finishView.frame.size.width/2, y: finishView.frame.size.height/2.5)
        finishLabel[0].text = comment[0]
        finishLabel[0].font = UIFont.systemFont(ofSize: CGFloat(26))
        //finishLabel[0].alpha = 1
        
        finishLabel[1].frame.size = CGSize(width: finishView.frame.size.width, height: finishView.frame.size.height/3)
        finishLabel[1].center = CGPoint(x: finishView.frame.size.width/2, y: finishView.frame.size.height/1.5)
        finishLabel[1].text = comment[1]
        finishLabel[1].font = UIFont.systemFont(ofSize: CGFloat(18))
        //finishLabel[1].alpha = 1
        
        for i in 0...1{
            finishLabel[i].textColor = UIColor.black
            finishLabel[i].textAlignment = NSTextAlignment.center
            finishLabel[i].backgroundColor = UIColor.white
            finishLabel[i].layer.masksToBounds = true
            finishLabel[i].layer.cornerRadius = 0.0
        }
        superCardView.addSubview(finishView)
        finishView.addSubview(finishLabel[1])
        finishView.addSubview(finishLabel[0])
        
 */
        print("finishView Show?")
    }
    
    
    func makeCard(cardView:UIView,myLabel:Array<UILabel>,eng:String,jpn:String){
        
        
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
        cardMode = 1
        
        
    }
    /*
    @IBAction func jpnVisibleButton(_ sender: AnyObject) {
        if(self.jpnVisible == CGFloat(0)){
            self.jpnVisible = 1
            for i in 0..<listcount{
                self.myLabels2[i].alpha = self.jpnVisible
            }
        }
        else{
            self.jpnVisible = 0
            for i in 0..<listcount{
                self.myLabels2[i].alpha = self.jpnVisible
            }
        }
    }
 */
    var cardViews = Array<UIView>()
    var myLabels = Array<UILabel>()
    var myLabels2 = Array<UILabel>()
    var count = 0
    var listcount = 0
    var jpnVisible : CGFloat = CGFloat(0)
    
    @IBAction func backButton(_ sender: AnyObject) {
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "問題選択画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let secondViewController: CategorySelectVC = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
            
            
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
    /*
     タッチを感知した際に呼ばれるメソッド.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       showJpn()    }
    
    /*
     ドラッグを感知した際に呼ばれるメソッド.
     (ドラッグ中何度も呼ばれる)
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    /*
     指が離れたことを感知した際に呼ばれるメソッド.
     */
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        let fileWholeTangos = readFileGetWordArray(fileName, extent: "txt")
        var cardDatas = Array<NewImageReibun>()
        //区切られたArray<String>の一部の情報を得る
        for r in 0..<fileWholeTangos.count/6{
            cardDatas.append(NewImageReibun(eng: fileWholeTangos[6*r],jpn:fileWholeTangos[6*r+1],engReibun:fileWholeTangos[6*r+2],jpnReibun:fileWholeTangos[6*r+3],nigateFlag:fileWholeTangos[6*r+4],partOfSpeech:fileWholeTangos[6*r+5]))
            //print( cardDatas[r].eng,cardDatas[r].jpn,cardDatas[r].soundPath)
        }
        return cardDatas
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
