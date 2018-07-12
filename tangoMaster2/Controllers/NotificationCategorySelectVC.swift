//
//  NotificationCategorySelectVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/06/09.
//  Copyright © 2017年 Tetsu. All rights reserved.
//
/*
import UIKit


class NotificationCategorySelectVC: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
        return orientation
    }
    
    //指定方向に自動的に変更
    override var shouldAutorotate : Bool{
        return true
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //上のcategoryボタンを削除
    @IBOutlet weak var categorySelectTable: UITableView!
    @IBOutlet weak var modeLabel: UILabel!
    
    var is_category_top:Bool = true
    
    var labels = Array<UILabel>()
    var coloredGraphs = Array<ColoredDrawer>()
    var labels2 = Array<UILabel>()
    var nonColoredGraphs = Array<NonColoredDrawer>()
    
    var nigateTangoVolumeArray = Array<Int>()
    var newChapterNumber = Int()
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var graphCells = Array<CategorySelectWithGraphCell>()
    var newChapterNumbers = Array<Int>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidloaded")
        if(appDelegate.sceneTag == 0){
            modeLabel.text = "リスト"
        }else if(appDelegate.sceneTag == 3){
            modeLabel.text = "苦手"
        }
        self.navigationController?.setNavigationBarHidden(true, animated:false)
        self.automaticallyAdjustsScrollViewInsets = false
        appDelegate.modeTag = 0
        
        for category in 0..<categoryNames.count{
            newChapterNumbers.append(getNewChapter(fileName: checkNewChapterFileNames[category], chapterVolume: fileNames[category].count))
        }
        
        print(appDelegate.chapterNumber)
        
        //tableViewの設定
        categorySelectTable.dataSource = self
        categorySelectTable.delegate = self
        
        appDelegate.problemCategory = 0
        
        var countOfCell = 0
        for j in 0..<chapterNames.count{
            for i in 0..<chapterNames[j].count{
                graphCells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectWithGraphCell") as! CategorySelectWithGraphCell)
                countOfCell = countOfCell + 1
            }
        }
        print("c = \(graphCells.count)")
    }
    
    var firstDraw = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if firstDraw{
            
            var count = 0
            for j in 0..<chapterNames.count{
                for _ in 0..<chapterNames[j].count{
                    labels[count].removeFromSuperview()
                    coloredGraphs[count].removeFromSuperview()
                    labels2[count].removeFromSuperview()
                    nonColoredGraphs[count].removeFromSuperview()
                    count += 1
                }
            }
            
            newChapterNumbers = Array<Int>()
            nigateTangoVolumeArray = Array<Int>()
            
            for category in 0..<categoryNames.count{
                newChapterNumbers.append(getNewChapter(fileName: checkNewChapterFileNames[category], chapterVolume: fileNames[category].count))
            }
            
            //各chapterの苦手単語数を取得
            for fileName in nigateFileNames[appDelegate.problemCategory]{
                nigateTangoVolumeArray.append(getNigateTangoVolume(fileName: fileName))
            }
            
            print(appDelegate.chapterNumber)
            
            var countOfCell = 0
            

            for j in 0..<chapterNames.count{
                for i in 0..<chapterNames[j].count{
                    
                    
                    
                   
                    
                    countOfCell = countOfCell + 1
                }
            }
            
            categorySelectTable.reloadData()
        }
    }
    
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        if is_category_top {
            //section range = {0...9}
            if section == 0{
                //mylistの時
                if appDelegate.sceneTag == 3{
                    return 1
                }else{
                    return chapterNames[appDelegate.problemCategory].count
                }
            }else{
                return 0
            }
        }else {
            //section range = {0...4}(max:beginner's situation)
            if section == 0{
                return 5
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView : UITableView,cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        print("newChapter = \(newChapterNumber)")
        
        let cell: CategorySelectCell = categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell
        
        
        if is_category_top{
            var row = indexPath.row
            print("row: \(row)")
            
            for i in 0..<appDelegate.problemCategory{
                row = row + chapterNames[i].count
            }
            print(row)
            
            //mylistのときは別の表示
            if appDelegate.sceneTag == 3{
                cell.backgroundColor = UIColor.orange
                cell.setCell("全範囲")
                return cell
            }else if appDelegate.sceneTag == 1{
                if indexPath.row < newChapterNumbers[appDelegate.problemCategory]/5{
                    print((newChapterNumbers[appDelegate.problemCategory]+1)/5)
                    graphCells[row].backgroundColor = UIColor.green
                }else if indexPath.row == newChapterNumbers[appDelegate.problemCategory]/5{
                    graphCells[row].backgroundColor = UIColor.orange
                }
                else if indexPath.row > newChapterNumbers[appDelegate.problemCategory]/5{
                    graphCells[row].backgroundColor = UIColor.darkGray
                }
                return graphCells[row]
            }else{
                graphCells[row].backgroundColor = UIColor.orange
                return graphCells[row]
            }
        }else{
            if appDelegate.sceneTag == 1{
                if indexPath.row < newChapterNumbers[appDelegate.problemCategory]{
                    cell.backgroundColor = UIColor.green
                }else if indexPath.row == newChapterNumbers[appDelegate.problemCategory]{
                    cell.backgroundColor = UIColor.orange
                }
                else if indexPath.row > newChapterNumbers[appDelegate.problemCategory]{
                    cell.backgroundColor = UIColor.darkGray
                }
            }else{
                cell.backgroundColor = UIColor.orange
            }
            cell.setCell(fileNames[appDelegate.problemCategory][appDelegate.chapterNumber*5+indexPath.row])
            return cell
        }
    }
    
    //セクションの数を返す.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セクションのタイトルを返す.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if is_category_top{
            return sectionList[appDelegate.problemCategory]
        }else{
            return chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]
        }
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_category_top{
            //mylistの時の処理
            if appDelegate.sceneTag == 3{
                goScene()
            }else if appDelegate.sceneTag == 1{
                if indexPath.row <= (newChapterNumbers[appDelegate.problemCategory]+1)/5{
                    appDelegate.chapterNumber = indexPath.row
 
                    is_category_top = false
                    categorySelectTable.reloadData()
                }
            }else{
                appDelegate.chapterNumber = indexPath.row
                is_category_top = false
                categorySelectTable.reloadData()
            }
        }else{
            if appDelegate.sceneTag == 1{
                //問題の場合のみ、クリアしていない単語を解けないようにする
                if indexPath.row <= newChapterNumbers[appDelegate.problemCategory]{
                    appDelegate.setsuNumber = indexPath.row
                    goScene()
                    //categorySelectTable.reloadData()
                }
            }else{
                appDelegate.setsuNumber = indexPath.row
                goScene()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func categoryChange(_ category:Int){
        if category != appDelegate.problemCategory{
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
            is_category_top = true
            
            categorySelectTable.reloadData()
        }
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
    
    func goScene(){
        //最初の移動を記録
        firstDraw = true
        print(appDelegate.sceneTag)
        var secondViewController = UIViewController()
        if  appDelegate.sceneTag == 0{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newList") as!  ListVC
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }else if  appDelegate.sceneTag == 1{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newProblem") as!  ProblemVC
            self.present(secondViewController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(secondViewController, animated: true)
        }else if appDelegate.sceneTag == 2{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newCard") as!  CardVC
            self.present(secondViewController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(secondViewController, animated: true)
        }else if  appDelegate.sceneTag == 3{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newMyList") as!  NigateListVC
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }else if appDelegate.sceneTag == 4{
            //secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "storySelect") as!  StorySelectVC
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
*/
