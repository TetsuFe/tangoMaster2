//
//  HeaderList.swift
//  tangoMaster
//
//  Created by Tetsu on 2016/10/03.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    /// ボタンのタイトルの取得/設定
    var title: String? {
        get {
            return self.title(for: .normal)
        }
        set(v) {
            UIView.performWithoutAnimation {
                self.setTitle(v, for: .normal)
                self.layoutIfNeeded()
            }
        }
    }
}

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
}

let defaultTextFileDirectoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"

let zeroMask = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
let ONE_MASK = "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
let BEG_MASK = "111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000"
let MID_MASK = "000000000000000000000000000000000000000000000111111111111111111111111111111000000000000000"
let ADV_MASK = "000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111"

let categoryNames = ["大学受験初級","大学受験中級","大学受験上級"]

let wrongbeginnerFileNames = ["wbeg1-1", "wbeg1-2", "wbeg1-3", "wbeg1-4", "wbeg1-5", "wbeg2-1", "wbeg2-2", "wbeg2-3", "wbeg2-4", "wbeg2-5", "wbeg3-1", "wbeg3-2", "wbeg3-3", "wbeg3-4", "wbeg3-5", "wbeg4-1", "wbeg4-2", "wbeg4-3", "wbeg4-4", "wbeg4-5", "wbeg5-1", "wbeg5-2", "wbeg5-3", "wbeg5-4", "wbeg5-5", "wbeg6-1", "wbeg6-2", "wbeg6-3", "wbeg6-4", "wbeg6-5", "wbeg7-1", "wbeg7-2", "wbeg7-3", "wbeg7-4", "wbeg7-5", "wbeg8-1", "wbeg8-2", "wbeg8-3", "wbeg8-4", "wbeg8-5", "wbeg9-1", "wbeg9-2", "wbeg9-3", "wbeg9-4", "wbeg9-5"]
let wrongmidFileNames = ["wmid1-1", "wmid1-2", "wmid1-3", "wmid1-4", "wmid1-5", "wmid2-1", "wmid2-2", "wmid2-3", "wmid2-4", "wmid2-5", "wmid3-1", "wmid3-2", "wmid3-3", "wmid3-4", "wmid3-5", "wmid4-1", "wmid4-2", "wmid4-3", "wmid4-4", "wmid4-5", "wmid5-1", "wmid5-2", "wmid5-3", "wmid5-4", "wmid5-5", "wmid6-1", "wmid6-2", "wmid6-3", "wmid6-4", "wmid6-5"]
let wrongadvancedFileName = ["wadv1-1", "wadv1-2", "wadv1-3", "wadv1-4", "wadv1-5", "wadv2-1", "wadv2-2", "wadv2-3", "wadv2-4", "wadv2-5", "wadv3-1", "wadv3-2", "wadv3-3", "wadv3-4", "wadv3-5"]
let WRONG_FILE_NAMES:Array<Array<String>> = [wrongbeginnerFileNames,wrongmidFileNames,wrongadvancedFileName]

//ファイル名　クリア後のchapter numberを書き込むsetNewChapterに対応
let checkNewChapterFileNames = ["newchapbeg","newchapmid","newchapadv"]
let fileVolumes:Array<Int> = [45,30,15] //900/20, 600/20, 300/20, 1000/20

//テストは2*2で行う
//最終的には〇〇fileNamesを使う
//let fileNames = [["tangoTest0","tangoTest1"],["tangoTest2","tangoTest3"]]
//let nigateFileNames =  [["nbeg1-1","nbeg1-2"],["nigateTest2","nigateTest3"]]

let sectionList:Array<String> = ["大学受験初級900","大学受験中級600","大学受験上級300"]

