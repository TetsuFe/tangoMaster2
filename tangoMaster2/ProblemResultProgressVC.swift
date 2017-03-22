//
//  ProblemResultProgressVC.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/02/26.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class ProblemResultProgressVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    
    var timer = Timer()
    var begin = CGFloat()
    var end   = CGFloat()
    let step: CGFloat = 1.0
    
    var progressID = Int()
    var originProgressBarFrame = CGRect()
    
    //後で削除するために、ここで参照を保持
    var percentLabel = UILabel()
    var drawer = ColoredDrawer()
    
    
    // override func viewDidLoad() {
    // super.viewDidLoad()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("popUpView: \(popUpView.frame)")
        popUpView.backgroundColor = UIColor.orange
        let graphMaxWidth = 2*popUpView.frame.width/3
        
        //let ratios = [0.8,0.6,0.2,1]
        var newChapterNumbers = getNewChapterArray()
        //現在・上級を作っていないのでその分を追加
        while(newChapterNumbers.count < 4){
            newChapterNumbers.append(0)
        }
        var ratios = Array<Double>()
        for i in 0..<sectionList.count+1 {
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

        
        let labelNames = ["初級","中級","上級","合計"]
        
        //タイトルの追加
        let graphTitle = UILabel(frame: CGRect(x:0,y:0, width: popUpView.frame.width, height: popUpView.frame.height/7))
        graphTitle.text = "単語テストクリア率"
        popUpView.addSubview(graphTitle)
        var graphs = Array<TangoProgressGraph2>()
        
        //グラフの追加
        
        for i in 0..<labelNames.count{
            
            graphs.append(makeTangoProgressGraph(superViewWidth: popUpView.frame.width, superViewHeight: popUpView.frame.height, graphMaxWidth: graphMaxWidth, labelName: labelNames[i], ratio: ratios[i],number:i+1))
            
            popUpView.addSubview(graphs[i].label1)
            popUpView.addSubview(graphs[i].label2)
            popUpView.addSubview(graphs[i].coloredGraph)
            popUpView.addSubview(graphs[i].nonColoredGraph)
        }
        
        let doneButton = UIButton(frame: CGRect(x: popUpView.frame.width/2 - popUpView.frame.width/12, y: 0.1*popUpView.frame.height/3 + CGFloat(labelNames.count) * popUpView.frame.height/5,width: popUpView.frame.width/6,height: popUpView.frame.height/8))
        
        doneButton.title = "OK"
        doneButton.layer.borderWidth = 1
        
        doneButton.addTarget(self, action: #selector(self.removeAnimate), for: .touchUpInside)
        
        popUpView.addSubview(doneButton)
        
        //ポップアップ処理のセット二行。ポップアップ以外部分を暗い透明にし、ポップアップ
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        //どのカテゴリが変化するのか調べる progressID = appDelegate.problemCategory
        //progressID = Int(arc4random()) % 4
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        progressID = appDelegate.problemCategory
        
        //後にprogressDrawでも使うので、endとは区別する必要あり
        originProgressBarFrame = graphs[progressID].coloredGraph.frame
        
        graphs[progressID].coloredGraph.removeFromSuperview()
        graphs[progressID].label2.removeFromSuperview()
        
        //各カテゴリで一つクリアしたときのグラフの増減をゴールから逆算
        if progressID == 0{
            //900/20 = 45
            begin = originProgressBarFrame.width-graphMaxWidth/45
        }else if progressID == 1{
            //600/20 = 30
            begin = originProgressBarFrame.width-graphMaxWidth/30
        }else if progressID == 2{
            //300/20 = 15
            begin = originProgressBarFrame.width-graphMaxWidth/15
        }else{
            //progressID は0..<3なので、ここには入らない。あくまでも仮. 
            //all 1800/20 = 90 実際にアニメーションはなし
            //begin = originProgressBarFrame.width-graphMaxWidth/90
        }
        end = originProgressBarFrame.width
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(progressDraw), userInfo: nil, repeats: true)
    }
    
    func progressDraw(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.isProblemCleared){
            if(begin <= end){
                self.begin += step
                drawer.removeFromSuperview()
                drawer = ColoredDrawer(frame: CGRect(x: originProgressBarFrame.origin.x, y: originProgressBarFrame.origin.y, width: begin, height: originProgressBarFrame.height))
                popUpView.addSubview(drawer)
                percentLabel.removeFromSuperview()
                percentLabel = UILabel(frame: CGRect(x:5*popUpView.frame.width/6,y:CGFloat(progressID+1)*popUpView.frame.height/6, width: popUpView.frame.width/6, height: popUpView.frame.height/7))
                percentLabel.text = "\(Int(100*begin / (2*popUpView.frame.width/3)))%"
                popUpView.addSubview(percentLabel)
            }else{
                timer.invalidate()
                print("timer finished")
            }
        }else{
            self.begin = end
            drawer.removeFromSuperview()
            drawer = ColoredDrawer(frame: CGRect(x: originProgressBarFrame.origin.x, y: originProgressBarFrame.origin.y, width: begin, height: originProgressBarFrame.height))
            popUpView.addSubview(drawer)
            percentLabel.removeFromSuperview()
            percentLabel = UILabel(frame: CGRect(x:5*popUpView.frame.width/6,y:CGFloat(progressID+1)*popUpView.frame.height/6, width: popUpView.frame.width/6, height: popUpView.frame.height/7))
            percentLabel.text = "\(Int(100*begin / (2*popUpView.frame.width/3)))%"
            popUpView.addSubview(percentLabel)
            timer.invalidate()
            print("timer finished")
        }
    }
    
    
    func makeTangoProgressGraph(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double,number:Int)->TangoProgressGraph2{
        
        let graph = TangoProgressGraph2(superViewWidth: superViewWidth, superViewHeight: superViewHeight, graphMaxWidth: graphMaxWidth, labelName: labelName, ratio: ratio,number:number)
        return graph
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

}


class TangoProgressGraph2{
    
    var label1 : UILabel
    var coloredGraph : ColoredDrawer
    var label2 : UILabel
    var nonColoredGraph : NonColoredDrawer
    
    init(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double, number:Int){
        self.label1 = UILabel(frame: CGRect(x:0,y:CGFloat(number)*superViewHeight/6, width: superViewWidth/6, height: superViewHeight/7))
        
        self.coloredGraph = ColoredDrawer(frame: CGRect(x: superViewWidth/6, y: 0.1*superViewHeight/6 + CGFloat(number) * superViewHeight/6, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/8))
        
        self.label2 = UILabel(frame: CGRect(x:5*superViewWidth/6,y:CGFloat(number)*superViewHeight/6, width: superViewWidth/6, height: superViewHeight/7))
        
        self.nonColoredGraph = NonColoredDrawer(frame: CGRect(x: superViewWidth/6 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/6 + CGFloat(number) * superViewHeight/6,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/8))
        
        label1.text = labelName
        label2.text = String(Int(ratio*100)) + "%"
    }
}
