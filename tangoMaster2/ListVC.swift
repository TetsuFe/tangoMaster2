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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageTableView.dataSource = self
        imageTableView.delegate = self
        print(self.view.bounds.size)
        imageTableView.rowHeight = self.view.bounds.size.height/9
        
        updateCell()
    }
    
    func updateCell(){
        let tango = readFileGetWordArray(testFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber], extent: "txt")
        listForTable = Array<NewImageReibun>()
        cell = Array<ListCell>()
        
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
            cell[r].setCell(listForTable[r],chapterNumber: String(appDelegate.chapterNumber))
        }
    }

    @IBAction func prevChapButton(_ sender: Any) {
        //ボタンをタップした時に実行するメソッドを指定
        if(appDelegate.modeTag == 0){
            if(appDelegate.chapterNumber > 0){
                appDelegate.chapterNumber -= 1
                updateCell()
                imageTableView.reloadData()
            }else if appDelegate.chapterNumber == 0{
                appDelegate.chapterNumber = testFileNamesArray[appDelegate.problemCategory].count-1
                updateCell()
                imageTableView.reloadData()
            }
            
        }else if(appDelegate.modeTag == 1){
            if(appDelegate.chapterNumber != 0){
                //これはよくない。苦手があるchapterの数を調べた方がいい（newChapterで代用できないか？
                //意味は一応同じ。一つ前（先）のchpaterに苦手がなければ進まない
                if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber-1]) != 0{
                    appDelegate.chapterNumber -= 1
                    updateCell()
                    imageTableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func nextChapButton(_ sender: Any) {
        if(appDelegate.modeTag == 0){
            if(appDelegate.chapterNumber < testFileNamesArray[appDelegate.problemCategory].count-1){
                appDelegate.chapterNumber += 1
                updateCell()
                imageTableView.reloadData()
            }else{
                appDelegate.chapterNumber = 0
                updateCell()
                imageTableView.reloadData()
            }
        }else if(appDelegate.modeTag == 1){
            //次のchapterを調べるので、次があることを確認する
            if(appDelegate.chapterNumber < testNigateFileNamesArray[appDelegate.problemCategory].count-1){
                if getNigateTangoVolume(fileName: testNigateFileNamesArray[appDelegate.problemCategory][appDelegate.chapterNumber+1]) != 0{
                    appDelegate.chapterNumber += 1
                    updateCell()
                    imageTableView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var imageTableView: UITableView!
    
    var listForTable = Array<NewImageReibun>()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return listForTable.count
    }
    
    var cell = Array<ListCell>()
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        return cell[indexPath.row]
    }
    
    /*
     セクションの数を返す.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    /*
     セクションのタイトルを返す.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
