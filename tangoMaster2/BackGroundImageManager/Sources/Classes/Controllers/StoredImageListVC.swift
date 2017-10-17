//
//  StoredImageListVC.swift
//  PhotoLibraryImageTrimminger
//
//  Created by Satoshi Yoshio on 2017/10/04.
//  Copyright © 2017年 Yoshio. All rights reserved.
//

import UIKit

class StoredImageListVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    class BackgroundImageView : UIImageView{
        var idx : Int!
        var isSelected : Bool!
        init(image:UIImage?, isSelected: Bool, idx: Int){
            super.init(image: image)
            self.idx = idx
            self.isSelected = isSelected
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    var pointerIndex = 0
    var imageList = [UIImage]()
    var imageFileNameList = [String]()
    let imageFileManager = ImageFileManager()
    let imageListFileManager = ImageListFileManager()
    var photoLibraryManager : PhotoLibraryManager!
    let imageViewCreator = ImageViewCreator()
    var backgroundImageViewList = [BackgroundImageView]()
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var imageListView: UIView!
    @IBAction func backButton(_ sender: Any) {
        if navigationController != nil{
            _ = navigationController?.popViewController(animated: true)
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.flag = true
            let myFirstViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeVC
            let myNavigationController = UINavigationController(rootViewController: myFirstViewController)
            UIView.transition(with: (UIApplication.shared.keyWindow)!, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews], animations: {() -> Void in
                UIApplication.shared.keyWindow?.rootViewController = myNavigationController
            }, completion: { _ in })
        }
    }
    
    let MAX_STORED_IMAGE_NUM = 6 //以下のalertのmessageとも対応させる
    
