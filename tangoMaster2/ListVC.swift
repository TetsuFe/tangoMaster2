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
    
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func alphaSettingsButton(_ sender: Any) {
        showPopUpProgressView()
    }
    
    func showPopUpProgressView(){
        AlphaManagePopUpVC.parentVCType = .listVC
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alphaManageSettingPopUpVC") as! AlphaManagePopUpVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBOutlet weak var backgroundParentView: UIView!
    
    var backgroundImageView : UIImageView?
    
    let viewAlphaManager = ViewAlphaManager()
    
    func updateTransparency(){
        if viewAlphaManager.getTransparentSetting(){
           imageTableView.alpha = 0.7
        }else{
            imageTableView.alpha = 1.0
        }
    }
    
    override func viewDidLayoutSubviews(){
        if backgroundImageView == nil{
            showBackgroundImage()
        }
    }
    
    func showBackgroundImage(){
        if let currentBackgroundImageFileName = UserDefaults.standard.string(forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY){
            let imageFileManager = ImageFileManager()
            backgroundImageView = UIImageView(image: imageFileManager.readImageFile(fileName: currentBackgroundImageFileName))
            fitWidthOfImageView(changingImageView: backgroundImageView!, parentView: backgroundParentView)
            backgroundParentView.addSubview(backgroundImageView!)
        }else{
            //backgroundParentView.removeFromSuperview()
        }
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
        //以下２行は壁紙用の設定
        //imageTableView.backgroundView = backgroundParentView
        updateTransparency()
    }
    
    func updateCell(){
        let tango = readFilegetTangoArray(NORMAL_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber], extent: "txt",inDirectory: "tango/seedtango")
        listForTable = Array<NewImageReibun>()
        cell = Array<ListCell>()
        
        for r in 0..<tango.count/6{
            listForTable.append(NewImageReibun(eng: tango[6*r],jpn:tango[6*r+1],engReibun:tango[6*r+2],jpnReibun:tango[6*r+3],nigateFlag: tango[6*r+4],partOfSpeech:tango[6*r+5]))
        }
        //苦手ラベルをつけるために苦手を参照
        let nigateArray:Array<String> = getTangoArrayFromFile(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber])
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
            cell[r].setCell(listForTable[r],chapterSetsuNumber: String(appDelegate.chapterNumber*5+appDelegate.setsuNumber))
        }
    }

    @IBAction func prevChapButton(_ sender: Any) {
        //ボタンをタップした時に実行するメソッドを指定
        if(appDelegate.modeTag == 0){
            if(appDelegate.chapterNumber*5+appDelegate.setsuNumber > 0){
                if appDelegate.setsuNumber == 0{
                    appDelegate.chapterNumber -= 1
                    appDelegate.setsuNumber = 4
                }else{
                    appDelegate.setsuNumber -= 1
                }
                updateCell()
                imageTableView.reloadData()
            }else if appDelegate.chapterNumber == 0{
                appDelegate.chapterNumber = chapterNames[appDelegate.problemCategory].count-1
                appDelegate.setsuNumber = 4
                updateCell()
                imageTableView.reloadData()
            }
            
        }else if(appDelegate.modeTag == 1){
            if(appDelegate.chapterNumber*5+appDelegate.setsuNumber != 0){
                //これはよくない。苦手があるchapterの数を調べた方がいい（newChapterで代用できないか？
                //意味は一応同じ。一つ前（先）のchpaterに苦手がなければ進まない
                if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber-1]) != 0{
                    if appDelegate.setsuNumber == 0{
                        appDelegate.chapterNumber -= 1
                        appDelegate.setsuNumber = 4
                    }else{
                        appDelegate.setsuNumber -= 1
                    }
                    updateCell()
                    imageTableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func nextChapButton(_ sender: Any) {
        if(appDelegate.modeTag == 0){
            if(appDelegate.chapterNumber*5+appDelegate.setsuNumber < NORMAL_FILE_NAMES[appDelegate.problemCategory].count-1){
                if(appDelegate.setsuNumber == 4){
                    appDelegate.chapterNumber += 1
                    appDelegate.setsuNumber = 0
                }else{
                    appDelegate.setsuNumber += 1
                }
                updateCell()
                imageTableView.reloadData()
            }else{
                appDelegate.chapterNumber = 0
                appDelegate.setsuNumber = 0
                updateCell()
                imageTableView.reloadData()
            }
        }else if(appDelegate.modeTag == 1){
            //次のchapterを調べるので、次があることを確認する
            if(appDelegate.chapterNumber*5+appDelegate.setsuNumber < NIGATE_FILE_NAMES[appDelegate.problemCategory].count-1){
                if getNigateTangoVolume(fileName: NIGATE_FILE_NAMES[appDelegate.problemCategory][appDelegate.chapterNumber*5+appDelegate.setsuNumber+1]) != 0{
                    if(appDelegate.setsuNumber == 4){
                        appDelegate.chapterNumber += 1
                        appDelegate.setsuNumber = 0
                    }else{
                        appDelegate.setsuNumber += 1
                    }
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
        return sectionList[appDelegate.problemCategory]+" "+chapterNames[appDelegate.problemCategory][appDelegate.chapterNumber]+"-"+String(appDelegate.setsuNumber+1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
