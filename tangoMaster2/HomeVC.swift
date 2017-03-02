//
//  NewHomeVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var graphView: UIView!
    
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var homeTableView: UITableView!
    
    //tableView
    let labelNames = ["単語一覧","単語テスト","単語カード","苦手リスト"]
    let imageNames = ["list.png","test.png","card.png","nigatelist.png"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return labelNames.count
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        let cell: HomeSelectCell = homeTableView.dequeueReusableCell(withIdentifier: "HomeSelectCell") as! HomeSelectCell
        
        cell.setCell(labelNames[indexPath.row],imageNames[indexPath.row])
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.sceneTag = indexPath.row
        var secondViewController = UIViewController()
        if indexPath.row == 4{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "storySelect") as! StorySelectVC
        }else{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
            //let transition = CATransition()
            //transition.duration = 0.25
            //transition.type = kCATransitionPush
            //transition.subtype = kCATransitionFromRight
            //view.window!.layer.add(transition, forKey: kCATransition)
            self.present(secondViewController, animated: true, completion: nil)

        }
    }
    
    override func viewDidAppear(_ animated : Bool){
        super.viewDidAppear(true)
        
        graphView.backgroundColor = UIColor.orange
        let graphMaxWidth = 4*graphView.frame.width/6
        
        var graphs = Array<TangoProgressGraph>()
        
        //let ratios = [0.8,0.6,0.2,1]
        var newChapterNumbers = getNewChapterArray()
        //現在・上級を作っていないのでその分を追加
        while(newChapterNumbers.count < 4){
            newChapterNumbers.append(0)
        }
        var ratios = Array<Double>()
        for i in 0..<chapterVolumes.count {
            if(i == 0){
                newChapterNumbers[i] = 50
                ratios.append(50.0/Double(chapterVolumes[i]))
            }
            else if(i > 0 && i < 3){
                ratios.append(Double(newChapterNumbers[i]) / Double(chapterVolumes[i]))
            }
            //3番目は3種類の合計
            else{
                let sumchapnum = Double(newChapterNumbers.reduce(0,{$0+$1}))
                print(sumchapnum)
                let sumchapvolume = chapterVolumes.reduce(0,{$0+$1})
                print(sumchapvolume)
                ratios.append(Double(newChapterNumbers.reduce(0, {$0 + $1})) / chapterVolumes.reduce(0, {$0 + $1}))
            }
            print(ratios[i])
        }
        
        let labelNames = ["初級","中級","上級","合計"]
        
        //タイトルの追加
        let graphTitle = UILabel(frame: CGRect(x:0,y:0, width: graphView.frame.width, height: graphView.frame.height/6))
        graphTitle.text = "単語テストクリア率"
        graphView.addSubview(graphTitle)
        
        //グラフの追加
        
        for i in 0..<labelNames.count{
            
            graphs.append(makeTangoProgressGraph(superViewWidth: graphView.frame.width, superViewHeight: graphView.frame.height, graphMaxWidth: graphMaxWidth, labelName: labelNames[i], ratio: ratios[i],number:i+1))
            
            graphView.addSubview(graphs[i].label1)
            graphView.addSubview(graphs[i].label2)
            graphView.addSubview(graphs[i].coloredGraph)
            graphView.addSubview(graphs[i].nonColoredGraph)
        }
    }
    
    let chapterNames = [beginnerChapterNames,intermidChapterNames]
    
    func getNewChapterArray()->Array<Int>{
        var newChapterNumbers = Array<Int>()
        for category in 0..<chapterNames.count{
            newChapterNumbers.append(getNewChapter(fileName: checkFileNamesArray[category], chapterVolume: testFileNamesArray[category].count))
        }
        return newChapterNumbers
    }
    
    //func calcRatio(array:Array<Int>)->Array<Double>{
        
    //}
    
    func makeTangoProgressGraph(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double,number:Int)->TangoProgressGraph{
        
        let graph = TangoProgressGraph(superViewWidth: superViewWidth, superViewHeight: superViewHeight, graphMaxWidth: graphMaxWidth, labelName: labelName, ratio: ratio,number:number)
        return graph
    }
    
}



class TangoProgressGraph{
    
    var label1 : UILabel
    var coloredGraph : ColoredDrawer
    var label2 : UILabel
    var nonColoredGraph : NonColoredDrawer
    
    init(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double, number:Int){
        self.label1 = UILabel(frame: CGRect(x:0,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/6))
        
        self.coloredGraph = ColoredDrawer(frame: CGRect(x: superViewWidth/6, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/8))
        
        self.label2 = UILabel(frame: CGRect(x:5*superViewWidth/6,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/6))
        
        self.nonColoredGraph = NonColoredDrawer(frame: CGRect(x: superViewWidth/6 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/8))
        
        /*
        labels.append(UILabel(frame: CGRect(x:0,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/2)))
        
        coloredGraphs.append(ColoredDrawer(frame: CGRect(x: superViewWidth/6, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/2)))
        
        labels2.append(UILabel(frame: CGRect(x:5*superViewWidth/6,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/2)))
        
        nonColoredGraphs.append(NonColoredDrawer(frame: CGRect(x: superViewWidth/6 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/2)))
*/
        
        label1.text = labelName
        label2.text = String(Int(ratio*100)) + "%"
    }
}


class ColoredDrawer: UIView {
    override func draw(_ rect: CGRect) {// 矩形 -------------------------------------
        let rectangle = UIBezierPath(rect: rect)
        // stroke 色の設定
        UIColor.green.setStroke()
        // ライン幅
        rectangle.lineWidth = 1
        //
        // 塗りつぶしの色を黄色に設定.
        UIColor.green.setFill()
        
        // 塗りつぶし.
        rectangle.fill()
        // 描画
        rectangle.stroke()
    }
}

class NonColoredDrawer: UIView {
    override func draw(_ rect: CGRect) {// 矩形 -------------------------------------
        let rectangle = UIBezierPath(rect: rect)
        // stroke 色の設定
        UIColor.gray.setStroke()
        // ライン幅
        rectangle.lineWidth = 1
        // 塗りつぶしの色を黄色に設定.
        UIColor.gray.setFill()
        
        // 塗りつぶし.
        rectangle.fill()
        
        // 描画
        rectangle.stroke()
    }
}