    @IBAction func loadImageFromPhotoLibraryButton(_ sender: Any) {
        if imageList.count == MAX_STORED_IMAGE_NUM{
            let alert = UIAlertController(title: "制限に達しました",
                                          message: "画像が６つ未満になるように削除してください。",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確認", style: .cancel) { _ in
                self.refreshImageView()
            })
            self.present(alert, animated: true)
        }else{
            photoLibraryManager.callPhotoLibrary()
        }
    }
    
    @IBOutlet weak var deleteImageButton: UIButton!
    
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    @objc func selectImage(){
        UserDefaults.standard.set(imageFileNameList[pointerIndex], forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY)
        let alert = UIAlertController(title: "設定完了",
                                      message: "現在の壁紙に設定されました。",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .cancel) { _ in
            self.refreshImageView()
        })
        self.present(alert, animated: true)
    }
    
    @objc func tapImageView(sender: UITapGestureRecognizer){
        changeImageIndex(sender)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        clearAllBackgroundImageView()
    }
    
    
    //ないところはない画像をおく
    //基本６個まで表示するスクロールビュー
    
  
    
    func changeImageIndex(_ sender: UITapGestureRecognizer){
        //前に選択中だったUIImageViewへのborderを削除
        backgroundImageViewList[pointerIndex].layer.borderWidth = 0
        let senderView = sender.view as! BackgroundImageView
        pointerIndex = senderView.idx
        print("pointerIndex: \(pointerIndex)")
        senderView.layer.borderWidth = 5
        senderView.layer.borderColor = UIColor.blue.cgColor
        if let currentBackgroundImageFileName = UserDefaults.standard.string(forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY){
             if currentBackgroundImageFileName == imageFileNameList[pointerIndex] {
                if selectImageButton.title != "壁紙設定を解除"{
                    selectImageButton.removeTarget(self, action: #selector(selectImage), for: .touchUpInside)
                    selectImageButton.addTarget(self, action: #selector(unselectImage), for: .touchUpInside)
                    selectImageButton.setTitle("壁紙設定を解除", for: .normal)
                }
             }else{
                if selectImageButton.title != "壁紙に設定"{
                    selectImageButton.removeTarget(self, action: #selector(unselectImage), for: .touchUpInside)
                    selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
                    selectImageButton.setTitle("壁紙に設定", for: .normal)
                }
            }
        }
    }
    
    @objc func unselectImage(){
        UserDefaults.standard.set(nil, forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY)
        let alert = UIAlertController(title: "設定完了",
                                      message: "現在の壁紙から解除されました。",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .cancel) { _ in
            self.refreshImageView()
        })
        self.present(alert, animated: true)
        selectImageButton.removeTarget(self, action: #selector(unselectImage), for: .touchUpInside)
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectImageButton.setTitle("壁紙に設定", for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListView.backgroundColor = UIColor.white
        photoLibraryManager = PhotoLibraryManager(parentViewController: self)
        imageList = loadStoredImageList()
        if imageList.count > 0{
            deleteImageButton.isEnabled = true
            deleteImageButton.addTarget(self, action: #selector(tapDeleteButton), for:.touchUpInside)
        }
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if backgroundImageViewList.count == 0{
            if imageList.count > 0{
                pointerIndex = 0
                let imageFileNameList = imageListFileManager.readImageListFileToArray()
                if let currentBackgroundImageFileName = UserDefaults.standard.string(forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY){
                    makeBackgroundImageListView(currentBackgroundImageFileName: currentBackgroundImageFileName, imageFIleNameList: imageFileNameList)
                }else{
                    makeBackgroundImageListView(currentBackgroundImageFileName: "None", imageFIleNameList: imageFileNameList)
                }
                
                //背景に今壁紙になっているものを表示
                /*
                 let backgroundManager = BackgroundImageManager()
                 init(image: UIImage){
                 self.image = image
                 }
                 
                 let imageView = generateBackgroundImageView(image: UIImage, headerBottomY: )
                 imageListScrollView.addSubview()
                 
                 */
            }else{
                deleteImageButton.isEnabled = false
            }
        }
        setUpTapGestureForImageView()
        
    }
    
    func setUpTapGestureForImageView(){
        for i in 0..<backgroundImageViewList.count{
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapImageView(sender:)))
            tapGesture.numberOfTapsRequired = 1
            self.backgroundImageViewList[i].isUserInteractionEnabled = true
            self.backgroundImageViewList[i].addGestureRecognizer(tapGesture)
        }
    }
    
    func makeBackgroundImageListView(currentBackgroundImageFileName:String, imageFIleNameList: Array<String>){
        let ScreenSize = UIScreen.main.bounds.size
        for (i, imageFileName) in imageFIleNameList.enumerated(){
            //これがボトルネック？ Data -> UIImageが遅いのかもという話。
            let image = imageFileManager.readImageFile(fileName: imageFileName)
            
            if imageFileName == currentBackgroundImageFileName{
                backgroundImageViewList.append(BackgroundImageView(image: image, isSelected: true, idx: i))
                backgroundImageViewList[i].alpha = 1.0
                
            }else{
                backgroundImageViewList.append(BackgroundImageView(image: image, isSelected: false, idx: i))
                backgroundImageViewList[i].alpha = 0.5
            }
        }
        
        var aboveLayerMaxBottom = CGFloat(0.0)
        var thisLayerMaxBottom = CGFloat(0.0)
        for i in 0..<backgroundImageViewList.count{
            backgroundImageViewList[i].frame = CGRect(x: CGFloat(i%3)/3.0*imageListView.frame.width ,
                                                      y:aboveLayerMaxBottom,
                                                      width: ScreenSize.width/3,
                                                      height: backgroundImageViewList[i].frame.height*(imageListView.frame.width/3/backgroundImageViewList[i].frame.width))
            imageListView.addSubview(backgroundImageViewList[i])
            let bottom = backgroundImageViewList[i].frame.origin.y + backgroundImageViewList[i].frame.height
            if thisLayerMaxBottom <
                bottom{
                thisLayerMaxBottom = bottom
            }
            
            if i%3 == 2{
                aboveLayerMaxBottom = thisLayerMaxBottom
            }
        }
    }
    
    func loadStoredImageList()-> Array<UIImage>{
        var storedImageList = Array<UIImage>()
        imageFileNameList = imageListFileManager.readImageListFileToArray()
        print(imageFileNameList)
        for imageFileName in imageFileNameList{
            if let image = imageFileManager.readImageFile(fileName: imageFileName) {
                storedImageList.append(image)
            }
        }
        return storedImageList
    }
    
    @objc func tapDeleteButton(){
        if let currentBackgroundImageFileName = UserDefaults.standard.string(forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY){
            if currentBackgroundImageFileName == imageFileNameList[pointerIndex] {
                createAlertViewForForbiddenToDeleteImage()
            }else{
                createAlertViewForDeleteImage()
            }
        }
    }
    
    func createAlertViewForDeleteImage(){
        let alert = UIAlertController(title: "確認",
                                      message: "本当に削除しますか？",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "削除", style: .default) { (_) -> Void in
            self.deleteAndRefreshImageView()
        }
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel) { _ in
            // 何もしない
        })
        self.present(alert, animated: true)
    }
    
    func createAlertViewForForbiddenToDeleteImage(){
        let alert = UIAlertController(title: "注意",
        message: "現在壁紙に使用している画像は削除できません。",
        preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .cancel) { _ in
        // 何もしない
        })
        self.present(alert, animated: true)
    }
    
    func deleteAndRefreshImageView(){
        deleteImageView()
        refreshImageView()
    }
    
    func deleteImageView(){
        imageList.remove(at: pointerIndex)
        if imageList.count == 0{
            deleteImageButton.isEnabled = false
        }
        imageListFileManager.removeFromImageListFile(deletingFileName: imageFileNameList[pointerIndex])
    }
    
    func refreshImageView(){
        //再度データのロード
        imageList = loadStoredImageList()
        //一つ画像が減ったので、その前もしくは後の画像を表示（保存された画像が消した画像のみの場合は、何も表示しない）
        if imageList.count > 0{
            if pointerIndex != imageList.count{
                clearAllBackgroundImageView()
                if let currentBackgroundImageFileName = UserDefaults.standard.string(forKey: CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY){
                    let imageFileNameList = imageListFileManager.readImageListFileToArray()
                    makeBackgroundImageListView(currentBackgroundImageFileName: currentBackgroundImageFileName, imageFIleNameList: imageFileNameList)
                }else{
                    let imageFileNameList = imageListFileManager.readImageListFileToArray()
                    makeBackgroundImageListView(currentBackgroundImageFileName: "none", imageFIleNameList: imageFileNameList)
                }
            }else{
                backgroundImageViewList[pointerIndex].removeFromSuperview()
            }
        }
        setUpTapGestureForImageView()
    }
    
    func removeAllImageView(){
        for i in 0..<backgroundImageViewList.count{
            backgroundImageViewList[i].removeFromSuperview()
        }
    }
    
    func clearAllBackgroundImageView(){
        removeAllImageView()
        backgroundImageViewList = [BackgroundImageView]()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
        refreshImageView()
    }

    //写真選択完了後に呼ばれる標準メソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.photoLibraryImage = pickedImage
        }
        
        //withIdentifier: "imageEditVC"は遷移先のViewControllerのIdentifier。as! ImageEditVCは遷移先ののViewControllerの型名
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "trimImageVC") as! TrimImageVC
        picker.present(nextViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
