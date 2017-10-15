//
//  NewProblemResultVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class ProblemResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let sections = ["間違った問題","正解した問題"]
       
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backSerectButton: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var goNextProblem: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    
    @IBAction func backButton2(_ sender: Any) {
        backToSelect()
    }
    
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //progressVCを表示
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        let wrongArray = getTangoArrayFromFile(fileName:WRONG_FILE_NAMES[appDelegate.problemCategory
            ][appDelegate.chapterNumber*5+appDelegate.setsuNumber])
        let correctArray = getTangoArrayFromFile(fileName: "correct")
        
        print(wrongArray.count/6)
        print(correctArray.count/6)
        print("ファイルゲット完了?")
        
        for r in 0..<wrongArray.count/7{
            wrongList.append(SixWithChapter(eng:wrongArray[7*r],jpn:wrongArray[7*r+1],engReibun:wrongArray[7*r+2],jpnReibun:wrongArray[7*r+3],nigateFlag: wrongArray[7*r+4],partOfSpeech:wrongArray[7*r+5],chapterNumber:wrongArray[7*r+6]))
        }
        
        for r in 0..<correctArray.count/7{
            correctList.append(SixWithChapter(eng:correctArray[7*r],jpn:correctArray[7*r+1],engReibun:correctArray[7*r+2],jpnReibun:correctArray[7*r+3],nigateFlag: correctArray[7*r+4],partOfSpeech:correctArray[7*r+5],chapterNumber:correctArray[7*r+6]))
        }
        
        //苦手ラベルをつけるために苦手を参照
        let nigateArray:Array<String> = getTangoArrayFromFile(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber])
        
        //苦手配列の英語と同じ英語に苦手ラベルづけcorrect
        for r in 0..<nigateArray.count/6{
            if nigateArray[6*r+4] == "1"{
                for i in 0..<correctList.count{
                    if(nigateArray[6*r] == correctList[i].eng){
                        correctList[i].nigateFlag = "1"
                    }
                }
            }
        }
        
        //苦手配列の英語と同じ英語に苦手ラベルづけwrong
        for r in 0..<nigateArray.count/6{
            if nigateArray[6*r+4] == "1"{
                for i in 0..<wrongList.count{
                    if(nigateArray[6*r] == wrongList[i].eng){
                        wrongList[i].nigateFlag = "1"
                    }
                }
            }
        }
        
        
        var wrongCount:Int = 0
        
        for _ in 0..<wrongList.count{
            print("wrongcount : \(wrongList.count)")
            wrongCount += 1
        }
        print(wrongCount)
        
        //tableViewセルに追加していく
        
        for r in 0..<wrongArray.count/7{
            print("wrong")
            wrongCell.append(resultTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            )
            wrongCell[r].setCell(wrongList[r],chapterSetsuNumber:wrongList[r].chapterNumber!)
        }
        
        
        for r in 0..<correctArray.count/7{
            print("correct")
            correctCell.append(resultTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            )
            correctCell[r].setCell(correctList[r],chapterSetsuNumber:correctList[r].chapterNumber!)
        }
        
        for j in 0..<correctList.count{
            print(correctList[j])
        }
        
        //各種ラベル・ボタンの設定
        
        //scoreLabel.text = "正解率 : "+String(wrongArray.count/6+correctArray.count/6 - wrongCount)+" / "+String(wrongArray.count/6+correctArray.count/6)
        let correctCount = wrongArray.count/7+correctArray.count/7 - wrongCount
        let problemCount = wrongArray.count/7+correctArray.count/7
        scoreLabel.text = "正解率 : "+String(correctCount)+" / "+String(problemCount)
        
        makeFinishLabel(incorrectCount : wrongCount,problemVolume:wrongArray.count/6+correctArray.count/6)
        judgeAndWriteNewChapter(incorrectCount :wrongCount,problemVolume:wrongArray.count/6+correctArray.count/6)
        showPopUpProgressView()
        
        goNextProblem.layer.borderWidth = 0
        goNextProblem.layer.cornerRadius = 10
        backSerectButton.layer.borderWidth = 0
        backSerectButton.layer.cornerRadius = 10
        retryButton.layer.borderWidth = 0
        retryButton.layer.cornerRadius = 10
        storyButton.layer.borderWidth = 0
        storyButton.layer.cornerRadius = 10
        
        retryButton.addTarget(self, action: #selector
            (retryProblem), for: .touchUpInside)
        
        backSerectButton.addTarget(self, action: #selector
            (backToSelect), for: .touchUpInside)
        
        //ボタンをタップした時に実行するメソッドを指定
        goNextProblem.addTarget(self, action: #selector
            (goNext), for: .touchUpInside)
        if(appDelegate.chapterNumber*5+appDelegate.setsuNumber >= NORMAL_FILE_NAMES[appDelegate.problemCategory].count-1){
            print(appDelegate.chapterNumber*5+appDelegate.setsuNumber)
            print(NORMAL_FILE_NAMES[appDelegate.problemCategory].count-1)
            goNextProblem.layer.backgroundColor = UIColor.gray.cgColor
            goNextProblem.isEnabled = false
        }
        
        let newChapterNumber = getNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], chapterVolume: NORMAL_FILE_NAMES[appDelegate.problemCategory].count)
        
        if(newChapterNumber > appDelegate.chapterNumber*5+appDelegate.setsuNumber){
            //次のchapterを調べるので、次があることを確認する
            if(appDelegate.modeTag == 1){
                if(appDelegate.chapterNumber*5+appDelegate.setsuNumber < NIGATE_FILE_NAMES[appDelegate.problemCategory].count-1){
                    if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber+1]) == 0{
                        goNextProblem.layer.backgroundColor = UIColor.gray.cgColor
                        goNextProblem.isEnabled = false
                    }
                }
            }
            
            //これおかしい。if文でNIGATE_FILE_NAMESつかっているのに後でWRONG_FILE_NAMES使ってる。
            if(appDelegate.modeTag == 2){
                if(appDelegate.chapterNumber*5+appDelegate.setsuNumber < NIGATE_FILE_NAMES[appDelegate.problemCategory].count-1){
                    if getWrongTangoVolume(fileName:WRONG_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber+1]) == 0{
                        goNextProblem.layer.backgroundColor = UIColor.gray.cgColor
                        goNextProblem.isEnabled = false
                    }
                }
            }
        }
        resultTableView.rowHeight = self.view.bounds.size.height/9
    }

    
    
    
    var tangoNumber = 0
    
    var gtangoRow:Int = 0
    var gtangoColumn:Int = 0
    //var wrongList = Array<NewImageReibun>()
    //var correctList = Array<NewImageReibun>()
    var wrongList = Array<SixWithChapter>()
    var correctList = Array<SixWithChapter>()
    
    
    func makeFinishLabel(incorrectCount : Int,problemVolume:Int){
        // Labelを生成.
        var comment:[String] = ["",""]
        print(incorrectCount)
        print(100*incorrectCount/problemVolume)
        //正解率が80パーセント以上で合格。writeNewChapterする
        if(100*incorrectCount/problemVolume == 0){
            comment[0] = "Perfect"
            comment[1] = ""
            resultImage.image = UIImage(named: "90ten.jpg")
            appDelegate.isProblemCleared = true
            //writeNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber*5+appDelegate.setsuNumber, chapterVolume: NIGATE_FILE_NAMES[appDelegate.problemCategory].count)
        }else if(100*incorrectCount/problemVolume <= 10 && 100*incorrectCount/problemVolume > 0){
            comment[0] = "Excellent"
            comment[1] = ""
            resultImage.image = UIImage(named: "80ten.jpg")
            appDelegate.isProblemCleared = true
            //writeNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber*5+appDelegate.setsuNumber, chapterVolume: NIGATE_FILE_NAMES[appDelegate.problemCategory].count)
        }else if(100*incorrectCount/problemVolume <= 20 && 100*incorrectCount/problemVolume > 10 ){
            comment[0] = "Good"
            comment[1] = ""
            resultImage.image = UIImage(named: "70ten.jpg")
            appDelegate.isProblemCleared = true
            //writeNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber*5+appDelegate.setsuNumber, chapterVolume: NIGATE_FILE_NAMES[appDelegate.problemCategory].count)
        }else if(100*incorrectCount/problemVolume <= 30  && 100*incorrectCount/problemVolume > 20){
            comment[0] = "Not Bad"
            comment[1] = ""
            resultImage.image = UIImage(named: "60ten.jpg")
            appDelegate.isProblemCleared = false
        }else if(100*incorrectCount/problemVolume > 30){
            comment[0] = "No Sence"
            comment[1] = ""
            resultImage.image = UIImage(named: "50ten.jpg")
            appDelegate.isProblemCleared = false
        }
        print("値は\(100*incorrectCount/problemVolume)")
        print(comment[0])
    }
    
    func judgeAndWriteNewChapter(incorrectCount : Int,problemVolume:Int){
        if(appDelegate.modeTag == 0){
            print("appDelegate.chapterNumber*5+appDelegate.setsuNumber: \(appDelegate.chapterNumber*5+appDelegate.setsuNumber)")
            if(100*incorrectCount/problemVolume == 0){
                writeNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber*5+appDelegate.setsuNumber, chapterVolume: NIGATE_FILE_NAMES[appDelegate.problemCategory].count)
            }else if(100*incorrectCount/problemVolume <= 10 && 100*incorrectCount/problemVolume > 0){
                writeNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber*5+appDelegate.setsuNumber, chapterVolume: NIGATE_FILE_NAMES[appDelegate.problemCategory].count)
            }else if(100*incorrectCount/problemVolume <= 20 && 100*incorrectCount/problemVolume > 10 ){
                writeNewChapter(fileName: checkNewChapterFileNames[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber*5+appDelegate.setsuNumber, chapterVolume: NIGATE_FILE_NAMES[appDelegate.problemCategory].count)
            }
        }
    }
    
    func writeNewChapter(fileName:String,clearedChapterNumber:Int,chapterVolume:Int){
        print("writeNewChapter")
        deleteFile(fileName:fileName)
        var chapterNumber = 0
        let path = defaultTextFileDirectoryPath
        
        // -- start check directory --
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        
        if !isDir.boolValue{
            try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
        }
        
        // 保存するもの
        var fileObject:String = ""
        for i in 0..<chapterVolume{
            //appDelegate.chapterNumber*5+appDelegate.setsuNumberも0から始まるので、if文は等号付き不等号になる
            if i <= clearedChapterNumber {
                fileObject = fileObject+"1"
            }else{
                fileObject = fileObject+"0"
            }
        }
        let filepath1 = "\(path)/\(fileName+".txt")"
        let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
        // 保存処理 先のdeletefileで必ず消されているので、ここに必ず入る
        if(filew == nil){
            try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
        }else{
            print("file had not been deleted, deleteFile method did not work!")
        }
        filew?.closeFile()
        
        //読み込み用で開くforReadingAtPath
        let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
        if filer == nil {
            print("File open failed, cant set cleared chapter number!")
        } else {
            filer?.seekToEndOfFile()
            let endOffset = (filer?.offsetInFile)!
            filer?.seek(toFileOffset: 0)
            let databuffer = filer?.readData(ofLength: Int(endOffset))
            // NSData to String
            let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
            // if judgeMatch(cWord: list[gtangoRow][gtangoColumn].eng, str:out){
            for s in out.characters{
                if(s == "0"){//未クリアの
                    break
                }else if s == "1" && chapterNumber == chapterVolume{
                    break //全てクリア済みの時は、存在しない次のchapternumberまでいかないように、ここで食い止める。
                }
                chapterNumber += 1//0章がクリアされた時、1になる。つまり、newchapternumberと基本は一致する。
            }
            filer?.closeFile()
        }
        //ちゃんとセットされたかの確認。実際にはいらない
        print(chapterNumber)
    }
    
    func showPopUpProgressView(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "problemResultProgress") as! ProblemResultProgressVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        print("popOverVC : \(popOverVC.view.frame)")
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        if(section == 0){
            return wrongList.count
        }
        else{
            return correctList.count
        }
    }
    
    /*
     セクションの数を返す.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /*
     セクションのタイトルを返す.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return sections[section]
        }else{
            return sections[section]
        }
    }

    
    var wrongCell = Array<ListCell>()
    var correctCell = Array<ListCell>()
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return wrongCell[indexPath.row]
        } else{
            //if indexPath.section == 1 {
            return correctCell[indexPath.row]
        }
    }
    
    func goProblem(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newProblem") as!  ProblemVC
        // Viewの移動する.
        //UIApplication.shared.keyWindow?.rootViewController = secondViewController
        //こちらはエラーwhose view is not in window hierarky
           self.present(secondViewController, animated: true, completion: nil)
    }
    
    @objc func goNext(){
        if(appDelegate.chapterNumber*5+appDelegate.setsuNumber < NORMAL_FILE_NAMES[appDelegate.problemCategory].count-1 ){
            if appDelegate.setsuNumber == 4{
                appDelegate.chapterNumber += 1
                appDelegate.setsuNumber = 0
            }else{
                appDelegate.setsuNumber += 1
            }
            goProblem()
        }
    }
    
    @objc func retryProblem(){
        goProblem()
    }
    
    //goStoryはstoryboard上で実装
    
    @objc func backToSelect(){
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "確認", message: "範囲選択画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            /*
            let secondViewController: CategorySelectVC = self.storyboard?.instantiateViewController(withIdentifier:"categorySelect") as! CategorySelectVC
            // アニメーションを設定する.
            //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            // 値渡ししたい時 hoge -> piyo
            //secondViewController.piyo = self.hoge
            // Viewの移動する.
            self.present(secondViewController, animated: true, completion: nil)
 */
        backNearestNaviVC(currentVC:self)
            
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
