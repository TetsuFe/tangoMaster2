//
//  CategorySelectWithGraphCell.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/01/28.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import Foundation
import UIKit

class CategorySelectWithGraphCell:UITableViewCell{
    
    var label1 : UILabel?
    var coloredGraph : ColoredDraw?
    var label2 : UILabel?
    var nonColoredGraph : NonColoredDraw?
    
    func setCell(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double, number:Int){
        
        let graphMaxWidth = 4*self.frame.width/6
        self.backgroundColor = UIColor.orange

        self.label1 = UILabel(frame: CGRect(x:0,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/6))
        
        self.coloredGraph = ColoredDraw(frame: CGRect(x: superViewWidth/6, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/8))
        
        self.label2 = UILabel(frame: CGRect(x:5*superViewWidth/6,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/6))
        
        self.nonColoredGraph = NonColoredDraw(frame: CGRect(x: superViewWidth/6 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/8))
        
        label1!.text = labelName
        label2!.text = String(Int(ratio*100)) + "%"
    }
    
}

class GraphSet{
    
    var label1 : UILabel
    var coloredGraph : ColoredDraw
    var label2 : UILabel
    var nonColoredGraph : NonColoredDraw
    
    init(superViewWidth:CGFloat,superViewHeight:CGFloat,graphMaxWidth:CGFloat,labelName:String,ratio:Double, number:Int){
        self.label1 = UILabel(frame: CGRect(x:0,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/6))
        
        self.coloredGraph = ColoredDraw(frame: CGRect(x: superViewWidth/6, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5, width: CGFloat(ratio) * graphMaxWidth, height: superViewHeight/8))
        
        self.label2 = UILabel(frame: CGRect(x:5*superViewWidth/6,y:CGFloat(number)*superViewHeight/5, width: superViewWidth/6, height: superViewHeight/6))
        
        self.nonColoredGraph = NonColoredDraw(frame: CGRect(x: superViewWidth/6 + CGFloat(ratio) * graphMaxWidth, y: 0.1*superViewHeight/5 + CGFloat(number) * superViewHeight/5,width: CGFloat(1.0 - ratio) * graphMaxWidth, height: superViewHeight/8))
        
        label1.text = labelName
        label2.text = String(Int(ratio*100)) + "%"
    }
}


class ColoredDraw: UIView {
    override func draw(_ rect: CGRect) {// 矩形 -------------------------------------
        let rectangle = UIBezierPath(rect: rect)
        // stroke 色の設定
        UIColor.blue.setStroke()
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

class NonColoredDraw: UIView {
    override func draw(_ rect: CGRect) {// 矩形 -------------------------------------
        let rectangle = UIBezierPath(rect: rect)
        // stroke 色の設定
        UIColor.blue.setStroke()
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