//sections = levels * chapters * chapterNumbers
let beginnerFileNames = ["beg1-1", "beg1-2", "beg1-3", "beg1-4", "beg1-5", "beg2-1", "beg2-2", "beg2-3", "beg2-4", "beg2-5", "beg3-1", "beg3-2", "beg3-3", "beg3-4", "beg3-5", "beg4-1", "beg4-2", "beg4-3", "beg4-4", "beg4-5", "beg5-1", "beg5-2", "beg5-3", "beg5-4", "beg5-5", "beg6-1", "beg6-2", "beg6-3", "beg6-4", "beg6-5", "beg7-1", "beg7-2", "beg7-3", "beg7-4", "beg7-5", "beg8-1", "beg8-2", "beg8-3", "beg8-4", "beg8-5", "beg9-1", "beg9-2", "beg9-3", "beg9-4", "beg9-5"]
let midFileNames = ["mid1-1", "mid1-2", "mid1-3", "mid1-4", "mid1-5", "mid2-1", "mid2-2", "mid2-3", "mid2-4", "mid2-5", "mid3-1", "mid3-2", "mid3-3", "mid3-4", "mid3-5", "mid4-1", "mid4-2", "mid4-3", "mid4-4", "mid4-5", "mid5-1", "mid5-2", "mid5-3", "mid5-4", "mid5-5", "mid6-1", "mid6-2", "mid6-3", "mid6-4", "mid6-5"]
let advancedFileName = ["adv1-1", "adv1-2", "adv1-3", "adv1-4", "adv1-5", "adv2-1", "adv2-2", "adv2-3", "adv2-4", "adv2-5", "adv3-1", "adv3-2", "adv3-3", "adv3-4", "adv3-5"]
let NORMAL_FILE_NAMES:Array<Array<String>> = [beginnerFileNames,midFileNames,advancedFileName]


let nbeginnerFileNames = ["nbeg1-1", "nbeg1-2", "nbeg1-3", "nbeg1-4", "nbeg1-5", "nbeg2-1", "nbeg2-2", "nbeg2-3", "nbeg2-4", "nbeg2-5", "nbeg3-1", "nbeg3-2", "nbeg3-3", "nbeg3-4", "nbeg3-5", "nbeg4-1", "nbeg4-2", "nbeg4-3", "nbeg4-4", "nbeg4-5", "nbeg5-1", "nbeg5-2", "nbeg5-3", "nbeg5-4", "nbeg5-5", "nbeg6-1", "nbeg6-2", "nbeg6-3", "nbeg6-4", "nbeg6-5", "nbeg7-1", "nbeg7-2", "nbeg7-3", "nbeg7-4", "nbeg7-5", "nbeg8-1", "nbeg8-2", "nbeg8-3", "nbeg8-4", "nbeg8-5", "nbeg9-1", "nbeg9-2", "nbeg9-3", "nbeg9-4", "nbeg9-5"]
let nmidFileNames = ["nmid1-1", "nmid1-2", "nmid1-3", "nmid1-4", "nmid1-5", "nmid2-1", "nmid2-2", "nmid2-3", "nmid2-4", "nmid2-5", "nmid3-1", "nmid3-2", "nmid3-3", "nmid3-4", "nmid3-5", "nmid4-1", "nmid4-2", "nmid4-3", "nmid4-4", "nmid4-5", "nmid5-1", "nmid5-2", "nmid5-3", "nmid5-4", "nmid5-5", "nmid6-1", "nmid6-2", "nmid6-3", "nmid6-4", "nmid6-5"]
let nadvancedFileName = ["nadv1-1", "nadv1-2", "nadv1-3", "nadv1-4", "nadv1-5", "nadv2-1", "nadv2-2", "nadv2-3", "nadv2-4", "nadv2-5", "nadv3-1", "nadv3-2", "nadv3-3", "nadv3-4", "nadv3-5"]
let NIGATE_FILE_NAMES:Array<Array<String>> =  [nbeginnerFileNames,nmidFileNames,nadvancedFileName]

let beginnerChapterNames = ["chapter1","chapter2","chapter3","chapter4","chapter5","chapter6","chapter7","chapter8","chapter9"]
let midChapterNames = ["chapter1","chapter2","chapter3","chapter4","chapter5","chapter6"]
let advancedChapterNames = ["chapter1","chapter2","chapter3"]
let chapterNames:Array<Array<String>> = [beginnerChapterNames,midChapterNames,advancedChapterNames]

let NOTIFICATION_MASK_FILE_NAME = "notificationMask"
let NIGATE_NOTIFICATION_MASK_FILE_NAME = "nigateNotificationMask"
let NOTIFICATION_MASK_FILE_NAMES = [NOTIFICATION_MASK_FILE_NAME, NIGATE_NOTIFICATION_MASK_FILE_NAME]
let prevMaskFileName = "prevNotificationCheckMask"
let nigatePrevMaskFileName = "nigatePrevNotificationCheckMask"

let hoursList:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,24]
let minutesList:Array<Int> = [1,5,10,20,30,60,120,180]

let NOTIFICATION_TYPE_KEY = "notificationType"
let NOTIFICATION_MINUTES_INDEX_KEY = "notificationMinutesIndex"
let NOTIFICATION_HOURS_INDEX_KEY = "notificationHoursIndex"
let NOTIFICATION_ISENABLED_KEY = "notificationIsEnabled"

let CURRENT_BACKGROUND_IMAGE_FILE_NAME_KEY = "background_image_file_name"

