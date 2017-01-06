//
//  NewProblemVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit



class ProblemVC: UIViewController {

    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var problemRangeLabel: UILabel!
 */
    @IBOutlet weak var progress: UILabel!
    
    @IBOutlet weak var labelProblem: UILabel!
    
    //ラスタ操作で１、２、３、４
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    func pushAnswer1(){
        judgeAnswer(0)
        answerButton()
    }
    func pushAnswer2(){
        judgeAnswer(1)
        answerButton()
    }
    func pushAnswer3(){
        judgeAnswer(2)
        answerButton()
    }
    func pushAnswer4(){
        judgeAnswer(3)
        answerButton()
    }
    
    
    @IBOutlet weak var backProblemButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var backPageButton: UIButton!
    
    func goPrevProblem() {
        if(k>0){
            k -= 1
            setLabel()
        }
    }
    
    func submit(){
        print("submit")
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "答えを提出しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            self.setResult(self.list)
            let secondViewController: ProblemResultVC = self.storyboard?.instantiateViewController(withIdentifier: "newProblemResult") as! ProblemResultVC
            // アニメーションを設定する.
            //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            // 値渡ししたい時 hoge -> piyo
            //secondViewController.piyo = self.hoge
            // Viewの移動する.
            self.present(secondViewController, animated: true, completion: nil)
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
        // alertOnSubmitView.frame.width = self.view.frame.width/3
        // alertOnSubmitView.frame.height = self.view.frame.height/3
    }
    
