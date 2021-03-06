//
//  NigateListForNotificationVC.swift
//  tangoMaster2
//
//  Created by Satoshi Yoshio on 2017/07/15.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class NigateListForNotificationVC: UIViewController, UITableViewDelegate,UITableViewDataSource{

    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var nigateNotificationCategorySelectTable: UITableView!
    
    @IBOutlet weak var begButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var toeicButton: UIButton!
    
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var deselectAllButton: UIButton!
    
    @IBAction func rollbackCheckButton(_ sender: Any) {
        
        rollbackCheck(prevMaskFileName: prevMaskFileName)
        nigateNotificationCategorySelectTable.reloadData()
    }
    
    var nigateTangoVolumes2D = Array<Array<Int>>()

    @IBOutlet weak var graphView: UIView!
    var graphs = Array<TangoProgressGraph>()
    var graphTitle = UILabel()
    let levelLabelNames = ["初級","中級","上級","合計"]
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        nigateNotificationCategorySelectTable.delegate = self
        nigateNotificationCategorySelectTable.dataSource = self
        selectAllButton.addTarget(self, action: #selector(selectAllAndSaveCurrent), for: .touchUpInside)
        deselectAllButton.addTarget(self, action: #selector(deselectAllAndSaveCurrent), for: .touchUpInside)
        writeCurrectMask()
        
        begButton.backgroundColor = UIColor.blue
        midButton.backgroundColor = UIColor.gray
        highButton.backgroundColor = UIColor.gray
        toeicButton.backgroundColor = UIColor.gray
        
        begButton.addTarget(self, action: #selector(toBeg), for: .touchUpInside)
        midButton.addTarget(self, action: #selector(toMid), for: .touchUpInside)
        highButton.addTarget(self, action: #selector(toHigh), for: .touchUpInside)
        toeicButton.addTarget(self, action: #selector(toToeic), for: .touchUpInside)
        
        nigateTangoVolumes2D = getNigateVolumeArray()
    }
    

    override func viewDidAppear(_ animated : Bool){
        super.viewDidAppear(true)
        loadTangoProgressGraph()
    }
    
    func drawGraphWirhAnimation(){
        //前のタイマーが有効なら、処理を強制的に最後まで行かせる
        if timer.isValid {
            timer.invalidate()
            drawer.removeFromSuperview()
            drawer = ColoredDrawer(frame: CGRect(x: originProgressBarFrame.origin.x, y: originProgressBarFrame.origin.y, width: end, height: originProgressBarFrame.height))
            graphView.addSubview(drawer)
            percentLabel.removeFromSuperview()
            percentLabel = UILabel(frame: CGRect(x:5*graphView.frame.width/6,y:originProgressBarFrame.origin.y, width: graphView.frame.width/6, height: graphView.frame.height/7))
            percentLabel.text = "\(Int(100*end / (2*graphView.frame.width/3)))%"
            graphView.addSubview(percentLabel)
        }
        
        /****************
         ratiosのロード処理、グラフを作成してしまう
         どこからがProgressDrawによる処理なのか？
         もしかしたら、一瞬普通に描画した後に、処理している？
         ****************/
        for i in 0..<levelLabelNames.count{
            graphs[i].label1.removeFromSuperview()
            graphs[i].label2.removeFromSuperview()
            graphs[i].coloredGraph.removeFromSuperview()
            graphs[i].nonColoredGraph.removeFromSuperview()
        }
        
        graphTitle.removeFromSuperview()
        
        let prevOriginProgressBarFrame = graphs[appDelegate.problemCategory].coloredGraph.frame
        
        loadTangoProgressGraph()
        
        
        //後にprogressDrawでも使うので、endとは区別する必要あり
        originProgressBarFrame = graphs[appDelegate.problemCategory].coloredGraph.frame
        
        //各カテゴリで一つクリアしたときのグラフの増減をゴールから逆算
        if appDelegate.problemCategory == 0{
            //900/20 = 45
            begin = prevOriginProgressBarFrame.width
        }else if appDelegate.problemCategory == 1{
            //600/20 = 30
            begin = prevOriginProgressBarFrame.width
        }else if appDelegate.problemCategory == 2{
            //300/20 = 15
            begin = prevOriginProgressBarFrame.width
            
        }else{
            //appDelegate.problemCategory は0..<3なので、ここには入らない。あくまでも仮.
            //all 1800/20 = 90 実際にアニメーションはなし
        }
        end = originProgressBarFrame.width
        
        if begin != end{
            graphs[appDelegate.problemCategory].coloredGraph.removeFromSuperview()
            graphs[appDelegate.problemCategory].label2.removeFromSuperview()
        }
        if begin < end{
            timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(progressDraw), userInfo: nil, repeats: true)
        }else if begin > end{
            timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(minusDraw), userInfo: nil, repeats: true)
        }else{
            
        }
    }
    
    var timer = Timer()
    var begin = CGFloat()
    var end   = CGFloat()
    let step: CGFloat = 1.0
    
    var originProgressBarFrame = CGRect()
    
    //後で削除するために、ここで参照を保持
    var percentLabel = UILabel()
    var drawer = ColoredDrawer()
    
    @objc func progressDraw(){
        if(begin <= end){
            self.begin += step
            drawer.removeFromSuperview()
            drawer = ColoredDrawer(frame: CGRect(x: originProgressBarFrame.origin.x, y: originProgressBarFrame.origin.y, width: begin, height: originProgressBarFrame.height))
            graphView.addSubview(drawer)
            percentLabel.removeFromSuperview()
            percentLabel = UILabel(frame: CGRect(x:5*graphView.frame.width/6,y:originProgressBarFrame.origin.y, width: graphView.frame.width/6, height: graphView.frame.height/7))
            percentLabel.text = "\(Int(100*begin / (2*graphView.frame.width/3)))%"
            graphView.addSubview(percentLabel)
        }else{
            timer.invalidate()
            print("timer finished")
        }
    }
    
    @objc func minusDraw(){
        if(begin >= end){
            self.begin -= step
            drawer.removeFromSuperview()
            drawer = ColoredDrawer(frame: CGRect(x: originProgressBarFrame.origin.x, y: originProgressBarFrame.origin.y, width: begin, height: originProgressBarFrame.height))
            graphView.addSubview(drawer)
            percentLabel.removeFromSuperview()
            percentLabel = UILabel(frame: CGRect(x:5*graphView.frame.width/6,y:originProgressBarFrame.origin.y, width: graphView.frame.width/6, height: graphView.frame.height/7))
            percentLabel.text = "\(Int(100*begin / (2*graphView.frame.width/3)))%"
            graphView.addSubview(percentLabel)
        }else{
            timer.invalidate()
            print("timer finished")
        }
    }

    
    func loadTangoProgressGraph(){
        if graphs.count != 0{
            for i in 0..<levelLabelNames.count{
                graphs[i].label1.removeFromSuperview()
                graphs[i].label2.removeFromSuperview()
                graphs[i].coloredGraph.removeFromSuperview()
                graphs[i].nonColoredGraph.removeFromSuperview()
            }
            graphs = Array<TangoProgressGraph>()
        }
        
        graphView.backgroundColor = UIColor.orange
        let graphMaxWidth = 4*graphView.frame.width/6
        
        var willNotifyNigateTangoVolumes = getWillNotifyNigateTangoVolume(maskFileName:NIGATE_NOTIFICATION_MASK_FILE_NAME,nigateTangoVolumes1D:transArrayDimension2to1(array2D:nigateTangoVolumes2D))
        
        var ratios = Array<Double>()
        
        //+1しているのは、合計の分
        for i in 0..<sectionList.count+1{
            if(i < 3){
                let nigateTangoVolume = Double(nigateTangoVolumes2D[i].reduce(0, {$0+$1}))
                if nigateTangoVolume != 0{
                    ratios.append(Double(willNotifyNigateTangoVolumes[i]) / nigateTangoVolume)
                }else{
                    ratios.append(0.0)
                }
                //3番目は3種類の合計
            }else{
                let nigateTangoVolume = Double(transArrayDimension2to1(array2D: nigateTangoVolumes2D).reduce(0, {$0+$1}))
                if nigateTangoVolume != 0{
                    ratios.append(Double(willNotifyNigateTangoVolumes.reduce(0, {$0 + $1})) / nigateTangoVolume)
                }else{
                    ratios.append(0.0)
                }
            }
            print(ratios[i])
        }
        
        //タイトルの追加
        graphTitle = UILabel(frame: CGRect(x:0,y:0, width: graphView.frame.width, height: graphView.frame.height/6))
        graphTitle.text = "苦手な単語の網羅率"
        graphView.addSubview(graphTitle)
        
        //グラフの追加
        for i in 0..<levelLabelNames.count{
            
            graphs.append(makeTangoProgressGraph(superViewWidth: graphView.frame.width, superViewHeight: graphView.frame.height, graphMaxWidth: graphMaxWidth, labelName: levelLabelNames[i], ratio: ratios[i],number:i+1))
            
            graphView.addSubview(graphs[i].label1)
            graphView.addSubview(graphs[i].label2)
            graphView.addSubview(graphs[i].coloredGraph)
            graphView.addSubview(graphs[i].nonColoredGraph)
        }
    }
    
    func makeTangoProgressGraph(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double,number:Int)->TangoProgressGraph{
        
        let graph = TangoProgressGraph(superViewWidth: superViewWidth, superViewHeight: superViewHeight, graphMaxWidth: graphMaxWidth, labelName: labelName, ratio: ratio,number:number)
        return graph
    }
    
    
    @objc func toBeg(){
        categoryChange(0)
    }
    @objc func toMid(){
        categoryChange(1)
    }
    @objc func toHigh(){
        categoryChange(2)
    }
    @objc func toToeic(){
        categoryChange(3)
    }
    
    func categoryChange(_ newCategory:Int){
        appDelegate.problemCategory = newCategory
        begButton.backgroundColor = UIColor.gray
        midButton.backgroundColor = UIColor.gray
        highButton.backgroundColor = UIColor.gray
        toeicButton.backgroundColor = UIColor.gray
        if appDelegate.problemCategory == 0{
            begButton.backgroundColor = UIColor.blue
        }else if appDelegate.problemCategory == 1{
            midButton.backgroundColor = UIColor.blue
        }else if appDelegate.problemCategory == 2{
            highButton.backgroundColor = UIColor.blue
        }else if appDelegate.problemCategory == 3{
            toeicButton.backgroundColor = UIColor.blue
        }
        is_category_top = true
        nigateNotificationCategorySelectTable.reloadData()
    }
    
    func selectAll(){
        let f = easyFileHandle(directoryPath:defaultTextFileDirectoryPath, fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME, extent:"txt")
        let currentMask = f!.readline()!
        var selectedMask = String()
        
        if is_category_top{
            if appDelegate.problemCategory == 0{
                selectedMask = selectMask(mask:currentMask, range:0..<45)
            }else if appDelegate.problemCategory == 1{
                selectedMask = selectMask(mask:currentMask, range:45..<75)
            }else if appDelegate.problemCategory == 2{
                selectedMask = selectMask(mask:currentMask, range:75..<90)
            }else{
                
            }
        }else{
            if appDelegate.problemCategory == 0{
                selectedMask = selectMask(mask:currentMask, range:appDelegate.chapterNumber*5..<(appDelegate.chapterNumber+1)*5)
            }else if appDelegate.problemCategory == 1{
                selectedMask = selectMask(mask:currentMask, range:45+appDelegate.chapterNumber*5..<45+(appDelegate.chapterNumber+1)*5)
            }else if appDelegate.problemCategory == 2{
                selectedMask = selectMask(mask:currentMask, range:75+appDelegate.chapterNumber*5..<75+(appDelegate.chapterNumber+1)*5)
            }else{
                
            }
        }

        selectedMask = deselectNigateVolume0(for: selectedMask, nigateTangoVolumes1D: transArrayDimension2to1(array2D: nigateTangoVolumes2D))
        deleteFile(fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME)
        writeFile(fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt",text:selectedMask)
        
        nigateNotificationCategorySelectTable.reloadData()
        drawGraphWirhAnimation()
    }
    
    func deselectAll(){
        let f = easyFileHandle(directoryPath:defaultTextFileDirectoryPath, fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME, extent:"txt")
        let currentMask = f!.readline()!
        var deselectedMask = String()
        if is_category_top{
            if appDelegate.problemCategory == 0{
                deselectedMask = deselectMask(mask:currentMask, range:0..<45)
            }else if appDelegate.problemCategory == 1{
                deselectedMask = deselectMask(mask:currentMask, range:45..<75)
            }else if appDelegate.problemCategory == 2{
                deselectedMask = deselectMask(mask:currentMask, range:75..<90)
            }else{
                
            }
        }else{
            if appDelegate.problemCategory == 0{
                deselectedMask = deselectMask(mask:currentMask, range:appDelegate.chapterNumber*5..<(appDelegate.chapterNumber+1)*5)
            }else if appDelegate.problemCategory == 1{
                deselectedMask = deselectMask(mask:currentMask, range:45+appDelegate.chapterNumber*5..<45+(appDelegate.chapterNumber+1)*5)
            }else if appDelegate.problemCategory == 2{
                deselectedMask = deselectMask(mask:currentMask, range:75+appDelegate.chapterNumber*5..<75+(appDelegate.chapterNumber+1)*5)
            }else{
                
            }
        }
        deleteFile(fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME)
        writeFile(fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt",text:deselectedMask)
        nigateNotificationCategorySelectTable.reloadData()
        drawGraphWirhAnimation()
    }
    
    @objc func selectAllAndSaveCurrent(){
        writeCurrectMask()
        selectAll()
    }
    
    @objc func deselectAllAndSaveCurrent(){
        writeCurrectMask()
        deselectAll()
    }
    

    func rollbackCheck(prevMaskFileName:String){
        var prevMask = String()
        
        let path = defaultTextFileDirectoryPath
        print("prev: \(path+"/"+nigatePrevMaskFileName+".txt")")
        if let f = FileHandle(forReadingAtPath: path+"/"+nigatePrevMaskFileName+".txt"){
            
            if let mask = f.readline(){
                prevMask = mask
            }else{
                prevMask = zeroMask
            }
            print("ロールバックした後のマスクパターンは\(prevMask)")
            deleteFile(fileName: NIGATE_NOTIFICATION_MASK_FILE_NAME)
            writeFile(fileName: NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt",text: prevMask)
            drawGraphWirhAnimation()
        }
    }
    
    //let prevMaskFileName = "prevNigateNotificationCheckMask"
    //let maskFileName = NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt"
    
    func writeCurrectMask(){
        deleteFile(fileName:nigatePrevMaskFileName)
        var currectMask = String()
        let path = defaultTextFileDirectoryPath
        if let f = FileHandle(forReadingAtPath: path+"/"+NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt"){

            if let mask = f.readline(){
                currectMask = mask
            }else{
                currectMask = zeroMask
            }
            writeFile(fileName: prevMaskFileName+".txt",text: currectMask)
            print("書き込んだ現在のマスクパターンは\(currectMask)")
        }
    }
    
    func getChapterSum(categoryTangoVolumeArray: Array<Int>, chapterNumber: Int)->Int{
        var chapterTangoVolume = 0
        for i in 0..<5{
            chapterTangoVolume += categoryTangoVolumeArray[chapterNumber*5+i]
            //print("array[\(chapterNumber+i)] = ^\(categoryTangoVolumeArray[chapterNumber+i])")
        }
        return chapterTangoVolume
    }
    
    var is_category_top:Bool = true

    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        if is_category_top {
            //section range = {0...9}
            if section == 0{
                //mylistの時
                return chapterNames[appDelegate.problemCategory].count
            }else{
                return 0
            }
        }else {
            if section == 0{
                return 5
            }else{
                return 0
            }
        }
    }
    
   
    func tableView(_ tableView : UITableView,cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        //ファイルからmaskを取り出す処理
        let path = defaultTextFileDirectoryPath
        var mask = String()
        if let f = FileHandle(forReadingAtPath: path+"/"+NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt"){
            if let nigateNotificationCheckMask:String = f.readline() {
                mask = nigateNotificationCheckMask
                print("読み込んだマスクパターンです")
                print(nigateNotificationCheckMask)
                
            }else{
                mask = zeroMask
            }
        }else{
            print("tableViewin write zero mask")
            writeFile(fileName:NIGATE_NOTIFICATION_MASK_FILE_NAME+".txt",text:zeroMask)
        }
        let cell: NigateListForNotificationCell = nigateNotificationCategorySelectTable.dequeueReusableCell(withIdentifier: "nigateListForNotificationCell") as! NigateListForNotificationCell
        var preCount = 0

        for i in 0..<appDelegate.problemCategory{
            preCount += NORMAL_FILE_NAMES[i].count
        }
        var notificationFlag = "0"
        if is_category_top{
            
            var maskCharCount = 0
            for c in mask.characters{
                if maskCharCount >= preCount+indexPath.row*5 && maskCharCount < preCount+indexPath.row*5 + 5{
                    if String(c) == "1"{
                        notificationFlag = "1"
                    }
                }
                maskCharCount += 1
            }
            
            if getChapterSum(categoryTangoVolumeArray: nigateTangoVolumes2D[appDelegate.problemCategory], chapterNumber: indexPath.row) == 0{
                cell.backgroundColor = UIColor.darkGray
                cell.setCell(chapterOrSetsuNumber:indexPath.row,notificationFlag:"0", nigateNumber:getChapterSum(categoryTangoVolumeArray: nigateTangoVolumes2D[appDelegate.problemCategory], chapterNumber: indexPath.row),sectionType:"chapter", maskFileName: NIGATE_NOTIFICATION_MASK_FILE_NAME, isEnabled: false, parentVC: self)
            }else{
                cell.backgroundColor = UIColor.white
                cell.setCell(chapterOrSetsuNumber:indexPath.row,notificationFlag:notificationFlag, nigateNumber:getChapterSum(categoryTangoVolumeArray: nigateTangoVolumes2D[appDelegate.problemCategory], chapterNumber: indexPath.row),sectionType:"chapter", maskFileName: NIGATE_NOTIFICATION_MASK_FILE_NAME, isEnabled: true, parentVC: self)
            }
            return cell
        }else{
            
            var notificationFlag = "1"
            var maskCharCount = 0
            for c in mask.characters{
                if maskCharCount == preCount+appDelegate.chapterNumber*5+indexPath.row{
                    if String(c) == "0"{
                        notificationFlag = "0"
                    }
                }
                maskCharCount += 1
            }
 
            if nigateTangoVolumes2D[appDelegate.problemCategory][appDelegate.chapterNumber*5+indexPath.row] == 0{
                cell.backgroundColor = UIColor.darkGray
                cell.setCell(chapterOrSetsuNumber:indexPath.row,notificationFlag:"0", nigateNumber:nigateTangoVolumes2D[appDelegate.problemCategory][appDelegate.chapterNumber*5+indexPath.row],sectionType:"setsu", maskFileName: NIGATE_NOTIFICATION_MASK_FILE_NAME,isEnabled: false, parentVC: self)
            }else{
                cell.backgroundColor = UIColor.white
                cell.setCell(chapterOrSetsuNumber:indexPath.row,notificationFlag:notificationFlag, nigateNumber:nigateTangoVolumes2D[appDelegate.problemCategory][appDelegate.chapterNumber*5+indexPath.row],sectionType:"setsu", maskFileName: NIGATE_NOTIFICATION_MASK_FILE_NAME, isEnabled: true, parentVC: self)
            }
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
            appDelegate.chapterNumber = indexPath.row
            is_category_top = false
            nigateNotificationCategorySelectTable.reloadData()
        }else{
            appDelegate.setsuNumber = indexPath.row
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
