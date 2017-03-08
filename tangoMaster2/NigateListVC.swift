//
//  NewMyListVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class NigateListVC: UIViewController  ,UITableViewDelegate,UITableViewDataSource{
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var goCardButton: UIButton!
    @IBOutlet weak var goAutoFadeButton: UIButton!
    @IBOutlet weak var goTestButton: UIButton!
    @IBOutlet weak var imageTableView: UITableView!
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.view.bounds.size)
        imageTableView.rowHeight = self.view.bounds.size.height/9
        
        //ループで使う、chapterの番号を示す
        var cIndex = 0
        //ループでカテゴリ全部の苦手単語を取得させる？
        for i in 0..<testNigateFileNamesArray[appDelegate.problemCategory].count{
            var tango = Array<String>()
            var listForTable : Array<NewImageReibun> = []
            cellsArray.append([])
            //先ずは苦手リストが作成されているか確認する
            
            tango = getfile(fileName:testNigateFileNamesArray[appDelegate.problemCategory][i])
            if tango.count != 0{
                for r in 0..<tango.count/6{
                    listForTable.append(NewImageReibun(eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5]))
                }
                
                for r in 0..<tango.count/6{
                    cellsArray[cIndex].append(imageTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
                    )
                    cellsArray[cIndex][r].setCell(listForTable[r],chapterNumber:String(i))
                }
                cIndex += 1
            }
        }
        imageTableView.dataSource = self
        imageTableView.delegate = self
        goCardButton.addTarget(self, action:#selector(goCard), for: .touchUpInside)
        goAutoFadeButton.addTarget(self, action:#selector(goAutoFade), for: .touchUpInside)
        goTestButton.addTarget(self, action:#selector(goTest), for: .touchUpInside)
        //苦手が登録されていないときはカード・問題などに行かないようにボタンを無効に
        if cIndex == 0{
            goCardButton.isEnabled = false
            goAutoFadeButton.isEnabled = false
            goTestButton.isEnabled = false
        }
    }
    
    var cellsArray = Array<Array<ListCell>>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        //苦手が一個も登録されていないときは0を返す
        if cellsArray.count == 0{
            return 0
        }else{
            return cellsArray[section].count
        }
    }
    
    /*
     セクションの数を返す.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return testNigateFileNamesArray[appDelegate.problemCategory].count
    }
    
    /*
     セクションのタイトルを返す.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //先頭の一文字n(苦手nigate)を消して表示
        let s = testNigateFileNamesArray[appDelegate.problemCategory][section]
        return s.substring(from: s.index(after: s.startIndex))
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        return cellsArray[indexPath.section][indexPath.row]
    }
    
    func goCard() {
        changeModeToNigateFull()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newCard") as!  CardVC
         self.present(secondViewController, animated: true, completion: nil)
    }
    
    func goAutoFade() {
        changeModeToNigateFull()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newAutoFade") as!  AutoFadeVC
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func goTest(){
        changeModeToNigateFull()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newProblem") as!  ProblemVC
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func changeModeToNigateFull(){
        appDelegate.modeTag = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*従来の 1chapterごとのリストテーブル
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return listForTable.count
    }
    
    var cell = Array<ListCell>()
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        //let cell: ImageReibunCell = imageTableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageReibunCell
        //cell.setCell(listForTable[indexPath.row])
        return cell[indexPath.row]
    }
    
    */
}