func getNewChapterArray()->Array<Int>{
    var newChapterNumbers = Array<Int>()
    for category in 0..<categoryNames.count{
        newChapterNumbers.append(getNewChapter(fileName: checkNewChapterFileNames[category], chapterVolume: fileVolumes[category]))
    }
    return newChapterNumbers
}


func readFilegetTangoArray(_ fileName:String,extent:String,inDirectory directoryName:String)->Array<String>{
    var wordArray = Array<String>()
    if let filePath = Bundle.main.path(forResource: fileName,ofType: extent,inDirectory:directoryName) {
        do {
            let str = try String(contentsOfFile: filePath,
                                 encoding: String.Encoding.utf8)
            //print(str)
            wordArray.append("")
            var j:Int = 0
            for s in str.characters{
                if(s != "@" && s != "\n"){
                    wordArray[j] += String(s)
                }
                else{
                    wordArray.append("")
                    j += 1
                }
            }
            //最後が空文字だった時最後の要素を削除
            if(wordArray[wordArray.count-1] == ""){
                wordArray.remove(at: wordArray.count-1)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    return wordArray
}

func getHashNum(_ str:String)->Int{
    if(str.characters.count==0){
        return 26
    }
    else{
        let firstStr = str[str.startIndex]
        print(firstStr)
        let hash = firstStr.unicodeScalarCodePoint()-97
        print(hash)
        return Int(hash)
    }
}

func addListJpnEngImg(_ strEng:String,strJpn:String,image:String,list:Array<Array<JpnEngImgTango>>)->Array<JpnEngImgTango>{
    let hash = getHashNum(strEng)
    var newList = list[hash]
    newList.append(JpnEngImgTango(eng: strEng,jpn: strJpn,imgPath: image))
    return newList
}

//間違いをどんどんついかしていく(append)故に、間違った後に正解しても結果が変わらない。
func getTangoEng(_ list:Array<Array<JpnEngImgTango>>)->Array<String>{
    var tangoForTable = Array<String>()
    for i in 0..<26{
        for j in 0..<list[i].count{
            tangoForTable.append(list[i][j].eng! + "@" + list[i][j].jpn!)
        }
    }
    return tangoForTable
}

func getTangoJpnEng(_ list:Array<Array<JpnEngImgTango>>)->Array<String>{
    var tangoForTable = Array<String>()
    for i in 0..<26{
        for j in 0..<list[i].count{
            tangoForTable.append(list[i][j].eng! + "@" + list[i][j].jpn!)
        }
    }
    return tangoForTable
}


func fileWrite(filew:FileHandle,filepath:String,fileObject:String){
    //offset = ファイル内のポインタの位置を示す

    //print("Offset = \(filew2?.offsetInFile)")
    let data = (fileObject as NSString).data(using: String.Encoding.utf8.rawValue)
    filew.seekToEndOfFile()
    filew.write(data!)
    //print("Offset = \(filew2?.offsetInFile)")
    //filew2?.closeFile()


}

func isInFile(cWord:String,str:String)->Bool{
    var flag:Bool = false
    var word = String()
    for s in str.characters{
        if(s != "@" && s != "\n"){
            word += String(s)
        }
        else{
            if(word == cWord){
                flag = true
                //print("exists")
                break;
            }
            word = ""
        }
    }
    return flag
}

func getTangoArrayFromString(str:String)->Array<String>{
    var wordArray = Array<String>()
    wordArray.append("")
    var j:Int = 0
    for s in str.characters{
        if(s != "@" && s != "\n"){
            wordArray[j] += String(s)
        }
        else{
            wordArray.append("")
            j += 1
        }
    }
    //最後が空文字だった時最後の要素を削除
    if(wordArray[wordArray.count-1] == ""){
        wordArray.remove(at: wordArray.count-1)
    }
    return wordArray
}


func getArrayNIRFromList(list:Array<Array<NewImageReibun>>)->Array<NewImageReibun>{
    var tempList : Array<NewImageReibun> = []
    for i in 0..<26{
        for j in 0..<list[i].count{
            tempList.append(list[i][j])
        }
    }
    return tempList
}


func addListNIR(list:Array<Array<NewImageReibun>>,eng:String,jpn:String,engReibun:String,jpnReibun:String,nigateFlag:String,partOfSpeech:String)->Array<NewImageReibun>{
    print(eng)
    let hash = getHashNum(eng)
    var newList = list[hash]
    newList.append(NewImageReibun(eng: eng,jpn: jpn,engReibun:engReibun,jpnReibun:jpnReibun,nigateFlag:nigateFlag,partOfSpeech:partOfSpeech))
    return newList
}


func getTangoArrayFromFile(fileName:String)->Array<String>{
    
    var tangoWordArray = Array<String>()
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = defaultTextFileDirectoryPath
    
    // "/Libraryを調べたい場合 "/folder_name" -> ""
    //"/Library/imagesの場合 "/folder_name" -> "/images"
    //let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] + "/folder_name"
    
    // -- start check directory --
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: true, attributes: nil)
    }
    // -- end check directory --
    // Do any additional setup after loading the view.
    
    // 保存するもの
    //let fileObject:String = eng+"@"+jpn+"\n"
    
    let filepath1 = "\(path)/\(fileName+".txt")"
    print("filepath1: \(filepath1)")
    
    //初回はnilが入るこれを使って初回のみファイルを作成するようにする
    //書き込み用で開くforWritingAtPath
    let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
    
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if(filew == nil){
        //try! fileObject.write(toFile: "\(path)/\(fileName)", atomically: true, encoding: String.Encoding.utf8)
    }
    
    //万能なforUpdatingAtPath
    //let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: filepath1)
    
    //読み込み用で開くforReadingAtPath
    let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
    if filer == nil {
        print("File open failed")
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        // NSData to String
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        //if judgeMatch(cWord: list[gtangoRow][gtangoColumn].eng, str:out){
        //  fileWrite(filew: filew, filepath:filepath1,fileObject:fileObject)
        // }
        tangoWordArray = getTangoArrayFromString(str:out)
        filer?.closeFile()
    }
    return tangoWordArray
}

func deleteFile(fileName:String){
    print("fileを削除します")
    let path = defaultTextFileDirectoryPath
    
    // "/Libraryを調べたい場合 "/folder_name" -> ""
    //"/Library/imagesの場合 "/folder_name" -> "/images"
    //let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] + "/folder_name"
    
    // -- start check directory --
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    // -- end check directory --
    // Do any additional setup after loading the view.
    
    let filepath1 = "\(path)/\(fileName+".txt")"
    print("delete\(filepath1)")
    
    do{
        try FileManager.default.removeItem(atPath: filepath1)
        print("file delete succeeded")
    }catch{
        print("file delete failed")
    }
}

/*
func deleteWordFromArray(eng:String,list2:Array<EightTango>)->Array<EightTango>{
    var tempList = list2
    for r in 0..<tempList.count{
        if(eng == tempList[r].eng){
            tempList.remove(at: r)
            break
        }
    }
    return tempList
}
 */

func deleteWordFromNigateArray(eng:String,list:Array<NewImageReibun>)->Array<NewImageReibun>{
    var deletedArray = list
    for i in 0..<deletedArray.count{
        if deletedArray[i].eng == eng{
            deletedArray.remove(at: i)
            break
        }
    }
    return deletedArray
}

func deleteWordFromNigateArraySeven(eng:String,list:Array<SixWithChapter>)->Array<SixWithChapter>{
    var deletedArray = list
    for i in 0..<deletedArray.count{
        if deletedArray[i].eng == eng{
            deletedArray.remove(at: i)
            break
        }
    }
    return deletedArray
}

func deleteWordFromOriginalArray(eng:String,list:Array<OriginalNotificationTango>)->Array<OriginalNotificationTango>{
    var deletedArray = list
    for i in 0..<deletedArray.count{
        if deletedArray[i].eng == eng{
            deletedArray.remove(at: i)
            break
        }
    }
    return deletedArray
}

func deleteOriginalFileName(fileName:String,from listFileStatuses:Array<OriginalTangoFileStatus>)->Array<OriginalTangoFileStatus>{
    var deletedArray = listFileStatuses
    for i in 0..<deletedArray.count{
        if deletedArray[i].fileName == fileName{
            deletedArray.remove(at: i)
            break
        }
    }
    return deletedArray
}


/*
func fileSet(fileName:String,eng:String,jpn:String,imgPath:String,engPhrase:String,jpnPhrase:String,nigateFlag:String,partsOfSpeech:String,soundPath:String){
    //get current word list
    
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = defaultTextFileDirectoryPath
    
    // "/Libraryを調べたい場合 "/folder_name" -> ""
    //"/Library/imagesの場合 "/folder_name" -> "/images"
    //let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] + "/folder_name"
    
    // -- start check directory --
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        //3.0
        //  try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        //2.1
        //try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
        //origin
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    // -- end check directory --
    // Do any additional setup after loading the view.
    
    // 保存するもの
    let fileObject:String = eng+"@"+jpn+"@"+imgPath+"@"+engPhrase+"@"+jpnPhrase+"@"+nigateFlag+"@"+partsOfSpeech+"@"+soundPath+"\n"
    
    let filepath1 = "\(path)/\(fileName+".txt")"
    
    //初回はnilが入るこれを使って初回のみファイルを作成するようにする
    //書き込み用で開くforWritingAtPath
    let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
    
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if(filew == nil){
        try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
    }
    
    //万能なforUpdatingAtPath
    //let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: filepath1)
    
    //読み込み用で開くforReadingAtPath
    let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
    if filer == nil {
        print("File open failed")
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        // NSData to String
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        // if judgeMatch(cWord: list[gtangoRow][gtangoColumn].eng, str:out){
        if !isInFile(cWord: eng, str:out){
            fileWrite(filew: filew!, filepath:filepath1,fileObject:fileObject)
        }
        filer?.closeFile()
    }
}
 */

func setFileOfProblemVolume(fileName:String,problemVolume:Int){
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = defaultTextFileDirectoryPath
    
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    // -- end check directory --
    
    // 保存するもの
    let fileObject:String = String(problemVolume)
    let filepath1 = "\(path)/\(fileName+".txt")"
    
    //初回はnilが入るこれを使って初回のみファイルを作成するようにする
    //書き込み用で開くforWritingAtPath
    
    
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if let filew = FileHandle(forWritingAtPath: filepath1){
        fileWrite(filew: filew, filepath:filepath1,fileObject:fileObject)
        filew.closeFile()
    }else{
        try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
    }
    
    let filer = FileHandle(forReadingAtPath: filepath1)
    
    if filer == nil {
        print("File open failed")
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        // NSData to String
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        print(out)
        filer?.closeFile()
    }
}

/*Deprecated
//あるchapterのファイルから苦手な単語を探し。EightTangoの配列として返す？
func getNigateTangoArray(fileName:String)->Array<CardTango>{
    let wholeArray = getTangoArrayFromFile(fileName: fileName)
    var nigateArray = Array<CardTango>()
    for r in 0..<nigateArray.count/8{
        //print(wholeArray[8*r+5])
        if(wholeArray[8*r+5] == "1"){
            nigateArray.append(CardTango(eng: wholeArray[8*r], jpn: wholeArray[8*r+1], soundPath: wholeArray[8*r+7]))
        }
    }
    return nigateArray
}
 */

/*
func getWrongTangoVolume(fileName:String)->Int{
    let wholeArray = getTangoArrayFromFile(fileName: fileName)
    var wrongVolume:Int = 0
    for _ in 0..<wholeArray.count/8{
        //print(wholeArray[8*r+5])
        wrongVolume += 1
    }
    return wrongVolume
}
 */


//あるチャプターのファイルの中身を検索し、苦手な単語の数を返す。forなどでイテレータfilenameを回し、それを各chapterの苦手数の配列などに順に格納するなどして利用する。
/*
func getNigateTangoVolume(fileName:String)->Int{
    print("getNigateTangoVolume")
    let nigateArray = getTangoArrayFromFile(fileName: fileName)
    var nigateCount = 0
    for r in 0..<nigateArray.count/8{
        print(nigateArray[8*r+5])
        if(nigateArray[8*r+5] == "1"){
            nigateCount += 1
        }
    }
    return nigateCount
}
 */

//上の改良版8->6


func getWrongTangoVolume(fileName:String)->Int{
    let wholeArray = getTangoArrayFromFile(fileName: fileName)
    var wrongVolume:Int = 0
    for _ in 0..<wholeArray.count/6{
        wrongVolume += 1
    }
    return wrongVolume
}


//あるチャプターのファイルの中身を検索し、苦手な単語の数を返す。forなどでイテレータfilenameを回し、それを各chapterの苦手数の配列などに順に格納するなどして利用する。

func getNigateTangoVolume(fileName:String)->Int{
    print("getNigateTangoVolume")
    let nigateArray = getTangoArrayFromFile(fileName: fileName)
    var nigateCount = 0
    for r in 0..<nigateArray.count/6{
        print(nigateArray[6*r+4])
        if(nigateArray[6*r+4] == "1"){
            nigateCount += 1
        }
    }
    return nigateCount
}


func getNigateVolumeArray()->Array<Array<Int>>{
    var nigateVolumeArray = Array<Array<Int>>()
    for category in 0..<NIGATE_FILE_NAMES.count{
        nigateVolumeArray.append(Array<Int>())
        for nigateFileName in NIGATE_FILE_NAMES[category]{
            nigateVolumeArray[category].append(getNigateTangoVolume(fileName: nigateFileName))
        }
    }
    for nigateVolume in nigateVolumeArray{
        print("nigateVolume: \(nigateVolume)")
    }
    return nigateVolumeArray
}




func getNewChapter(fileName:String,chapterVolume:Int)->Int{
    print("getNewChapter")
    var chapterNumber = 0
    let path = defaultTextFileDirectoryPath
    
    // -- start check directory --
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    
    // 保存するもの
    var fileObject:String = ""
    for _ in 0..<chapterVolume{
        fileObject = fileObject+"0"
    }
    
    let filepath1 = "\(path)/\(fileName+".txt")"
    let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if(filew == nil){
        try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
    }
    filew?.closeFile()
    
    //読み込み用で開くforReadingAtPath
    let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
    if filer == nil {
        print("File open failed in getNewChpater")
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        // NSData to String
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        // if judgeMatch(cWord: list[gtangoRow][gtangoColumn].eng, str:out){
        for s in out.characters{
            if(s == "0"){//未クリアの
                break
            }else if s == "1" && chapterNumber == chapterVolume{
                break //全てクリア済みの時は、存在しない次のchapternumberまでいかないように、ここで食い止める。
            }
            chapterNumber += 1//0章がクリアされた時、1になる。つまり、newchapternumberと基本は一致する。
        }
        filer?.closeFile()
    }
    print("new chapter number is \(chapterNumber)")
    return chapterNumber
}


func writeSevenFile(fileName:String,eng: String, jpn: String, engPhrase: String, jpnPhrase: String,nigateFlag:String,partOfSpeech:String,chapterNumber:String){
    let path = defaultTextFileDirectoryPath
    
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    
    let fileObject:String = eng+"@"+jpn+"@"+engPhrase+"@"+jpnPhrase+"@"+nigateFlag+"@"+partOfSpeech+"@"+String(chapterNumber)+"\n"
    
    let filepath1 = "\(path)/\(fileName+".txt")"
    let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
    if(filew == nil){
        try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
    }
    let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
    if filer == nil {
        print("File open failed")
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        if !isInFile(cWord: eng, str:out){
            fileWrite(filew: filew!, filepath:filepath1,fileObject:fileObject)
        }
        filer?.closeFile()
    }
}


func writeSixFile(fileName:String,eng: String, jpn: String, engPhrase: String, jpnPhrase: String,nigateFlag:String,partOfSpeech:String){
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = defaultTextFileDirectoryPath
    
    // "/Libraryを調べたい場合 "/folder_name" -> ""
    //"/Library/imagesの場合 "/folder_name" -> "/images"
    //let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] + "/folder_name"
    
    // -- start check directory --
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        //3.0
        //  try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        //2.1
        //try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
        //origin
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    // -- end check directory --
    // Do any additional setup after loading the view.
    
    // 保存するもの
    let fileObject:String = eng+"@"+jpn+"@"+engPhrase+"@"+jpnPhrase+"@"+nigateFlag+"@"+partOfSpeech+"\n"
    
    let filepath1 = "\(path)/\(fileName+".txt")"
    
    //初回はnilが入るこれを使って初回のみファイルを作成するようにする
    //書き込み用で開くforWritingAtPath
    let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
    
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if(filew == nil){
        try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
    }
    
    //万能なforUpdatingAtPath
    //let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: filepath1)
    
    //読み込み用で開くforReadingAtPath
    let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
    if filer == nil {
        print("File open failed")
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        //ファイルの中にすでにその単語があるかどうか確認して重複しないようにする
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        if !isInFile(cWord: eng, str:out){
            fileWrite(filew: filew!, filepath:filepath1,fileObject:fileObject)
        }
        filer?.closeFile()
    }
}

func backNearestNaviVC(currentVC:UIViewController){
    var presenting = currentVC.presentingViewController!
    while(true){
        if presenting is UINavigationController{
            presenting.dismiss(animated: true, completion: nil)
            break
        }
        presenting = presenting.presentingViewController!
    }
}

/*ファイルポインタ取得のコード
let path = defaultTextFileDirectoryPath

// -- start check directory --
let fileManager = FileManager.default
var isDir : ObjCBool = false

fileManager.fileExists(atPath: path, isDirectory: &isDir)

if !isDir.boolValue{
    try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
}
 let filepath1 = "\(path)/\(fileName+".txt")"
 let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
 // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
 if(filew == nil){
 try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
 }
 filew?.closeFile()

 let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)

*/

func easyFileHandle(directoryPath:String, fileName:String, extent:String)->FileHandle?{
    if let fileHandle = FileHandle(forReadingAtPath: directoryPath+"/"+fileName+"."+extent){
        return fileHandle
    }else{
        return nil
    }
}
/*
extension FileHandle{
    func readline() -> String?{
        print("readline")
        //読み込み用で開くforReadingAtPath
        let seekStep = 256
        let encoding : String.Encoding = .utf8
        let delimData = "\n".data(using: encoding)
        var buffer = Data(capacity: 256)
        print("offset \(self.offsetInFile)")
        //let tempData = self.readData(ofLength: seekStep)
        //print("offset \(self.offsetInFile)")
        var atEof = false
        while !atEof {
            let tmpData = self.readData(ofLength: seekStep)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
            if let range = buffer.range(of: delimData!) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
        }
        return nil
    }
}
*/
func writeFile(fileName:String, text:String){
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = defaultTextFileDirectoryPath
    
    // -- start check directory --
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: false, attributes: nil)
    }
    
    // 保存するもの
    let fileObject:String = text
    let filepath1 = "\(path)/\(fileName)"
    print("writeFile \(filepath1)")
    
    //初回はnilが入るこれを使って初回のみファイルを作成するようにする
    //書き込み用で開くforWritingAtPath
    
    
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if let filew = FileHandle(forWritingAtPath: filepath1){
        fileWrite(filew: filew, filepath:filepath1,fileObject:fileObject)
        filew.closeFile()
    }else{
        try! fileObject.write(toFile: "\(path)/\(fileName)", atomically: true, encoding: String.Encoding.utf8)
    }
}

