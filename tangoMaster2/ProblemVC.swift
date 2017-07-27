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
    
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var labelProblem: UILabel!
    
    //ラスタ操作で１、２、３、４
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    @IBOutlet weak var backProblemButton: UIButton!
    //@IBOutlet weak var backPageButton: UIButton!
    
    
       
    @IBAction func backButton2(_ sender: Any) {
        backPage()
    }
    
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    

/*
    func getFileNameOfParts(parts:String)->String{
        let fileName = parts
        /*
        var fileName = String()
        switch parts{
        case "n":
            fileName = "dummy_noun"
        case "a":
            fileName = "dummy_adj"
        case "av":
            fileName =  "dummy_adve"
        case "v":
            fileName = "dummy_verb"
        case "o":
            fileName = "dummy_other"
        default:
            break
        }
 */
        return fileName
    }
  */
    //本当はchapに応じた範囲でランダム決定したいので、chap引数も追加したい。
    func partsToIndex(parts:String)->Int{
        var jpnArrayIdentifier = -1
        print("parts : \(parts)")
        switch parts{
        case "n":
            //本当はchapに応じた範囲でランダム決定
            jpnArrayIdentifier = 0
        case "a":
            jpnArrayIdentifier = 1
        case "av":
            jpnArrayIdentifier = 2
        case "v":
            jpnArrayIdentifier = 3
        case "o":
            jpnArrayIdentifier = 4
        default:
            print("return -1! may ber error occur!")
            break
        }
        return jpnArrayIdentifier
    }
   /*
    func writePartsFileFromDataFile(parts:String,fileName:String){
        var readArray = readFileGetWordArray(fileName,extent:"txt",inDirectory: "tango/seedtango")
        for r in 0..<readArray.count/6{
            if readArray[6*r+5] == parts {
                writeSixFile(fileName:getFileNameOfParts(chap:0, parts:parts),eng:readArray[6*r],jpn:readArray[6*r+1],engPhrase:readArray[6*r+2],jpnPhrase:readArray[6*r+3],nigateFlag:readArray[6*r+4],partOfSpeech:readArray[6*r+5])
            }
        }
    }
*/
    var dummyArray = Array<Array<Jpn>>(repeating:[],count:5)
    
    override func viewWillAppear(_ animated: Bool) {
        
        //ダミー配列の生成（２次元） 非常にややこしい構成である
        //まず最初にwrong_test_for_0.txtから各partsに応じたファイルに対してpartsの情報を書き込む。
        //このpartsofspeechファイル群は、のちにdummyArrayに使用される。今回はデモなのでいちいち作成しているが、
        //実際にはpythonのプログラムなどであらかじめpartsごとのファイルを作成しておき、それをはじめからiosプロジェクトにいれておくという方法を取るのが良いと思われる。
        /*
        let iterParts = ["n","a","av","p","v","c","aux"]
        for i in 0..<iterParts.count{
            writePartsFileFromDataFile(parts:iterParts[i],dummyTextArray:dummyText)
            let array = getfile(fileName:getFileNameOfParts(chap:0,parts:iterParts[i]))
            //print(array.count)
            for r in 0..<array.count/6{
                //dummyArrayのrowごとに各partsが入っている。取り出すために、partsToIndexがある
                dummyArray[i].append(Jpn(jpn: array[6*r+1]))
            }
        }
        */
        let partsOfSpeechCodes:Array<String> = ["n","a","av","v","o"]//各品詞を集めたファイル
        var array = Array<Array<String>>(repeating:[],count:5)
        for i in 0..<partsOfSpeechCodes.count{
            array[i] = readFileGetWordArray(partsOfSpeechCodes[i], extent: "txt", inDirectory:"tango/dummy")
            for r in 0..<array[i].count/6{
                //dummyArrayのrowごとに各partsが入っている。取り出すために、partsToIndexがある
                dummyArray[i].append(Jpn(jpn: array[i][6*r+1]))
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
        //backPageButton.layer.borderWidth = 0
        backProblemButton.layer.cornerRadius = 10
        //backPageButton.layer.cornerRadius = 10
        backProblemButton.addTarget(self, action: #selector(goPrevProblem), for: .touchUpInside)
        //backPageButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        
        
        //出題する分のファイルを読み込む（答えの分）
        var fileName = String()
        var tango = Array<String>()
        if appDelegate.modeTag == 0{
            fileName = fileNames[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber]
            tango = readFileGetWordArray(fileName, extent: "txt",inDirectory: "tango/seedtango")
            for r in 0..<tango.count/6{
                sevenList.append(SixWithChapter(eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5],chapterNumber: String(appDelegate.chapterNumber*5+appDelegate.setsuNumber)))
            }
            //print("tokui")
        //単一の苦手節に対してのProblem
        }else if appDelegate.modeTag == 1{
            fileName = nigateFileNames[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber]
            tango = getfile(fileName:fileName)
            for r in 0..<tango.count/6{
                sevenList.append(SixWithChapter(eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5],chapterNumber: String(appDelegate.chapterNumber*5+appDelegate.setsuNumber)))
            }
            for seven in sevenList{
                print(seven.eng!,seven.jpn!,seven.engReibun!,seven.jpnReibun!,seven.nigateFlag!,seven.partOfSpeech!)
            }
        
        //苦手chpaterの全範囲のProblem
        }else if appDelegate.modeTag == 2{
            for setsu in 0..<5{
                for chapter in 0..<chapterNames[appDelegate.problemCategory].count{
                    fileName = nigateFileNames[appDelegate.problemCategory
                        ][chapter*5+setsu]
                    let tempTango = getfile(fileName:fileName)
                    for j in tempTango{
                        print(j)
                    }
                    tango = tango + tempTango
                    for r in 0..<tempTango.count/6{
                        sevenList.append(SixWithChapter(eng: tempTango[6*r],jpn:tempTango[6*r+1],engReibun:tempTango[6*r+2],jpnReibun:tempTango[6*r+3],nigateFlag: tempTango[6*r+4],partOfSpeech:tempTango[6*r+5],chapterNumber:String(chapter*5+setsu)))
                    }
                }
            }
            for j in tango{
                print(j)
            }
        }else{
            
        }
        
        wrongArray = Array<Int>(repeating:1,count:tango.count/6)
        //print("wrong:\(wrongArray.count)")
        
        
        //tableView用の英単語＋日本語配列を作成
        //chap一個ごとの問題の順序決定gProbOrderArray
        correctArray = setProblemOrder()
        
        //ここまでは出題したい問題ファイルに「のみ」依存
        
        gAllProbIndexes.append(mekeProblemIndexK())
        
        gLabelOrderArray = getLabelOrder(currentProbArray: gAllProbIndexes[0])
        //ラベルを表示する
        setLabel()
        print("succeed!")
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
    
    //var list = Array<NewImageReibun>()
    var sevenList = Array<SixWithChapter>()
    //var nigateList = Array<NewImageReibun>()
    //問題リストファイルを選択 問題番号とファイル名を対応させておく。
    
    
    
    var count = 0
    var wrongArray = Array<Int>()
    
    
    //問題の個数調査・順序決定
    func setProblemOrder()->Array<Int>{
        print("問題が進んでいます!")
        var listEleCount = 0
        for i in 0..<sevenList.count{
            listEleCount = listEleCount + 1
            print(sevenList[i].eng!)
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
            let rand = Int(arc4random_uniform(UInt32(UInt(listEleCount))))
            let tempOrder = orderArray[i]
            orderArray[i] = orderArray[rand]
            orderArray[rand] = tempOrder
        }
        
        //正解kを回していくことで問題を進める
        //cNumはcorrect,dNumはdammy
        print(listEleCount)
        return orderArray
    }

    var gAllProbIndexes = Array<Array<Int>>()
    
    
    var existProblemIndex = 0
    
    func mekeProblemIndexK()->Array<Int>{
        var nextProblem:Array<Int> = originProblem4(correct: correctArray[k],M:correctArray.count)
        correctArray[k] = nextProblem[0]
        for i in 0..<10{
            let rand = Int(arc4random_uniform(4))
            let tempOrder = nextProblem[i%4]
            nextProblem[i%4] = nextProblem[rand]
            nextProblem[rand] = tempOrder
        }
        return nextProblem
    }

    
    //問題
    //correctArray（苦手だけで考えた数しかない）
    func originProblem4(correct:Int,M:Int)->Array<Int>{
        //k1が正解の番号
        //ダミーの決定 (4たくの場合)
        print("dummy : \(dummyArray.count)")
        print("seven : \(sevenList.count)")
        let currentArray = dummyArray[partsToIndex(parts: sevenList[correct].partOfSpeech!)]
        
        var dummyOptionArray = [-1,-1,-1]
        for n in 0..<3{
            //これでは最初の０回目が正解と同じになる場合がある
            var flag = 0
            while(flag == 0){
                let index = Int(arc4random_uniform(UInt32(currentArray.count))) + appDelegate.problemVolume
                dummyOptionArray [n] = index
                //今までのdummyと同じにならないようにする
                print(currentArray.count)
                print(dummyOptionArray[n]-appDelegate.problemVolume)
                print(sevenList.count)
                if currentArray[dummyOptionArray[n]-appDelegate.problemVolume].jpn != sevenList[correct].jpn{
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
    
    //一問一問の4択の表示順を変更。初期状態では0が正解になっている
    func getLabelOrder(currentProbArray:Array<Int>
        )->Array<Int>{
        var probOrderArray = currentProbArray
        for i in 0..<20{
            let rand = Int(arc4random_uniform(4))
            let tempOrder = probOrderArray[i%4]
            probOrderArray[i%4] = probOrderArray[rand]
            probOrderArray[rand] = tempOrder
        }
        return probOrderArray
    }
    
    func setLabel(){
        print(gAllProbIndexes[k])
        for i in 0..<sevenList.count{
            print(sevenList[i].eng!,sevenList[i].jpn!)
        }
        //正解の要素だけは問題数で引き算した時に負になる。負にならないもののみ引き算を行う
        
        var wrongFlag = [false,false,false,false]
        
        var currentJpnArray = Array<Jpn>()
        
        if gAllProbIndexes[k][0] != correctArray[k]{
            gAllProbIndexes[k][0] -= appDelegate.problemVolume
            wrongFlag[0] = true
            currentJpnArray = dummyArray[partsToIndex(parts:sevenList[correctArray[k]].partOfSpeech!)]
            answerButton1.setTitle(currentJpnArray[gAllProbIndexes[k][0]].jpn!, for: .normal)
        }else{
            answerButton1.setTitle(sevenList[gAllProbIndexes[k][0]].jpn!, for: .normal)
        }
        
        if gAllProbIndexes[k][1] != correctArray[k]{
            gAllProbIndexes[k][1] -= appDelegate.problemVolume
            wrongFlag[1] = true
            currentJpnArray = dummyArray[partsToIndex(parts:sevenList[correctArray[k]].partOfSpeech!)]
            answerButton2.setTitle(currentJpnArray[gAllProbIndexes[k][1]].jpn!, for: .normal)
        }else{
            answerButton2.setTitle(sevenList[gAllProbIndexes[k][1]].jpn!, for: .normal)
        }
        
        if gAllProbIndexes[k][2] != correctArray[k]{
            gAllProbIndexes[k][2] -= appDelegate.problemVolume
            wrongFlag[2] = true
            currentJpnArray = dummyArray[partsToIndex(parts:sevenList[correctArray[k]].partOfSpeech!)]
            answerButton3.setTitle(currentJpnArray[gAllProbIndexes[k][2]].jpn!, for: .normal)
        }else{
            answerButton3.setTitle(sevenList[gAllProbIndexes[k][2]].jpn!, for: .normal)
        }
        
        if gAllProbIndexes[k][3] != correctArray[k]{
            gAllProbIndexes[k][3] -= appDelegate.problemVolume
            wrongFlag[3] = true
            currentJpnArray = dummyArray[partsToIndex(parts:sevenList[correctArray[k]].partOfSpeech!)]
            answerButton4.setTitle(currentJpnArray[gAllProbIndexes[k][3]].jpn!, for: .normal)
        }else{
            answerButton4.setTitle(sevenList[gAllProbIndexes[k][3]].jpn!, for: .normal)
        }
        
        labelProblem.text = "\(sevenList[correctArray[k]].eng!)"
        
        for i in 0...3{
            if wrongFlag[i]{
                gAllProbIndexes[k][i] += appDelegate.problemVolume
            }
        }
        
        progress.text = String(k+1) + "/" + String(wrongArray.count)
    }
    
    
    func goPrevProblem() {
        if(k>0){
            k -= 1
            setLabel()
        }
    }
    
    
    func answerButton(){
        if(k < correctArray.count){
            if k > existProblemIndex{
                gAllProbIndexes.append(mekeProblemIndexK())
                existProblemIndex = k
            }
            setLabel()
        }
        if(k == correctArray.count){
            submit()
        }
    }


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
    
    func submit(){
        print("submit")
        //結果の保存
        self.setResult(self.sevenList)
        let secondViewController: ProblemResultVC = self.storyboard?.instantiateViewController(withIdentifier: "newProblemResult") as! ProblemResultVC
        self.present(secondViewController, animated: true, completion: nil)
    }
    
   
    
    //var tango = Array<NewImageReibun>()
    var tango = Array<SixWithChapter>()
    
    func setResult(_ sevenList:Array<SixWithChapter>){
        deleteFile(fileName: incorrectFileNames[appDelegate.problemCategory
            ][appDelegate.chapterNumber*5+appDelegate.setsuNumber])
        deleteFile(fileName: "correct")
        
        
        
        print("setResultwrong:\(wrongArray.count)")
        for k in 0..<wrongArray.count{
            if(wrongArray[k] == 1){
                //writeSixFile(fileName:incorrectFileNames[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber],eng:sevenList[correctArray[k]].eng!,jpn:sevenList[correctArray[k]].jpn!,engPhrase:sevenList[correctArray[k]].engReibun!,jpnPhrase:sevenList[correctArray[k]].jpnReibun!,nigateFlag:sevenList[correctArray[k]].nigateFlag!,partOfSpeech:sevenList[correctArray[k]].partOfSpeech!)
                writeSevenFile(fileName:incorrectFileNames[appDelegate.problemCategory
                ][appDelegate.chapterNumber*5+appDelegate.setsuNumber],eng:sevenList[correctArray[k]].eng!,jpn:sevenList[correctArray[k]].jpn!,engPhrase:sevenList[correctArray[k]].engReibun!,jpnPhrase:sevenList[correctArray[k]].jpnReibun!,nigateFlag:sevenList[correctArray[k]].nigateFlag!,partOfSpeech:sevenList[correctArray[k]].partOfSpeech!,chapterNumber:sevenList[correctArray[k]].chapterNumber!)
                print("wrongファイルセット完了？")
            }else{
                //writeSixFile(fileName:"correct",eng:sevenList[correctArray[k]].eng!,jpn:sevenList[correctArray[k]].jpn!,engPhrase:sevenList[correctArray[k]].engReibun!,jpnPhrase:sevenList[correctArray[k]].jpnReibun!,nigateFlag:sevenList[correctArray[k]].nigateFlag!,partOfSpeech:sevenList[correctArray[k]].partOfSpeech!)
                writeSevenFile(fileName:"correct",eng:sevenList[correctArray[k]].eng!,jpn:sevenList[correctArray[k]].jpn!,engPhrase:sevenList[correctArray[k]].engReibun!,jpnPhrase:sevenList[correctArray[k]].jpnReibun!,nigateFlag:sevenList[correctArray[k]].nigateFlag!,partOfSpeech:sevenList[correctArray[k]].partOfSpeech!,chapterNumber:sevenList[correctArray[k]].chapterNumber!)
                print("correctファイルセット完了？")
            }
        }
    }
    
    
    func backPage(){
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
            //self.dismiss(animated: true, completion: nil)
            backNearestNaviVC(currentVC:self)
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
        // Dispose of any resources that can be recreated.
    }
}
