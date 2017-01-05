//
//  NovelVC.swift
//  tangoMaster5
//
//  Created by Tetsu on 2016/12/24.
//  Copyright © 2016年 Tetsu. All rights reserved.
//


//class NovelVC: UIViewController {

import UIKit
import SpriteKit
import Foundation


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class NovelScene: SKScene {
    public func readFileGetSentences(_ fileName:String,extent:String)->Array<String>{
        var sentence = String()
        var sentenceArray = Array<String>()
        if let filePath = Bundle.main.path(forResource: fileName, ofType: extent) {
            do {
                let str = try String(contentsOfFile: filePath,encoding: String.Encoding.utf8)
                for s in str.characters{
                    if(s == "@"){
                        sentenceArray.append(sentence)
                        sentence = String()
                    }
                    else{
                        sentence.append(s)
                    }
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        print(sentenceArray.count)
        return sentenceArray
    }
    var index:Int = 0
    var arrayEng = Array<String>()
    var arrayJpn = Array<String>()
    var characterSprite:SKSpriteNode? = SKSpriteNode(imageNamed:"miu.jpg")
    var textZone = SKSpriteNode()
    //背景ボタン
    var backGroundButton:SKSpriteNode? = SKSpriteNode(imageNamed: "sanobabackg1.jpg")
    var jpnEngButton = UIButton()
    
    //var sendText = CSendText(fontsize: 16.0,posX:0,posY:0)
    var sendTextEng = CSendText(fontsize: 14.0,posX:0,posY:0)
    var sendTextJpn = CSendText(fontsize: 14.0,posX:0,posY:0)
    
    
    var testLabel = UILabel()

    
    override func didMove(to view: SKView) {
        
        if let characterSprite = self.characterSprite{
            characterSprite.size = CGSize(width:self.frame.height/5,height: self.frame.width/2)
            characterSprite.position = CGPoint(x:0,y: 0)
            if let backGroundButton = self.backGroundButton{
                backGroundButton.size = CGSize(width:self.frame.height,height: self.frame.width)
                backGroundButton.position = CGPoint(x:self.frame.height/2,y: self.frame.width/2)
                backGroundButton.name = "button2"
                backGroundButton.addChild(characterSprite)
                self.addChild(backGroundButton)
            }
        }
        
        textZone.size = CGSize(width:self.frame.height,height: 86)
        textZone.position = CGPoint(x:self.frame.height/2,y:42)
        textZone.color = UIColor.black
        textZone.alpha = 0.5
        self.addChild(textZone)
        
        self.jpnEngButton.backgroundColor = UIColor.clear
        self.jpnEngButton.setTitle("日本語", for: .normal)
        self.jpnEngButton.addTarget(self, action: #selector(switchJpnEng), for: .touchUpInside)
        self.jpnEngButton.frame.size = CGSize(width: 80, height: 30)
        self.jpnEngButton.layer.borderWidth = 1
        self.jpnEngButton.frame.origin = CGPoint(x:self.backGroundButton!.frame.width - 80, y: self.backGroundButton!.frame.height - 114)
        self.view!.addSubview(self.jpnEngButton)
        
        let storyNameEng = "dangoEngStory"
        let storyNameJpn = "dangoStory"
        
        self.arrayEng = self.readFileGetSentences(storyNameEng,extent:"txt")
        self.arrayJpn = self.readFileGetSentences(storyNameJpn,extent:"txt")
        for j in self.arrayEng{
            print(j)
        }
        for j in self.arrayJpn{
            print(j)
        }
        
        
        
        //self.sendText.m_parentScene = self.backGroundButton
        self.sendTextEng.m_parentScene = self.textZone
        //self.sendText.m_posX = CGFloat(-self.frame.height/2.3)
        //self.sendText.m_posY = CGFloat(-self.frame.width/4-10)
        self.sendTextEng.m_posX = CGFloat(-self.frame.height/2.3)
        self.sendTextEng.m_posY = CGFloat(72)
        self.sendTextEng.m_fontName = "Helvetica"
        self.sendTextEng.drawText(self.arrayEng[0])
        
        //self.sendText.m_parentScene = self.backGroundButton
        self.sendTextJpn.m_parentScene = self.textZone
        //self.sendText.m_posX = CGFloat(-self.frame.height/2.3)
        //self.sendText.m_posY = CGFloat(-self.frame.width/4-10)
        self.sendTextJpn.m_posX = CGFloat(-self.frame.height/2.3)
        self.sendTextJpn.m_posY = CGFloat(30)
        self.sendTextJpn.m_fontName = "HiraMinProN-W3"
        
        self.sendTextJpn.drawText(self.arrayJpn[0])
        
        //英語フォントテスト
        testLabel.frame = CGRect(x: 50, y: 50, width: 1000, height: 50)
        testLabel.font = UIFont(name:"Helvetica", size:UIFont.labelFontSize)
        testLabel.text =  "I am first time"
        self.view!.addSubview(testLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "button2" {
                print("button2 tapped")
                if jpnEngShowFlag == 0{
                    sendTextJpn.m_posX = CGFloat(10000)
                }
                if(self.index < self.arrayEng.count-1){
                    self.index += 1
                    print(self.index)
                    let flag = sendTextEng.changeText(self.arrayEng[self.index])
                    if(flag == false){
                        self.index -= 1
                    }else{
                        self.index -= 1
                    }
                }
                
                if jpnEngShowFlag == 1{
                    sendTextEng.m_posX = CGFloat(10000)
                }
                if(self.index < self.arrayJpn.count-1){
                    self.index += 1
                    print(self.index)
                    let flag = sendTextJpn.changeText(self.arrayJpn[self.index])
                    if(flag == false){
                        self.index -= 1
                    }
                }
            }
        }
    }
    deinit {
        print("test")
        self.characterSprite = nil
        self.backGroundButton = nil
    }
    
    var jpnEngShowFlag:UInt8 = 1
    
    func switchJpnEng(){
        sendTextEng.remove()
        sendTextJpn.remove()
        jpnEngShowFlag += 1
        if jpnEngShowFlag == 1{
            showEngText()
            self.jpnEngButton.setTitle("日本語", for: .normal)
        }else if jpnEngShowFlag == 2{
            showJpnText()
            self.jpnEngButton.setTitle("日英同時", for: .normal)
        }else{
            showJpnEngText()
            self.jpnEngButton.setTitle("英語",for: .normal)
            jpnEngShowFlag = 0
        }
        self.jpnEngButton.frame.origin = CGPoint(x:self.backGroundButton!.frame.width - 80, y: self.backGroundButton!.frame.height - 114)
    }
    //順番を考える。英ー＞日ー＞英・日
    //つまり、英ー＞日では、テキストのみ変えれば良い
    //テキストの配列自体はもともと両方必要
    func showEngText(){
        //y = 0で初期化。３行目は行かないよう制限。
        //使う配列が英語。フォントは？14
        textZone.size = CGSize(width:self.frame.width,height: 50)
        textZone.position = CGPoint(x:self.frame.width/2,y:21)

        sendTextEng = CSendText(fontsize: 14.0,posX:-self.textZone.frame.width/2.3,posY:self.textZone.frame.height)

        
        self.sendTextEng.m_parentScene = self.textZone
        //self.sendTextEng.m_posX = CGFloat(0)
        //self.sendTextEng.m_posY = CGFloat(30)
        self.sendTextEng.m_fontName = "Helvetica"
        self.sendTextEng.drawText(self.arrayEng[self.index])
    }
    func showJpnText(){
        //テキストバックは３行分。
        //y = 0で初期化。３行目は行かないよう制限。
        //使う配列が日本語。フォントはヒラギノ14
        
        textZone.size = CGSize(width:self.frame.width,height: 50)
        textZone.position = CGPoint(x:self.frame.width/2,y:21)

        sendTextJpn = CSendText(fontsize: 14.0,posX:-self.textZone.frame.width/2.3,posY:self.textZone.frame.height)
        
        self.sendTextJpn.m_parentScene = self.textZone
        //self.sendTextJpn.m_posX = CGFloat(0)
        //self.sendTextJpn.m_posY = CGFloat(30)
        self.sendTextJpn.m_fontName = "HiraMinProN-W3"
        self.sendTextJpn.drawText(self.arrayJpn[self.index])
    }
    func showJpnEngText(){
        //テキストバックは６行分
        //英語
        //y = 0で初期化。３行目は行かないよう制限。
        //使う配列が英語。フォントは？14
        //日本語
        //y = 0で初期化。7行目は行かないよう制限。
        //使う配列が日本語。フォントはヒラギノ14
        textZone.size = CGSize(width:self.frame.width,height: 100)
        textZone.position = CGPoint(x:self.frame.width/2,y:42)

        sendTextEng = CSendText(fontsize: 14.0,posX:-self.textZone.frame.width/2.3,posY:self.textZone.frame.height/1.3)
        sendTextJpn = CSendText(fontsize: 14.0,posX:-self.textZone.frame.width/2.3,posY:self.textZone.frame.height/3.5)

        
        //self.sendText.m_parentScene = self.backGroundButton
        self.sendTextEng.m_parentScene = self.textZone
        //self.sendText.m_posX = CGFloat(-self.frame.height/2.3)
        //self.sendText.m_posY = CGFloat(-self.frame.width/4-10)
        //self.sendTextEng.m_posX = CGFloat(0)
        //self.sendTextEng.m_posY = CGFloat(72)
        self.sendTextEng.m_fontName = "Helvetica"
        self.sendTextEng.drawText(self.arrayEng[self.index])
        
        //self.sendText.m_parentScene = self.backGroundButton
        self.sendTextJpn.m_parentScene = self.textZone
        //self.sendText.m_posX = CGFloat(-self.frame.height/2.3)
        //self.sendText.m_posY = CGFloat(-self.frame.width/4-10)
        //self.sendTextJpn.m_posX = CGFloat(0)
        //self.sendTextJpn.m_posY = CGFloat(30)
        self.sendTextJpn.m_fontName = "HiraMinProN-W3"
        
        self.sendTextJpn.drawText(self.arrayJpn[self.index])
    }
}

class NovelVC: UIViewController {
    
    var storyArray = Array<String>()
    
    static var backButton = UIButton()
    
    var scene:NovelScene?
    
    func backHome(){
        self.dismiss(animated:true)
    }
    
    var exitButton = UIButton()
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let skView = self.view as! SKView
        
        //表示されるテキスト
        NovelVC.backButton.setTitle("save", for: .normal)
        
        //テキストの色
        //NovelVC.backButton.setTitleColor(UIColor.blue, for: .normal)
        NovelVC.backButton.setTitleColor(UIColor.blue, for: .normal)
        
        //タップした状態の色
        NovelVC.backButton.setTitleColor(UIColor.red, for: .highlighted)
        
        //サイズ
        NovelVC.backButton.frame = CGRect(x:0, y:0, width:100, height:30)
        
        //タグ番号
        NovelVC.backButton.tag = 1
        
        //配置場所
        NovelVC.backButton.layer.position = CGPoint(x: 0, y: 0)
        
        
        //背景色
        NovelVC.backButton.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.2)
        NovelVC.backButton.backgroundColor = UIColor.clear
        
        //角丸
        NovelVC.backButton.layer.cornerRadius = 10
        
        //ボーダー幅
        NovelVC.backButton.layer.borderWidth = 1
        
        //ボタンをタップした時に実行するメソッドを指定
        NovelVC.backButton.addTarget(self, action: #selector(self.backHome), for: .touchUpInside)
        
        //viewにボタンを追加する
        self.view.addSubview(NovelVC.backButton)
        
        self.exitButton.backgroundColor = UIColor.clear
        self.exitButton.setTitle("やめる", for: .normal)
        self.exitButton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
        self.exitButton.frame.size = CGSize(width: 80, height: 30)
        self.exitButton.layer.borderWidth = 1
        self.exitButton.frame.origin = CGPoint(x: self.view.frame.height - 80 - 80, y: self.view.frame.width - 114)
        self.view!.addSubview(self.exitButton)

        
        scene = NovelScene(size: CGSize(width:self.view.frame.height,height: self.view.frame.width))
        scene!.scaleMode = .resizeFill
        scene!.backgroundColor = UIColor.clear
        skView.presentScene(scene!)
    }
    
    func back(){
        
    }
    
    
    // デバイスの向きを強制的に横画面に
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.landscapeRight
        return orientation
    }
    
    //指定方向に自動的に変更
    override var shouldAutorotate : Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool
        ) {
        //let skView = self.view
        //let skView = self.view as! SKView
        //skView.presentScene(nil)
    }
    
    deinit{
        print("NovelScene destroy")
        self.view = nil
        self.scene = nil
    }
}


enum eTextState: Int {
    case send = 0       // 通常文字送り
    case skip           // 文字送りスキップ
    case remove         // 貼付けた文字の取り外し
}

/**
 *  文字送り用クラス
 *  現在は横文字表示しか対応していません。
 */

class CSendText {
    
    // メンバ変数
    // テキストを文字送りするのに必要そうな変数
    var m_text: String?                 // 表示する文字列
    var m_count: Int = 0                // テキストの文字数取得
    var m_strcount: CGFloat = 0.0       // 現在何文字目表示したか
    var m_delayTime: CGFloat = 0.1      // 一文字毎に描画するのを遅らせる秒数
    var m_nextLineKey: Character = "\n" // 改行キー
    //var m_parentScene: SKScene?         // とりつけるシーン
    var m_parentScene: SKSpriteNode?         // とりつけるノード
    var m_fontSize: CGFloat = 14.0      // フォントサイズ
    
    var m_labelArray: Array<SKLabelNode> = []   // 表示しているラベル達
    
    // 文字の位置決定用変数(後で変換するのが面倒なのでCGCloatで作成)
    var x: UInt = 0              // 横に何文字目か
    var y: UInt = 3          // 何行目か
    var maxWidth: UInt = 300       // 横に最大何文字表示するか起動時に再設定？
    var m_posX: CGFloat?
    var m_posY: CGFloat?
    var m_color: UIColor = UIColor.white
    var m_drawEndFlag: Bool = false
    var m_fontName:String?
    //var m_fontName =
    
    var m_state: eTextState = .send {
        willSet{}
        didSet{
            switch m_state {
            case .send:
                self.m_delayTime = 0.1
            case .skip:
                self.skipDraw(m_text)
            case .remove:
                self.remove()
            }
        }
    }
    convenience init(fontsize: CGFloat!, posX: CGFloat!, posY: CGFloat!){
        self.init(text: nil, fontsize: fontsize, posX: posX, posY: posY,addView: nil,nextLineKey: nil, maxWidth: nil, delayTime: nil, mode: nil, color: nil)
    }
    init(text: String!, fontsize: CGFloat!, posX: CGFloat!, posY: CGFloat!, addView: SKScene!,
         nextLineKey: Character!, maxWidth: UInt!, delayTime: CGFloat!, mode: eTextState!, color: UIColor!){
        
        if (nextLineKey != nil) { m_nextLineKey = nextLineKey }
        if (maxWidth != nil)    { self.maxWidth = maxWidth }
        if (delayTime != nil)   { self.m_delayTime = delayTime }
        if (mode != nil)        { self.m_state = mode }
        if (fontsize != nil)    { self.m_fontSize = fontsize }
        if (color != nil)       { self.m_color = color }
        
        
        self.m_posX = posX
        self.m_posY = posY
        //self.m_parentScene = addView
        //drawText(text)
    }
    
    
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// テキストの描画
    fileprivate func drawText(_ text2: String!){
        
        // テキストの保管と文字数の取得
        var text: String = text2
        m_text = text
        m_count = text.characters.count
        
        /*
         print("m_text = \(m_text)")
         print("m_count = \(m_count)")
         print("m_strcount = \(m_strcount)")
         print("m_delayTime = \(m_delayTime)")
         print("m_textLineKey = \(m_nextLineKey)")
         print("m_parentScene = \(m_parentScene)")       // とりつけるシーン
         print("m_fontSize = \(m_fontSize)") // フォントサイズ
         print("m_labelArray = \(m_labelArray)")
         print("x = \(x)")
         print("y = \(y)")         // 何行目か
         print("maxWidth = \(maxWidth)")
         print("m_posX = )\(m_posY)")
         print("m_color = \(m_color)")
         print("m_drawEndFlag = \(m_drawEndFlag)")
         */
        
        if m_count == 0 {
            m_drawEndFlag = true
            return
        }  // 空なら描画せず終了
        for _ in 1 ... m_count {
            if m_state == .remove {return }    // 表示途中で文字を消して、といった処理が来た時用のフラグと処理
            
            let chara:Character = text.remove(at: text.startIndex)         // 一文字目をテキストから削除
            
            if chara == m_nextLineKey {     // 嬲 は改行用のキー文時
                y += 1                    // 行目をプラス
                x = 0                   // 行が変わるので、横ずらしを初期化
            } else if x > maxWidth {    // 改行用の処理
                y += 1                     // 行目をプラス
                x = 0                   // 同上
                // } else if 1.5*(m_posX! + (m_fontSize * CGFloat(x)) + m_fontSize/2.0) > m_parentScene?.frame.height {
            } else if 2.5*(m_posX! + (m_fontSize * CGFloat(x)) + m_fontSize/2.0) > m_parentScene?.frame.width {   // 画面外にいかないように
                y += 1                     // 行目をプラス
                x = 0                   // 同上
            }
            x += 1
            
            if(chara != m_nextLineKey){
                let label: SKLabelNode = SKLabelNode(text: "\(chara)")
                label.fontSize = m_fontSize // フォントサイズ指定
                label.position = CGPoint(x: m_posX! + (m_parentScene?.frame.height)!/10.0 + CGFloat(x-1) * m_fontSize, y: m_posY! - (CGFloat(y) * m_fontSize)
                )   // 文字の位置設定
                label.alpha = 0.0           // 透明度の設定(初期は透明なので0.0)
                label.fontColor = m_color   // 文字色指定
                label.fontName = self.m_fontName
                
                // ラベルの取り付け
                m_parentScene?.addChild(label)
                //m_parentScene?.backgroundColor = UIColor.brown
                
                // ラベルの配列に登録
                m_labelArray.append(label)
                
                // 表示する時間をずらすためのアクションの設定
                let delay = SKAction.wait(forDuration: TimeInterval(m_delayTime *   m_strcount))  // 基本の送らせる時間に文字数を掛けることでずれを大きくする
                let fadein = SKAction.fadeAlpha(by: 2.0, duration: 0.2)   // 不透明にするアクションの生成
                let seq = SKAction.sequence([delay, fadein])            // 上記2つのアクションを連結
                label.run(seq)                                    // 実行
                m_strcount += 1.0             // 現在の文字数をプラス
            }
        }
        y = 3
        x = 0
        m_strcount = 0.0
    }
    
    
    
    /// スキップモードの文字の描画
    func skipDraw(_ text2: String!){
        if m_drawEndFlag { return }
        
        self.remove()
        
        // テキストの保管と文字数の取得
        
        var text: String = text2
        m_count = text.characters.count
        
        if m_count == 0 {
            m_drawEndFlag = true
            return
        }  // 空なら描画せず終了
        
        for _ in 1 ... m_count {
            if m_state == .remove { return }    // 表示途中で文字を消して、といった処理が来た時用のフラグと処理
            
            let chara:Character = text.remove(at: text.startIndex)         // 一文字目をテキストから削除
            
            if chara == m_nextLineKey {     // 嬲 は改行用のキー文時
                y += 1                     // 行目をプラス
                x = 0
            } else if x > maxWidth {    // 改行用の処理
                y += 1                     // 行目をプラス
                x = 0             // 行が変わるので、横にずらす距離を初期化
                // } else if 1.5*(m_posX! + (m_fontSize * CGFloat(x)) + m_fontSize/2.0) > m_parentScene?.frame.height {
            } else if 1.5*(m_posX! + (m_fontSize * CGFloat(x)) + m_fontSize/2.0) > m_parentScene?.frame.width {
                y += 1                      // 行目をプラス
                x = 0
            }
            x += 1
            
            // ラベルノードの生成
            let label: SKLabelNode = SKLabelNode(text: "\(chara)")  // "\(chara)"とすることでStringに変換
            // フォントサイズ指定
            label.fontSize = m_fontSize // フォントサイズ指定
            label.position = CGPoint(x: m_posX! + (m_parentScene?.frame.height)!/10.0 + CGFloat(x-1) * m_fontSize, y: m_posY! - (CGFloat(y) * m_fontSize)
            )   // 文字の位置設定
            label.fontColor = m_color   // 文字色指定
            label.alpha = 2.0
            label.fontName = self.m_fontName
            // 透明度の設定(スキップの場
            
            // ラベルの取り付け
            m_parentScene?.addChild(label)
            
            m_labelArray.append(label)
            
            m_strcount += 1.0
        }
        y = 3             // 縦ずらし初期化
        x = 0             // 横ずらし初期化
        m_strcount = 0.0  // 描画した文字数の初期化
    }
    
    /// 文字が全て表示されたかの確認
    func checkDrawEnd(){
        if m_labelArray.last?.alpha == 1.0 {
            m_drawEndFlag = true
        }
    }
    
    /// 描画モードの切り替え
    func changeState( _ mode: eTextState ){
        self.m_state = mode
        self.checkDrawEnd()
    }
    
    /// 描画の基本設定はそのままに、違う文へ切り替え
    func changeText(_ text: String!)->Bool{
        self.checkDrawEnd()
        if m_drawEndFlag {
            self.remove()
            self.changeState( .send )
            drawText(text)
            return true
        } else {
            self.changeState( .skip )
            return false
        }
    }
    
    /// ラベルの取り外し
    func remove(){
        while m_labelArray.count > 0  {
            m_labelArray.last?.removeFromParent()
            m_labelArray.removeLast()
            m_drawEndFlag = false
        }
    }
    deinit {
        print("CSendText destroy")
        //m_parentScene = nil
        //m_text = nil
    }
}


//日本 "HiraMinProN-W3"
//英語 "Helvetica"