func miniteToSecond(minute:Int)->Int{
    return minute*60
}

func selectMask(mask:String, range:Range<Int>)->String{
    var newMask = ""
    for (i, c) in mask.characters.enumerated(){
        if range.contains(i){
            newMask += "1"
        }else{
            newMask += String(c)
        }
    }
    return newMask
}

func deselectMask(mask:String, range:Range<Int>)->String{
    var newMask = ""
    for (i, c) in mask.characters.enumerated(){
        if range.contains(i){
            newMask += "0"
        }else{
            newMask += String(c)
        }
    }
    return newMask
}

/*
func plusMask(maskA:String, maskB:String)->String{
    var newMask = ""
    for (cA, cB) in zip(maskA.characters, maskB.characters){
        if cA == "1" && cB == "1"{
            newMask+="0"
        }else if cA == "0" && cB == "1"{
            newMask+="1"
        }else if cA == "1" && cB == "0"{
            newMask+="1"
        }else if cA == "0" && cB == "0"{
            newMask+="0"
        }
    }
    return newMask
}
 */


//graph表示用の単語数（その後分母で割り算する）

func getWillNotifyChapterVolume(maskFileName:String)->Array<Int>{
    var willNotifyChapterVolumes = [0,0,0]
    var category = 0
    var computedChapterVolume = 0
    let f = easyFileHandle(directoryPath:defaultTextFileDirectoryPath, fileName:maskFileName, extent:"txt")
    let currentMask = f!.readline()!
    print("maskcount:\(currentMask.characters.count)")
    for (cIndex,c) in currentMask.characters.enumerated(){
        if category == 0{
            if cIndex < fileVolumes[category]{
                if c == "1"{
                    willNotifyChapterVolumes[category] += 1
                }
            }else{
                computedChapterVolume += fileVolumes[category]
                category += 1
                if c == "1"{
                    willNotifyChapterVolumes[category] += 1
                }
            }
        }else if category > 0 && category < fileVolumes.count{
            if cIndex-computedChapterVolume < fileVolumes[category]{
                if c == "1"{
                    willNotifyChapterVolumes[category] += 1
                }
            }else{
                computedChapterVolume += fileVolumes[category]
                category += 1
                if c == "1"{
                    willNotifyChapterVolumes[category] += 1
                }
            }
        }else{
        }
    }
    for ChapterVolume in willNotifyChapterVolumes{
        print("ChapterVolume: \(ChapterVolume)")
    }
    return willNotifyChapterVolumes
}

