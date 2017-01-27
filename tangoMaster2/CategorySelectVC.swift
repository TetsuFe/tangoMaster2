//
//  CategorySelectVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit


class CategorySelectVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var begButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var toeicButton: UIButton!
    
    let fileNames = [beginnerFileNames,intermidFileNames]
    let chapterNames = [beginnerChapterNames,intermidChapterNames]
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
        return orientation
    }
    
    //指定方向に自動的に変更
    override var shouldAutorotate : Bool{
        return true
    }
    
    @IBOutlet weak var categorySelectTable: UITableView!
    
    //@IBOutlet weak var reviewButton: UIButton!
    //@IBOutlet weak var newButton: UIButton!
    
    var is_top:Bool = true
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        if is_top {
            //section range = {0...9}
            if section == 0{
                //mylistの時
                if appDelegate.sceneTag == 3{
                    return 1
                }else{
                    return fileNames[appDelegate.problemCategory].count/2
                }
            }else{
                return 0
            }
        }else {
            //section range = {0...4}(max:beginner's situation)
            if section == 0{
                return 2
            }else{
                return 0
            }
        }
    }
    
    var fileNameCells = Array<Array<CategorySelectCell>>()
    var chapterNameCells = Array<Array<CategorySelectCell>>()
    
    func tableView(_ tableView : UITableView,cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        //var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
            //cell.setCell(chapterNames[appDelegate.problemCategory][indexPath.row])
        let cell: CategorySelectCell = categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell
        if(is_top == false){
            //mylistのときは別の表示
            if appDelegate.sceneTag == 3{
                cell.setCell("全範囲")
            }else{
                cell.setCell(chapterNames[appDelegate.problemCategory][indexPath.row])
            }
        }else{
            if appDelegate.sceneTag == 1{
                if indexPath.row > newChapterNumber{
                    cell.backgroundColor = UIColor.darkGray
                }
            }
            cell.setCell(fileNames[appDelegate.problemCategory][indexPath.row])
        }
        return cell
    }
    
    
    //セクションの数を返す.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セクションのタイトルを返す.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if is_top{
            return sectionList[appDelegate.problemCategory]
        }else{
            return chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
        }
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_top{
            //mylistの時の処理
            if appDelegate.sceneTag == 3{
                goScene()
            }else{
                appDelegate.chapterNumber = indexPath.row
                for i in 0..<fileNames[appDelegate.problemCategory].count{
                    cells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell)
                    cells[i].setCell(fileNames[appDelegate.problemCategory][i])
                }
                categorySelectTable.reloadData()
                is_top = false
            }
        }else{
            if appDelegate.sceneTag == 1{
                //問題の場合のみ、クリアしていない単語を解けないようにする
                if indexPath.row <= newChapterNumber{
                    appDelegate.sectionNumber = indexPath.row
                    goScene()
                    //categorySelectTable.reloadData()
                }
            }else{
                appDelegate.sectionNumber = indexPath.row
                goScene()
            }
        }
    }
    
    func categoryChange(_ category:Int){
        begButton.backgroundColor = UIColor.gray
        midButton.backgroundColor = UIColor.gray
        highButton.backgroundColor = UIColor.gray
        toeicButton.backgroundColor = UIColor.gray
        if category == 0{
            begButton.backgroundColor = UIColor.blue
        }else if category == 1{
            midButton.backgroundColor = UIColor.blue
        }else if category == 2{
            highButton.backgroundColor = UIColor.blue
        }else if category == 3{
            toeicButton.backgroundColor = UIColor.blue
        }
        appDelegate.problemCategory = category
        //下のappendをするために前の分を消去
        cells = Array<CategorySelectCell>()
        for i in 0..<chapterNames[appDelegate.problemCategory].count{
            cells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell)
            cells[i].setCell(chapterNames[appDelegate.problemCategory][i])
        }
        categorySelectTable.reloadData()
    }
    
    func toBeg(){
        categoryChange(0)
    }
    func toMid(){
        categoryChange(1)
    }
    func toHigh(){
        categoryChange(2)
    }
    func toToeic(){
        categoryChange(3)
    }
    
    func GoNew(){
        //全部を読み込む
        appDelegate.modeTag = 0
        goScene()
    }
    
    func GoReview(){
        //苦手だけを読み込む
        appDelegate.modeTag = 1
        goScene()
    }
    
    func GoFullReivew(){
        //各カテゴリの苦手をテスト
        if(appDelegate.sceneTag == 2){
            appDelegate.modeTag = 2
            goScene()
        }
    }
    
    func goScene(){
        print(appDelegate.sceneTag)
        var secondViewController = UIViewController()
        if  appDelegate.sceneTag == 0{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newList") as!  ListVC
        }else if  appDelegate.sceneTag == 1{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newProblem") as!  ProblemVC
        }else if appDelegate.sceneTag == 2{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newCard") as!  CardVC
        }else if  appDelegate.sceneTag == 3{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newMyList") as!  NigateListVC
        }else if appDelegate.sceneTag == 4{
            //secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "storySelect") as!  StorySelectVC
        }
        
        // Viewの移動する.
        //UIApplication.shared.keyWindow?.rootViewController = secondViewController
        //こちらはエラーwhose view is not in window hierarky
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    var nigateTangoVolumeArray = Array<Int>()
    var newChapterNumber = Int()
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //var greenColor:CGColor? = nil

    var listForTable = Array<Array<String>>()
    var cells = Array<CategorySelectCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.modeTag = 0
        print("viewDidloaded")
        
        //let purpleColor = reviewButton.layer.backgroundColor
        //greenColor = newButton.layer.backgroundColor
        newChapterNumber = getNewChapter(fileName: checkFileNamesArray[appDelegate.problemCategory], chapterVolume: testFileNamesArray[appDelegate.problemCategory].count)
        //appDelegate.chapterNumber = newChapterNumber
        
        //各chapterの苦手単語数を取得
        for fileName in testNigateFileNamesArray[appDelegate.problemCategory]{
            nigateTangoVolumeArray.append(getNigateTangoVolume(fileName: fileName))
        }
        print(appDelegate.chapterNumber)
        
        //tableViewの設定
        categorySelectTable.dataSource = self
        categorySelectTable.delegate = self
        
        appDelegate.problemCategory = 0
        for i in 0..<chapterNames[appDelegate.problemCategory].count{
            cells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell)
            cells[i].setCell(chapterNames[appDelegate.problemCategory][i])
        }

        //appDelegate.problemCategory = 0
        begButton.backgroundColor = UIColor.blue
        midButton.backgroundColor = UIColor.gray
        highButton.backgroundColor = UIColor.gray
        toeicButton.backgroundColor = UIColor.gray
        
        begButton.addTarget(self, action: #selector(toBeg), for: .touchUpInside)
        midButton.addTarget(self, action: #selector(toMid), for: .touchUpInside)
        highButton.addTarget(self, action: #selector(toHigh), for: .touchUpInside)
        toeicButton.addTarget(self, action: #selector(toToeic), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
