//
//  CategorySelectVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class CategorySelectVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
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
    
    
    @IBOutlet weak var begButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var toeicButton: UIButton!
    @IBOutlet weak var categorySelectTable: UITableView!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    var is_category_top:Bool = true
    
    //var fileNameCells = Array<Array<CategorySelectCell>>()
    //var chapterNameCells = Array<Array<CategorySelectCell>>()
    
    var labels = Array<UILabel>()
    var coloredGraphs = Array<ColoredDrawer>()
    var labels2 = Array<UILabel>()
    var nonColoredGraphs = Array<NonColoredDrawer>()

    var nigateTangoVolumeArray = Array<Int>()
    var newChapterNumber = Int()
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //var listForTable = Array<Array<String>>()
    //var normalCells = Array<CategorySelectCell>()
    var graphCells = Array<CategorySelectWithGraphCell>()
    var newChapterNumbers = Array<Int>()
    
    //var graphMaxWidth = CGFloat()
    // var superViewWidth = CGFloat()
    //var superViewHeight = CGFloat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidloaded")
        if(appDelegate.sceneTag == 0){
            modeLabel.text = "リスト"
        }else if(appDelegate.sceneTag == 1){
            modeLabel.text = "テスト"
        }else if(appDelegate.sceneTag == 2){
            modeLabel.text = "カード"
        }else if(appDelegate.sceneTag == 3){
            modeLabel.text = "苦手"
        }
        self.navigationController?.setNavigationBarHidden(true, animated:false)
        self.automaticallyAdjustsScrollViewInsets = false
        appDelegate.modeTag = 0
        
        
        //let purpleColor = reviewButton.layer.backgroundColor
        //greenColor = newButton.layer.backgroundColor
        
        //for category in 0..<chapterNames.count{
        for category in 0..<categoryNames.count{
            newChapterNumbers.append(getNewChapter(fileName: checkNewChapterFileNames[category], chapterVolume: fileNames[category].count))
        }
        
        print(appDelegate.chapterNumber)
        
        //tableViewの設定
        categorySelectTable.dataSource = self
        categorySelectTable.delegate = self
        
        appDelegate.problemCategory = 0
        
        /*
         for i in 0..<chapterNames[appDelegate.problemCategory].count{
         normalCells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell)
         normalCells[i].setCell(chapterNames[appDelegate.problemCategory][i])
         }
         */
        var countOfCell = 0
        for j in 0..<chapterNames.count{
            for i in 0..<chapterNames[j].count{
                graphCells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectWithGraphCell") as! CategorySelectWithGraphCell)
                
                var ratio = Double()
                
                //ラベルがchapter1のように少し長いため、その分graphの長さを短く設定4/6 -> 4/7
                let graphMaxWidth = 4*graphCells[i].frame.width/7
                
                let superViewWidth = graphCells[i].frame.width
                let superViewHeight = graphCells[i].frame.height
                print(graphCells[i].frame.width,graphCells[i].frame.height)
                
                //TODO: newChapterNumberがレベルカテゴリごとに必要
                if i < (newChapterNumbers[j]) / 5 {
                    ratio = 1
                }else if i == (newChapterNumbers[j]) / 5{
                    ratio = Double((newChapterNumbers[j]) % 5) / 5
                }else{
                    ratio = 0
                }
                
                
                labels.append(UILabel(frame: CGRect(x:0,y:0, width: superViewWidth/4, height: superViewHeight/2)))
                
                coloredGraphs.append(ColoredDrawer(frame: CGRect(x: superViewWidth/4, y: 0.1*superViewHeight/5, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/2)))
                
                labels2.append(UILabel(frame: CGRect(x:superViewWidth/4 + CGFloat(ratio) * graphMaxWidth + CGFloat(1.0 - ratio) * graphMaxWidth,y:0, width: superViewWidth/6, height: superViewHeight/2)))
                
                nonColoredGraphs.append(NonColoredDrawer(frame: CGRect(x: superViewWidth/4 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/5,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/2)))
                
                
                labels[countOfCell].text = chapterNames[j][i]
                labels2[countOfCell].text = String(Int(ratio*100)) + "%"
                
                labels[countOfCell].center.y = graphCells[countOfCell].center.y
                labels2[countOfCell].center.y = graphCells[countOfCell].center.y
                coloredGraphs[countOfCell].center.y = graphCells[countOfCell].center.y
                nonColoredGraphs[countOfCell].center.y = graphCells[countOfCell].center.y
                print("center:\(graphCells[countOfCell].center.y)")

                graphCells[countOfCell].backgroundColor = UIColor.orange
                
                graphCells[countOfCell].contentView.addSubview(labels[countOfCell])
                graphCells[countOfCell].contentView.addSubview(coloredGraphs[countOfCell])
                graphCells[countOfCell].contentView.addSubview(labels2[countOfCell])
                graphCells[countOfCell].contentView.addSubview(nonColoredGraphs[countOfCell])
                
                countOfCell = countOfCell + 1
            }
        }
        print("c = \(graphCells.count)")
        
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
            
            //for category in 0..<chapterNames.count{
            for category in 0..<categoryNames.count{
                newChapterNumbers.append(getNewChapter(fileName: checkNewChapterFileNames[category], chapterVolume: fileNames[category].count))
            }
            
            //各chapterの苦手単語数を取得
            for fileName in nigateFileNames[appDelegate.problemCategory]{
                nigateTangoVolumeArray.append(getNigateTangoVolume(fileName: fileName))
            }
 
            print(appDelegate.chapterNumber)
            
            var countOfCell = 0
            
            //graphCells = Array<CategorySelectWithGraphCell>()
            labels = Array<UILabel>()
            coloredGraphs = Array<ColoredDrawer>()
            labels2 = Array<UILabel>()
            nonColoredGraphs = Array<NonColoredDrawer>()
            
            for j in 0..<chapterNames.count{
                for i in 0..<chapterNames[j].count{
                    graphCells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectWithGraphCell") as! CategorySelectWithGraphCell)
                    
                    var ratio = Double()
                    
                    //ラベルがchapter1のように少し長いため、その分graphの長さを短く設定4/6 -> 4/7
                    let graphMaxWidth = 4*graphCells[i].frame.width/7
                    
                    let superViewWidth = graphCells[i].frame.width
                    let superViewHeight = graphCells[i].frame.height
                    
                    print(graphCells[i].frame.width,graphCells[i].frame.height)
                    
                    //TODO: newChapterNumberがレベルカテゴリごとに必要
                    if i < (newChapterNumbers[j]) / 5 {
                        ratio = 1
                    }else if i == (newChapterNumbers[j]) / 5{
                        ratio = Double((newChapterNumbers[j]) % 5) / 5
                    }else{
                        ratio = 0
                    }
                    
                    labels.append(UILabel(frame: CGRect(x:0,y:0, width: superViewWidth/4, height: superViewHeight/2)))
                    
                    coloredGraphs.append(ColoredDrawer(frame: CGRect(x: superViewWidth/4, y: 0.1*superViewHeight/5, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/2)))
                    
                    labels2.append(UILabel(frame: CGRect(x:superViewWidth/4 + CGFloat(ratio) * graphMaxWidth + CGFloat(1.0 - ratio) * graphMaxWidth,y:0, width: superViewWidth/6, height: superViewHeight/2)))
                    
                    nonColoredGraphs.append(NonColoredDrawer(frame: CGRect(x: superViewWidth/4 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/5,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/2)))
                    
                    labels[countOfCell].text = chapterNames[j][i]
                    labels2[countOfCell].text = String(Int(ratio*100)) + "%"
                    
                    labels[countOfCell].center.y = superViewHeight/2
                    labels2[countOfCell].center.y = superViewHeight/2
                    coloredGraphs[countOfCell].center.y = superViewHeight/2
                    nonColoredGraphs[countOfCell].center.y = superViewHeight/2
                    print("center:\(graphCells[countOfCell].center.y)")
                    
                    graphCells[countOfCell].backgroundColor = UIColor.orange
                    
                    graphCells[countOfCell].contentView.addSubview(labels[countOfCell])
                    graphCells[countOfCell].contentView.addSubview(coloredGraphs[countOfCell])
                    graphCells[countOfCell].contentView.addSubview(labels2[countOfCell])
                    graphCells[countOfCell].contentView.addSubview(nonColoredGraphs[countOfCell])
                    
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
        
        //var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
            //cell.setCell(chapterNames[appDelegate.problemCategory][indexPath.row])
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
                //cell.setCell("全範囲")
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
                //print(graphCells.count)
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
                    /*
                    for i in 0..<5{
                        normalCells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell)
                        normalCells[i].setCell(fileNames[appDelegate.problemCategory][appDelegate.chapterNumber*5+i])
                    }
 */
                    is_category_top = false
                    categorySelectTable.reloadData()
                }
            }else{
                appDelegate.chapterNumber = indexPath.row
                /*
                for i in 0..<5{
                    normalCells.append(categorySelectTable.dequeueReusableCell(withIdentifier: "CategorySelectCell") as! CategorySelectCell)
                    normalCells[i].setCell(fileNames[appDelegate.problemCategory][appDelegate.chapterNumber*5+i])
                }
 */
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
            
            //categoryChanged = true
        
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
    
    /*
    func GoReview(){
        //苦手だけを読み込む
        appDelegate.modeTag = 1
        goScene()
    }
 */
    
    
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
        
        // Viewの移動する.
        //UIApplication.shared.keyWindow?.rootViewController = secondViewController
        //こちらはエラーwhose view is not in window hierarky
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