func getWillNotifyNigateTangoVolume(maskFileName:String, nigateTangoVolumes1D:Array<Int>)->Array<Int>{
    var willNotifyNigateTangoVolumes = [0,0,0]
    var category = 0
    var computedChapterVolume = 0
    let f = easyFileHandle(directoryPath:defaultTextFileDirectoryPath, fileName:maskFileName, extent:"txt")
    let currentMask = f!.readline()!
    for (cIndex,c) in currentMask.characters.enumerated(){
        if category == 0{
            if cIndex < fileVolumes[category]{
                if c == "1"{
                    willNotifyNigateTangoVolumes[category] += nigateTangoVolumes1D[cIndex]
                }
            }else{
                computedChapterVolume += fileVolumes[category]
                category += 1
                if c == "1"{
                    willNotifyNigateTangoVolumes[category] += nigateTangoVolumes1D[cIndex]
                }
            }
        }else if category < fileVolumes.count{
            if cIndex - computedChapterVolume < fileVolumes[category]{
                if c == "1"{
                    willNotifyNigateTangoVolumes[category] += nigateTangoVolumes1D[cIndex]
                }
            }else{
                computedChapterVolume += fileVolumes[category]
                category += 1
                if c == "1"{
                    willNotifyNigateTangoVolumes[category] += nigateTangoVolumes1D[cIndex]
                }
            }
        }else{
        }
    }
    for nigateTangoVolume in willNotifyNigateTangoVolumes{
        print("nigateTangoVolume: \(nigateTangoVolume)")
    }
    return willNotifyNigateTangoVolumes
}

