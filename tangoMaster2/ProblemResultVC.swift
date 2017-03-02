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
    
    
  
    
    var tangoNumber = 0
    
    var gtangoRow:Int = 0
    var gtangoColumn:Int = 0
    var wrongList = Array<NewImageReibun>()
    var correctList = Array<NewImageReibun>()
    
     func getWordArrayFromString(str:String)->Array<String>{
        var wordArray = Array<String>()
        wordArray.append("")
        var j:Int = 0
        for s in str.characters{
            if(s != "@" && s != "\n"){
                wordArray[j] += String(s)
            }
            else{
                wordArray.append("")
                j += 1
            }
        }
        for p in 0..<j{
            print(wordArray[p])
        }
        return wordArray
    }
    
    
    func makeFinishLabel(retryCount : Int,problemVolume:Int){
        
        // Labelを生成.
        var comment:[String] = ["",""]
        print(retryCount)
        print(100*retryCount/problemVolume)
        //正解率が80パーセント以上で合格。setNewChapterする
        if(100*retryCount/problemVolume == 0){
            comment[0] = "Perfect"
            comment[1] = ""
            resultImage.image = UIImage(named: "90ten.jpg")
            setNewChapter(fileName: checkFileNamesArray[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber, chapterVolume: testNigateFileNamesArray[appDelegate.problemCategory].count)
        }else if(100*retryCount/problemVolume <= 10 && 100*retryCount/problemVolume > 0){
            comment[0] = "Excellent"
            comment[1] = ""
            resultImage.image = UIImage(named: "80ten.jpg")
            setNewChapter(fileName: checkFileNamesArray[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber, chapterVolume: testNigateFileNamesArray[appDelegate.problemCategory].count)
        }else if(100*retryCount/problemVolume <= 20 && 100*retryCount/problemVolume > 10 ){
            comment[0] = "Good"
            comment[1] = ""
            resultImage.image = UIImage(named: "70ten.jpg")
            setNewChapter(fileName: checkFileNamesArray[appDelegate.problemCategory], clearedChapterNumber: appDelegate.chapterNumber, chapterVolume: testNigateFileNamesArray[appDelegate.problemCategory].count)
        }else if(100*retryCount/problemVolume <= 30  && 100*retryCount/problemVolume > 20){
            comment[0] = "Not Bad"
            comment[1] = ""
            resultImage.image = UIImage(named: "60ten.jpg")
        }else if(100*retryCount/problemVolume > 30){
            comment[0] = "No Sence"
            comment[1] = ""
            resultImage.image = UIImage(named: "50ten.jpg")
        }
        print("値は\(100*retryCount/problemVolume)")
        print(comment[0])
        
        //コメントは使わないのでlabelへの代入部分は削除
        
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
        UIApplication.shared.keyWindow?.rootViewController = secondViewController
        //こちらはエラーwhose view is not in window hierarky
        //   self.present(secondViewController, animated: true, completion: nil)
    }
    
    func goNext(){
        if(appDelegate.chapterNumber < testFileNamesArray[appDelegate.problemCategory].count-1 ){
            appDelegate.chapterNumber += 1
            goProblem()
        }
    }
    
    func retryProblem(){
        goProblem()
    }
    
    func backToSelect(){
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "確認", message: "問題選択画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let secondViewController: CategorySelectVC = self.storyboard?.instantiateViewController(withIdentifier:"categorySelect") as! CategorySelectVC
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
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNewChapter(fileName:String,clearedChapterNumber:Int,chapterVolume:Int){
        deleteFile(fileName:fileName)
        var chapterNumber = 0
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
        
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
            //appDelegate.chapterNumberも0から始まるので、if文は等号付き不等号になる
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //progressVCを表示
        showPopUpProgressView()
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
       
        let wrongArray = getfile(fileName:testWrongTangoArray[appDelegate.problemCategory
            ][appDelegate.chapterNumber])
        let correctArray = getfile(fileName: "correct")
        
        print(wrongArray.count/6)
        print(correctArray.count/6)
        print("ファイルゲット完了?")
        
        for r in 0..<wrongArray.count/6{
            wrongList.append(NewImageReibun(eng:wrongArray[6*r],jpn:wrongArray[6*r+1],engReibun:wrongArray[6*r+2],jpnReibun:wrongArray[6*r+3],nigateFlag: wrongArray[6*r+4],partOfSpeech:wrongArray[6*r+5]))
        }
        
        for r in 0..<correctArray.count/6{
            correctList.append(NewImageReibun(eng:correctArray[6*r],jpn:correctArray[6*r+1],engReibun:correctArray[6*r+2],jpnReibun:correctArray[6*r+3],nigateFlag: correctArray[6*r+4],partOfSpeech:correctArray[6*r+5]))
        }
        
        //ここではwrongArray = wordArray
        /*
        //数だけ違うけど、ハッシュがnigateもしくはcorrectで違う。
        //つまり、今まではハッシュが異なっていたから問題はなかったが、ハッシュ値が同じ値が出てくるとその重複分を読み込んでしまう。
        // print("number of tango = \(tango.count)")
        for r in 0..<wrongArray.count/8{
            let hash = getHashNum(wrongArray[6*r])
            //print(hash)
            list[hash] = addListJpnEngImageReibun(list: list,eng: wrongArray[6*r],jpn:wrongArray[6*r+1],imgPath:wrongArray[6*r+2],engReibun:wrongArray[6*r+3],jpnReibun:wrongArray[6*r+4],nigateFlag: wrongArray[6*r+5],partsOfSpeech: wrongArray[6*r+6],soundPath:wrongArray[6*r+7])
        }
        //同じリストが引数のaddListJpnEngIamgeReibunをつかってりう。
        //既存リストは上で更新されている。それを流用
        print("correct:\(correctArray.count/8)")
        
        for r in 0..<correctArray.count/8{
            let hash = getHashNum(correctArray[6*r])
            correctlist[hash] = addListJpnEngImageReibun(list: correctlist,eng: correctArray[6*r],jpn:correctArray[6*r+1],imgPath:correctArray[6*r+2],engReibun:correctArray[6*r+3],jpnReibun:correctArray[6*r+4],nigateFlag: correctArray[6*r+5],partsOfSpeech: correctArray[6*r+6],soundPath:correctArray[6*r+7])
        }
        */
        /*
        let array:Array<String> = getfile(fileName: nigateChapterArray[chapterNumber])
        
        //nigateファイルに名前がある要素のnigateFlagを1にする
        //こうすると、cell側が勝手にマーク表示してくれる
        for r in 0..<array.count/8{
            if(array[6*r+5] == "1"){
                for i in 0..<wrongList.count{
                    if(array[6*r] == wrongList[i].eng){
                        wrongList[i].nigateFlag = "1"
                    }
                }
            }
        }
        */
        //苦手ラベルをつけるために苦手を参照
        let nigateArray:Array<String> = getfile(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber])
        
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
            wrongCount += 1
        }
        print(wrongCount)
        
        //categoryLabel.text = arrayCategory[appDelegate.problemCategory]
        ///chapterLabel.text =  String(appDelegate.chapterNumber*20+1) + " ~ " + String(appDelegate.chapterNumber*20 + 20)
        //problemRangeLabel.text =  "chap " + String(appDelegate.chapterNumber+1)
        //resultTableView.tag = 1
        //correctTableView.tag = 2
        
        //listForTable = getArrayETFromList(list: list)
        
        for r in 0..<wrongArray.count/6{
            print("wrong")
            wrongCell.append(resultTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            )
            wrongCell[r].setCell(wrongList[r])
        }
        /*
        for i in 0..<26{
            for j in 0..<list[i].count{
                print(list[i][j])
            }
        }
 */
        //correctlistForTable = getArrayETFromList(list: correctlist)
        
        for r in 0..<correctArray.count/6{
            print("correct")
            correctCell.append(resultTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            )
            correctCell[r].setCell(correctList[r])
        }
        
        for j in 0..<correctList.count{
            print(correctList[j])
        }
        
        scoreLabel.text = "正解率 : "+String(wrongArray.count/6+correctArray.count/6 - wrongCount)+" / "+String(wrongArray.count/6+correctArray.count/6)
        
        makeFinishLabel(retryCount : wrongCount,problemVolume:wrongArray.count/6+correctArray.count/6)
        
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
        if(appDelegate.chapterNumber >= testFileNamesArray[appDelegate.problemCategory].count-1){
            print(appDelegate.chapterNumber)
            print(testFileNamesArray[appDelegate.problemCategory].count-1)
            goNextProblem.layer.backgroundColor = UIColor.gray.cgColor
            goNextProblem.isEnabled = false
        }
        
        let newChapterNumber = getNewChapter(fileName: checkFileNamesArray[appDelegate.problemCategory], chapterVolume: testFileNamesArray[appDelegate.problemCategory].count)
       
        if(newChapterNumber > appDelegate.chapterNumber){
            //次のchapterを調べるので、次があることを確認する
            if(appDelegate.modeTag == 1){
                if(appDelegate.chapterNumber < testNigateFileNamesArray[appDelegate.problemCategory].count-1){
                    if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber+1]) == 0{
                        goNextProblem.layer.backgroundColor = UIColor.gray.cgColor
                        goNextProblem.isEnabled = false
                    }
                }
            }
            if(appDelegate.modeTag == 2){
                if(appDelegate.chapterNumber < testNigateFileNamesArray[appDelegate.problemCategory].count-1){
                    if getWrongTangoVolume(fileName:testWrongTangoArray[appDelegate.problemCategory][appDelegate.chapterNumber+1]) == 0{
                        goNextProblem.layer.backgroundColor = UIColor.gray.cgColor
                        goNextProblem.isEnabled = false
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
