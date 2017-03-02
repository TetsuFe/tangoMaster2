//
//  NewListVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class ListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var imageTableView: UITableView!
    
    var listForTable = Array<NewImageReibun>()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return listForTable.count
    }
    
    var cell = Array<ListCell>()
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        //let cell: ImageReibunCell = imageTableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageReibunCell
        
        //cell.setCell(listForTable[indexPath.row])
        return cell[indexPath.row]
    }
    
    /*
     セクションの数を返す.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let chapterNames = [beginnerChapterNames,intermidChapterNames]
    
    /*
     セクションのタイトルを返す.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageTableView.dataSource = self
        imageTableView.delegate = self
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.autoFadeTag = 0
        super.viewWillAppear(animated)
        print(self.view.bounds.size)
        imageTableView.rowHeight = self.view.bounds.size.height/9
        
        var tango = Array<String>()
        //先ずは苦手リストが作成されているか確認する
        //苦手モードの場合
        /*
        if(appDelegate.modeTag == 1){
            tango = getfile(fileName:testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber])
            /*
             if tango.isEmpty == true{
             print("苦手なしもしくは苦手リスト見作成")
             tango = readFileGetWordArray(testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber], extent: "txt")
             }
             */
        }else{
            tango = readFileGetWordArray(testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber], extent: "txt")
        }
        for r in 0..<tango.count/8{
            listForTable.append(NewImageReibun(eng: tango[8*r],jpn:tango[8*r+1],engReibun:tango[8*r+3],jpnReibun:tango[8*r+4],nigateFlag: tango[8*r+5],partOfSpeech:tango[8*r+6]))
        }
        
        let nigateArray:Array<String> = getfile(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber])
        for r in 0..<nigateArray.count/8{
            if(nigateArray[8*r+5] == "1"){
                listForTable[r].nigateFlag = "1"
            }
        }
        
        for r in 0..<tango.count/8{
            cell.append(imageTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            )
            cell[r].setCell(listForTable[r])
        }
        */
        
        
        
        tango = readFileGetWordArray(testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber], extent: "txt")
        
        for r in 0..<tango.count/6{
            listForTable.append(NewImageReibun(eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5]))
        }
        //苦手ラベルをつけるために苦手を参照
        let nigateArray:Array<String> = getfile(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber])
        //苦手配列の英語と同じ英語に苦手ラベルづけ
        for r in 0..<nigateArray.count/6{
            if nigateArray[6*r+4] == "1"{
                for i in 0..<listForTable.count{
                    if(nigateArray[6*r] == listForTable[i].eng){
                        listForTable[i].nigateFlag = "1"
                    }
                }
            }
        }
    
        for r in 0..<tango.count/6{
            cell.append(imageTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            )
            cell[r].setCell(listForTable[r])
        }
    }
}