func transArrayDimension2to1<T>(array2D:Array<Array<T>>)->Array<T>{
    var array1D = Array<T>()
    for elementArray in array2D{
        for element in elementArray{
            array1D.append(element)
        }
    }
    return array1D
}


func deselectNigateVolume0(for oldMask:String, nigateTangoVolumes1D:Array<Int>)->String{
    var newMask = oldMask
    for (i, nigateTangoVolume) in nigateTangoVolumes1D.enumerated(){
        if nigateTangoVolume == 0{
            newMask = deselectMask(at:i, oldMask:newMask)
        }
    }
    return newMask
}

func deselectMask(at:Int, oldMask:String)->String{
    var newMask = String()
    for (i, c) in oldMask.characters.enumerated(){
        if i == at{
            newMask += "0"
        }else{
            newMask += String(c)
        }
    }
    return newMask
}


func readFile(fileName:String, extent:String)->String?{
    
    let path = defaultTextFileDirectoryPath
    
    let fileManager = FileManager.default
    var isDir : ObjCBool = false
    
    fileManager.fileExists(atPath: path, isDirectory: &isDir)
    
    if !isDir.boolValue{
        try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: true, attributes: nil)
    }
    
    let filepath1 = "\(path)/\(fileName)"+".\(extent)"
    
    //読み込み用で開くforReadingAtPath
    let filer: FileHandle? = FileHandle(forReadingAtPath: filepath1)
    if filer == nil {
        print("File open failed")
        return nil
    } else {
        filer?.seekToEndOfFile()
        let endOffset = (filer?.offsetInFile)!
        filer?.seek(toFileOffset: 0)
        let databuffer = filer?.readData(ofLength: Int(endOffset))
        // NSData to String
        let out: String = String(data:databuffer!, encoding:String.Encoding.utf8)!
        filer?.closeFile()
        return out
    }
}


