//
//  NewHomeVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/25.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    //status bar's color is while
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var graphView: UIView!

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var homeTableView: UITableView!
    
    //tableView
    let sceneLabelNames = ["単語一覧","単語テスト","単語カード","苦手リスト","単語通知設定"]
    let imageNames = ["normallist.png","test.png","card.png","nigatelist.png,","bell.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated:false)
        homeTableView.dataSource = self
        homeTableView.delegate = self
    }
    
    var graphs = Array<TangoProgressGraph>()
    let levelLabelNames = ["初級","中級","上級","合計"]
    

    override func viewDidAppear(_ animated : Bool){
        super.viewDidAppear(true)
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
        
        

        var newChapterNumbers = getNewChapterArray()

        var ratios = Array<Double>()

        //+1しているのは、合計の分
        for i in 0..<sectionList.count+1{
            if(i < 3){
                ratios.append(Double(newChapterNumbers[i]) / Double(fileVolumes[i]))
                //3番目は3種類の合計
            }else{
                let sumchapnum = Double(newChapterNumbers.reduce(0,{$0+$1}))
                print(sumchapnum)
                let sumchapvolume = fileVolumes.reduce(0,{$0+$1})
                print(sumchapvolume)
                ratios.append(Double(newChapterNumbers.reduce(0, {$0 + $1})) / Double(fileVolumes.reduce(0, {$0 + $1})))
            }
            print(ratios[i])
        }
        
        //let labelNames = ["初級","中級","上級","合計"]
        
        //タイトルの追加
        let graphTitle = UILabel(frame: CGRect(x:0,y:0, width: graphView.frame.width, height: graphView.frame.height/6))
        graphTitle.text = "単語テストクリア率"
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return sceneLabelNames.count
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        let cell: HomeSelectCell = homeTableView.dequeueReusableCell(withIdentifier: "HomeSelectCell") as! HomeSelectCell
        
        cell.setCell(sceneLabelNames[indexPath.row],imageNames[indexPath.row])
        return cell
    }
    
    //Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.sceneTag = indexPath.row
        var secondViewController = UIViewController()
        if indexPath.row == 4{
            //secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "storySelect") as! StorySelectVC
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "localNotificationHome") as! LocalNotificationHomeVC
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }else{
            secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
            //self.present(secondViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        //選択時の色の変更をすぐ消す
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func makeTangoProgressGraph(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double,number:Int)->TangoProgressGraph{
        
        let graph = TangoProgressGraph(superViewWidth: superViewWidth, superViewHeight: superViewHeight, graphMaxWidth: graphMaxWidth, labelName: labelName, ratio: ratio,number:number)
        return graph
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
