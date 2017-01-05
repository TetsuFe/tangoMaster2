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
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var homeTableView: UITableView!
    
    //tableView
    let labelNames = ["単語一覧","単語テスト","単語カード","苦手リスト","ストーリー"]
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return labelNames.count
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
    
        let cell: HomeSelectCell = homeTableView.dequeueReusableCell(withIdentifier: "HomeSelectCell") as! HomeSelectCell
        
        cell.setCell(labelNames[indexPath.row])
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
        }
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(secondViewController, animated: false, completion: nil)
    }
}