func copyFile(from copiedFileName:String, to targetFileName:String, extent:String){
    if let copiedText = readFile(fileName: copiedFileName, extent: extent){
        deleteFile(fileName:targetFileName)
        writeFileWithExtent(fileName:targetFileName, text:copiedText, extent:extent)
    }
}



func updateOriginalFileListFile(originaltangoFileStatus:OriginalTangoFileStatus,extent:String){
    let originalListFileElements = getTangoArrayFromFile(fileName:ORIGINAL_LIST_FILE_NAME)
    var originalListFileList = Array<OriginalTangoFileStatus>()
    for r in 0..<originalListFileElements.count/3{
        originalListFileList.append(OriginalTangoFileStatus(fileName: originalListFileElements[3*r],prevFileName:originalListFileElements[3*r+1],notificationFlag: originalListFileElements[3*r+2]))
    }
    originalListFileList = deleteOriginalFileName(fileName:originaltangoFileStatus.fileName,from :originalListFileList)
    deleteFile(fileName:ORIGINAL_LIST_FILE_NAME)
    for originalTango in originalListFileList{
        originalTango.writeFileAdditioanally(fileName: ORIGINAL_LIST_FILE_NAME, extent: "txt")
    }
}


//let ORIGINAL_NOTIFICATION_FILE_NAME = "origialNotificationTangos"
//let PREV_ORIGINAL_NOTIFICATION_FILE_NAME = "prevOriginalNotificationTangos"

let ORIGINAL_LIST_FILE_NAME = "listNameList"
let PREV_ORIGINAL_LIST_FILE_NAME = "prevListNameList"


func writeFileWithExtent(fileName:String, text:String, extent:String){
    writeFile(fileName:fileName+"."+extent, text: text)
}
