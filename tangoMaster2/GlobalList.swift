//
//  HeaderList.swift
//  tangoMaster
//
//  Created by Tetsu on 2016/10/03.
//  Copyright © 2016年 Tetsu. All rights reserved.
//

import Foundation

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
}

let arrayCategory = ["大学受験初級","大学受験中級","大学受験上級","Toeic"]

let testWrongTangoArray = [["wrongTest0","wrongTest1"],["wrongTest2","wrongTest3"]]

//ファイル名　クリア後のchapter numberを書き込むsetNewChapterに対応
let checkFileNamesArray = ["checkDS","checkDT","checkDJ","checkToeic"]


//テストは2*2で行う
//最終的には〇〇fileNamesを使う
let testFileNamesArray = [["tangoTest0","tangoTest1"],["tangoTest2","tangoTest3"]]
let testNigateFileNamesArray =  [["nbeg1-1","nbeg1-2"],["nigateTest2","nigateTest3"]]

let sectionList:Array<String> = ["大学受験初級1000","大学受験中級800","大学受験上級500","Toeic830点レベル"]

//sections = levels * chapters * chapterNumbers
let beginnerFileNames = ["beg1-1","beg1-2","beg2-1","beg2-2","beg3-1","beg3-2"]
let intermidFileNames = ["mid1-1","mid1-2","mid2-1","mid2-2"]
let beginnerChapterNames = ["chapter1","chapter2","chapter3"]
let intermidChapterNames = ["chapter1","chapter2"]


func readFileGetWordArray(_ fileName:String,extent:String)->Array<String>{
    var wordArray = Array<String>()
    if let filePath = Bundle.main.path(forResource: fileName, ofType: extent) {
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


func fileWrite(filew:FileHandle?,filepath:String,fileObject:String){
    var filew2 = filew
    if(filew2 == nil){
        filew2 = FileHandle(forWritingAtPath: filepath)
    }
    //offset = ファイル内のポインタの位置を示す
    if filew2 == nil {
        print("File open failed")
    } else {
        //print("Offset = \(filew2?.offsetInFile)")
        let data = (fileObject as NSString).data(using: String.Encoding.utf8.rawValue)
        filew2?.seekToEndOfFile()
        filew2?.write(data!)
        //print("Offset = \(filew2?.offsetInFile)")
        filew2?.closeFile()
    }
    
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

func getWordArrayFromString(str:String)->Array<String>{
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


func getfile(fileName:String)->Array<String>{
    
    var nigateArray = Array<String>()
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
    
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
        nigateArray = getWordArrayFromString(str:out)
        filer?.closeFile()
    }
    return nigateArray
}

func deleteFile(fileName:String){
    print("fileを削除します")
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
    
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
func fileSet(fileName:String,eng:String,jpn:String,imgPath:String,engPhrase:String,jpnPhrase:String,nigateFlag:String,partsOfSpeech:String,soundPath:String){
    //get current word list
    
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
    
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
            fileWrite(filew: filew, filepath:filepath1,fileObject:fileObject)
        }
        filer?.closeFile()
    }
}

func setFileOfProblemVolume(fileName:String,problemVolume:Int){
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
    
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
    let filew: FileHandle? = FileHandle(forWritingAtPath: filepath1)
    
    // 保存処理 初回のみfilew == nilなので、初回のみ新規につくられる
    if(filew == nil){
        try! fileObject.write(toFile: "\(path)/\(fileName+".txt")", atomically: true, encoding: String.Encoding.utf8)
    }else{
        fileWrite(filew: filew, filepath:filepath1,fileObject:fileObject)
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

//あるchapterのファイルから苦手な単語を探し。EightTangoの配列として返す？
func getNigateTangoArray(fileName:String)->Array<CardTango>{
    let wholeArray = getfile(fileName: fileName)
    var nigateArray = Array<CardTango>()
    for r in 0..<nigateArray.count/8{
        //print(wholeArray[8*r+5])
        if(wholeArray[8*r+5] == "1"){
            nigateArray.append(CardTango(eng: wholeArray[8*r], jpn: wholeArray[8*r+1], soundPath: wholeArray[8*r+7]))
        }
    }
    return nigateArray
}

func getWrongTangoVolume(fileName:String)->Int{
    let wholeArray = getfile(fileName: fileName)
    var wrongVolume:Int = 0
    for _ in 0..<wholeArray.count/8{
        //print(wholeArray[8*r+5])
        wrongVolume += 1
    }
    return wrongVolume
}


//あるチャプターのファイルの中身を検索し、苦手な単語の数を返す。forなどでイテレータfilenameを回し、それを各chapterの苦手数の配列などに順に格納するなどして利用する。
func getNigateTangoVolume(fileName:String)->Int{
    print("getNigateTangoVolume")
    let nigateArray = getfile(fileName: fileName)
    var nigateCount = 0
    for r in 0..<nigateArray.count/8{
        print(nigateArray[8*r+5])
        if(nigateArray[8*r+5] == "1"){
            nigateCount += 1
        }
    }
    return nigateCount
}


func getNewChapter(fileName:String,chapterVolume:Int)->Int{
    print("getNewChapter")
    var chapterNumber = 0
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
    
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
            }else if s == "1" && chapterNumber == chapterVolume-1{
                break //全てクリア済みの時は、存在しない次のchapternumberまでいかないように、ここで食い止める。
            }
            chapterNumber += 1//0章がクリアされた時、1になる。つまり、newchapternumberと基本は一致する。
        }
        filer?.closeFile()
    }
    print("new chapter number is \(chapterNumber)")
    return chapterNumber
}


func writeSixFile(fileName:String,eng: String, jpn: String, engPhrase: String, jpnPhrase: String,nigateFlag:String,partOfSpeech:String){
    //"/Documentを調べたい場合 "/folder_name" -> ""
    //"/Document/imagesの場合 "/folder_name" -> "/images"
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/text"
    
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
            fileWrite(filew: filew, filepath:filepath1,fileObject:fileObject)
        }
        filer?.closeFile()
    }
}