    func backPage(){
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "確認", message: "選択画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
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
    
    func answerButton(){
        if(k < correctArray.count){
            if k > existProblemIndex{
                gAllProbIndexes.append(makeNextProblem())
                existProblemIndex = k
            }
            setLabel()
        }
    }
    
    var chap = Int()
    var k = 0
    var gcurrentProbArray = Array<Array<Int>>()
    var gLabelOrderArray = Array<Int>()
    var correctArray = Array<Int>()
    
    //日本語対英語のファイル名（拡張子抜き）の配列
    
    var tangoNumber = 0
    
    var gtangoRow:Int = 0
    var gtangoColumn:Int = 0
    
    var list = Array<NewImageReibun>()
    var nigateList = Array<NewImageReibun>()
    //問題リストファイルを選択 問題番号とファイル名を対応させておく。
    
    var dummyArray = Array<Array<Jpn>>(repeating:[],count:5)
    
    func setLabel(){
        print(gAllProbIndexes[k])
        for i in 0..<list.count{
            print(list[i].eng!,list[i].jpn!)
        }
        //正解の要素だけは問題数で引き算した時に負になる。負にならないもののみ引き算を行う
        
        var wrongFlag = [false,false,false,false]
        
        var currentJpnArray = Array<Jpn>()
        
        if gAllProbIndexes[k][0] != correctArray[k]{
            gAllProbIndexes[k][0] -= appDelegate.problemVolume
            wrongFlag[0] = true
            currentJpnArray = dummyArray[getCurrentArray(parts:list[correctArray[k]].partOfSpeech!)]
            answerButton1.setTitle(currentJpnArray[gAllProbIndexes[k][0]].jpn!, for: .normal)
        }else{
            answerButton1.setTitle(list[gAllProbIndexes[k][0]].jpn!, for: .normal)
        }
        
        if gAllProbIndexes[k][1] != correctArray[k]{
            gAllProbIndexes[k][1] -= appDelegate.problemVolume
            wrongFlag[1] = true
            currentJpnArray = dummyArray[getCurrentArray(parts:list[correctArray[k]].partOfSpeech!)]
            answerButton2.setTitle(currentJpnArray[gAllProbIndexes[k][1]].jpn!, for: .normal)
        }else{
            answerButton2.setTitle(list[gAllProbIndexes[k][1]].jpn!, for: .normal)
        }
        
        if gAllProbIndexes[k][2] != correctArray[k]{
            gAllProbIndexes[k][2] -= appDelegate.problemVolume
            wrongFlag[2] = true
            currentJpnArray = dummyArray[getCurrentArray(parts:list[correctArray[k]].partOfSpeech!)]
            answerButton3.setTitle(currentJpnArray[gAllProbIndexes[k][2]].jpn!, for: .normal)
        }else{
            answerButton3.setTitle(list[gAllProbIndexes[k][2]].jpn!, for: .normal)
        }
        
        if gAllProbIndexes[k][3] != correctArray[k]{
            gAllProbIndexes[k][3] -= appDelegate.problemVolume
            wrongFlag[3] = true
            currentJpnArray = dummyArray[getCurrentArray(parts:list[correctArray[k]].partOfSpeech!)]
            answerButton4.setTitle(currentJpnArray[gAllProbIndexes[k][3]].jpn!, for: .normal)
        }else{
            answerButton4.setTitle(list[gAllProbIndexes[k][3]].jpn!, for: .normal)
        }
        
        labelProblem.text = "\(list[correctArray[k]].eng!)"
        
        for i in 0...3{
            if wrongFlag[i]{
                gAllProbIndexes[k][i] += appDelegate.problemVolume
            }
        }
        
        progress.text = String(k+1) + "/" + String(wrongArray.count)
    }
    
    var count = 0
    var wrongArray = Array<Int>()
    
    
    //問題の個数調査・順序決定
    func setProblemOrder()->Array<Int>{
        print("問題が進んでいます!")
        var listEleCount = 0
        for i in 0..<list.count{
            listEleCount = listEleCount + 1
            print(list[i].eng!)
        }
        //問題数は決めておく M=100とおく。
        //問題の順序番号配列
        var orderArray = Array<Int>()
        for j in 0..<listEleCount{
            orderArray.append(j)
        }
        //問題の順序をランダムに変える
        //注意：間違った時の判定にlistを使っていると、
        //listは元のa,b,cの辞書順なので、間違えた単語ではなく、間違えたときのindexで
        //それを間違えた単語として表示してしまう。
        //解決法：表示にlistを使わず、問題配列を使う。そうすれば、間違いない
        
        for i in 0..<listEleCount{
            let rand = Int(arc4random()) % listEleCount
            let tempOrder = orderArray[i]
            orderArray[i] = orderArray[rand]
            orderArray[rand] = tempOrder
        }
        
        //正解kを回していくことで問題を進める
        //cNumはcorrect,dNumはdammy
        print(listEleCount)
        return orderArray
    }
    
    //間違えリスト
    //var gdummyProbList = Array<NewImageReibun>()
    
    //問題
    //correctArray（苦手だけで考えた数しかない）
    func originProblem4(correct:Int,M:Int)->Array<Int>{
        //k1が正解の番号
        //ダミーの決定 (4たくの場合)
        let currentArray = dummyArray[getCurrentArray(parts: list[correct].partOfSpeech!)]
        
        var dummyOptionArray = [-1,-1,-1]
        for n in 0..<3{
            //これでは最初の０回目が正解と同じになる場合がある
            var flag = 0
            while(flag == 0){
                let index = Int(arc4random_uniform(UInt32(currentArray.count))) + appDelegate.problemVolume
                dummyOptionArray [n] = index
                //今までのdummyと同じにならないようにする
                print(correctArray.count)
                print(dummyOptionArray[n]-appDelegate.problemVolume)
                if currentArray[dummyOptionArray[n]-appDelegate.problemVolume].jpn != list[correct].jpn{
                    flag = 1
                    for o in 0..<n{
                        if(dummyOptionArray [n] == dummyOptionArray [o]){
                            flag = 0
                        }
                    }
                }
            }
        }
        for n in 0..<3{
            print("dummyOptionArray [\(n)] = \(dummyOptionArray [n])")
        }
        print("correct = \(correct)")
        //correct,dummy,dummy,dummy
        let probArray = [correct,dummyOptionArray [0],dummyOptionArray [1],dummyOptionArray [2]]
        return probArray
    }
    
    //一問一問の表示順を変更
    func getLabelOrder(currentProbArray:Array<Int>
        )->Array<Int>{
        var probOrderArray = currentProbArray
        for i in 0..<20{
            let rand = Int(arc4random()) % 4
            let tempOrder = probOrderArray[i%4]
            probOrderArray[i%4] = probOrderArray[rand]
            probOrderArray[rand] = tempOrder
        }
        return probOrderArray
    }
    
    //var tangoEng = Array<String>()
    
    var gAllProbIndexes = Array<Array<Int>>()
    
    /*
     func makeAllProbArray()->Array<Array<Int>>{
     for k in 0 ..< correctArray.count{
     gAllProbIndexes.append(originProblem4(correct: correctArray[k],M:correctArray.count))
     correctArray[k] = gAllProbIndexes[k][0]
     for i in 0..<20{
     let rand = Int(arc4random()) % 4
     let tempOrder = gAllProbIndexes[k][i%4]
     gAllProbIndexes[k][i%4] = gAllProbIndexes[k][rand]
     gAllProbIndexes[k][rand] = tempOrder
     }
     }
     return gAllProbIndexes
     }
     */
    
    var existProblemIndex = 0
    
    func makeNextProblem()->Array<Int>{
        var nextProblem = originProblem4(correct: correctArray[k],M:correctArray.count)
        correctArray[k] = nextProblem[0]
        for i in 0..<10{
            let rand = Int(arc4random()) % 4
            let tempOrder = nextProblem[i%4]
            nextProblem[i%4] = nextProblem[rand]
            nextProblem[rand] = tempOrder
        }
        return nextProblem
    }
    
    func judgeAnswer(_ answer:Int){
        print(k,correctArray.count)
        if(k<correctArray.count){
            print("judgeAnswer:\(k)")
            if(gAllProbIndexes[k][answer] < appDelegate.problemVolume){
                // if(gAllProbIndexes[k][0] = correctArray[k]){
                //count = count + 1
                print("正解")
                wrongArray[k] = 0
                //wrongArray.append(0)
            }
            else{
                print("不正解")
                wrongArray[k] = 1
                
                //wrongArray.append(1)
            }
            if(k == correctArray.count-1){
                //print("正解数は\(count),正解率は\(Float(count)/Float(gLabelOrderArray.count))")
                //tangoEng = Array<String>()
                print(wrongArray.count)
                //getNewImageReibun(gdummyProbList)
            }
            k = k + 1
        }
    }
    
    var tango = Array<NewImageReibun>()
    
    func setResult(_ list:Array<NewImageReibun>){
        deleteFile(fileName: testWrongTangoArray[appDelegate.problemCategory
            ][appDelegate.chapterNumber])
        deleteFile(fileName: "correct")
        
        print("setResultwrong:\(wrongArray.count)")
        for k in 0..<wrongArray.count{
            if(wrongArray[k] == 1){
                writeSixFile(fileName:testWrongTangoArray[appDelegate.problemCategory
                    ][appDelegate.chapterNumber],eng:list[k].eng!,jpn:list[k].jpn!,engPhrase:list[k].engReibun!,jpnPhrase:list[k].jpnReibun!,nigateFlag:list[k].nigateFlag!,partOfSpeech:list[k].partOfSpeech!)
                print("wrongファイルセット完了？")
            }else{
                writeSixFile(fileName:"correct",eng:list[k].eng!,jpn:list[k].jpn!,engPhrase:list[k].engReibun!,jpnPhrase:list[k].jpnReibun!,nigateFlag:list[k].nigateFlag!,partOfSpeech:list[k].partOfSpeech!)
                print("correctファイルセット完了？")
            }
        }
    }
    //間違った単語を確認したかったようだが・・・
    func getNewImageReibun(_ list:Array<NewImageReibun>){
        /*
         for k1 in 0..<wrongArray.count{
         if(wrongArray[k1] == 1){
         print(wrongArray.count,correctArray.count)
         print(correctArray[k1])
         let correctEng = list[correctArray[k1]].eng!
         let correctJpn = list[correctArray[k1]].jpn!
         tangoEng.append(correctEng + "@" + correctJpn)
         //問題が順番通りの時
         //tangoEng.append(list[k].eng + "@" + list[k].jpn)
         }
         }
         for n in 0..<tangoEng.count{
         print(tangoEng[n])
         }
         */
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let nounProbFile = ["noun_prob_0"]
    let adjProbFile = ["adj_prob_0"]
    let adveProbFile = ["adve_prob_0"]
    let preProbFile = ["pre_prob_0"]
    let verbProbFIle = ["verb_prob_0"]
    
    func getFileNameOfParts(chap: Int, parts:String)->String{
        var fileName = String()
        switch parts{
        case "n":
            //本当はchapに応じた範囲でランダム決定
            fileName = nounProbFile[0]
        case "a":
            fileName = adjProbFile[0]
        case "av":
            fileName = adveProbFile[0]
        case "p":
            fileName = preProbFile[0]
        case "v":
            fileName = verbProbFIle[0]
        default:
            break
        }
        return fileName
    }
    
    func getCurrentArray(parts:String)->Int{
        var jpnArrayIdentifier = -1
        switch parts{
        case "n":
            //本当はchapに応じた範囲でランダム決定
            jpnArrayIdentifier = 0
        case "a":
            jpnArrayIdentifier = 1
        case "av":
            jpnArrayIdentifier = 2
        case "p":
            jpnArrayIdentifier = 3
        case "v":
            jpnArrayIdentifier = 4
        default:
            break
        }
        return jpnArrayIdentifier
    }
    
    func writePartsFile(parts:String,fileName:String){
        var readArray = readFileGetWordArray(fileName,extent:"txt")
        for r in 0..<readArray.count/6{
            if readArray[6*r+5] == parts {
                writeSixFile(fileName:getFileNameOfParts(chap:0, parts:parts),eng:readArray[6*r],jpn:readArray[6*r+1],engPhrase:readArray[6*r+2],jpnPhrase:readArray[6*r+3],nigateFlag:readArray[6*r+4],partOfSpeech:readArray[6*r+5])
          	 }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //ダミー配列の生成（２次元）
        let iterParts = ["n","a","av","p","v"]
        for i in 0..<iterParts.count{
            writePartsFile(parts:iterParts[i],fileName:"wrong_test_for_0")
            let array = getfile(fileName:getFileNameOfParts(chap:0,parts:iterParts[i]))
            //print(array.count)
            for r in 0..<array.count/6{
                dummyArray[i].append(Jpn(jpn: array[6*r+1]))
            }
        }
        
        labelProblem.layer.borderWidth = 1
        
        answerButton1.layer.borderWidth = 0
        answerButton1.layer.cornerRadius = 10
        answerButton2.layer.borderWidth = 0
        answerButton2.layer.cornerRadius = 10
        answerButton3.layer.borderWidth = 0
        answerButton3.layer.cornerRadius = 10
        answerButton4.layer.borderWidth = 0
        answerButton4.layer.cornerRadius = 10
        
        answerButton1.addTarget(self, action: #selector(pushAnswer1), for: .touchUpInside)
        answerButton2.addTarget(self, action: #selector(pushAnswer2), for: .touchUpInside)
        answerButton3.addTarget(self, action: #selector(pushAnswer3), for: .touchUpInside)
        answerButton4.addTarget(self, action: #selector(pushAnswer4), for: .touchUpInside)
        
        backProblemButton.layer.borderWidth = 0
        submitButton.layer.borderWidth = 0
        backPageButton.layer.borderWidth = 0
        backProblemButton.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 10
        backPageButton.layer.cornerRadius = 10
        backProblemButton.addTarget(self, action: #selector(goPrevProblem), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        backPageButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        
        // labelAnswer1.layer.borderWidth = 1
        // labelAnswer2.layer.borderWidth = 1
        // labelAnswer3.layer.borderWidth = 1
        // labelAnswer4.layer.borderWidth = 1
        
        //let chapterNumber = appDelegate.chapterNumber
        // let fileName = [chapterArray[chapterNumber]]
        
        //出題する分のファイルを読み込む（答えの分）
        var fileName = String()
        var tango = Array<String>()
        if appDelegate.modeTag == 0{
            fileName = testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            tango = readFileGetWordArray(fileName, extent: "txt")
            //print("tokui")
        }else if appDelegate.modeTag == 1{
            fileName = testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber]
            tango = getfile(fileName:fileName)
            //print("nigate")
        }else if appDelegate.modeTag == 2{
            fileName = testWrongTangoArray[appDelegate.problemCategory
                ][appDelegate.chapterNumber]
            tango = getfile(fileName:fileName)
            //print("wrong")
        }else{
            
        }
        //print(appDelegate.modeTag)
        // print("number of tango = \(tango.count)")
        for r in 0..<tango.count/6{
            //print(hash)
            list.append(NewImageReibun(eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5]))
        }
        /*
         for i in 0..<list.count{
         print(list[i].eng!,list[i].jpn!)
         //probVolume += 1
         }
         */
        
        //print("\n\n")
        
        wrongArray = Array<Int>(repeating:1,count:tango.count/6)
        //print("wrong:\(wrongArray.count)")
        
        
        //tableView用の英単語＋日本語配列を作成
        //chap一個ごとの問題の順序決定gProbOrderArray
        correctArray = setProblemOrder()
        
        //ここまでは出題したい問題ファイルに「のみ」依存
        
        gAllProbIndexes.append(makeNextProblem())
        
        gLabelOrderArray = getLabelOrder(currentProbArray: gAllProbIndexes[0])
        //ラベルを表示する
        setLabel()
        print("succeed!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
