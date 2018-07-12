//
//  HelpVC.swift
//  tangoMaster2
//
//  Created by Tetsu on 2017/02/27.
//  Copyright © 2017年 Tetsu. All rights reserved.
//

import UIKit

class HelpVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var helpSelectTableView: UITableView!
    
    let helpOption = ["ホーム","単語リスト","単語カード","苦手リスト","単語テスト"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return helpOption.count
    }
    
    func tableView(_ tableView : UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        
        let cell = helpSelectTableView.dequeueReusableCell(withIdentifier: "helpSelectCell") as! HelpSelectCell
        
        cell.setCell(helpOption[indexPath.row])
        return cell
    }
    
    //Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.sceneTag = indexPath.row
        //let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "categorySelect") as! CategorySelectVC
            //self.present(secondViewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpSelectTableView.dataSource = self
        helpSelectTableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
