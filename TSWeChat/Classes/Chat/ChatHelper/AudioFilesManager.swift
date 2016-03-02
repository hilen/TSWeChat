//
//  AudioFilesManager.swift
//  TSWeChat
//
//  Created by Hilen on 2/19/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

// 管理录音文件 NSFileManager
import Foundation

private let kAmrRecordFolder = "ChatAudioAmrRecord"   //存 amr 的文件目录名
private let kWavRecordFolder = "ChatAudioWavRecord"  //存 wav 的文件目录名

class AudioFilesManager {
    /**
     返回 amr 的完整路径
     
     - parameter fileName: 文件名字，不包含后缀

     - returns: 返回路径
     */
    class func amrPathWithName(fileName: String) -> NSURL {
        let filePath = self.amrFilesFolder.URLByAppendingPathComponent("\(fileName).\(kAudioFileTypeAmr)")
        return filePath
    }
    
    
    /**
     返回 wav 的完整路径
     
     - parameter fileName: 文件名字，不包含后缀
     
     - returns: 返回路径
     */
    class func wavPathWithName(fileName: String) -> NSURL {
        let filePath = self.wavFilesFolder.URLByAppendingPathComponent("\(fileName).\(kAudioFileTypeWav)")
        return filePath
    }
    
    
    /**
     修改文件名称
     
     - parameter originPath:      原路径
     - parameter destinationPath: 目标路径
     
     - returns: 目标路径
     */
    class func renameFile(originPath: NSURL, destinationPath: NSURL) -> Bool {
        do {
            try NSFileManager.defaultManager().moveItemAtPath(originPath.path!, toPath: destinationPath.path!)
            return true
        } catch let error as NSError {
            log.error("error:\(error)")
            return false
        }
    }
    
    /**
     创建录音的文件夹
     */
    class private func createAudioFolder(folderName :String) -> NSURL {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
        let folder = documentsDirectory.URLByAppendingPathComponent(folderName)
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(folder.absoluteString) {
            do {
                try fileManager.createDirectoryAtPath(folder.path!, withIntermediateDirectories: true, attributes: nil)
                return folder
            } catch let error as NSError {
                log.error("error:\(error)")
            }
        }
        return folder
    }
    
    /**
     创建录音的文件夹, amr 格式
     */
    private class var amrFilesFolder: NSURL {
        get { return self.createAudioFolder(kAmrRecordFolder)}
    }
    
    /**
     创建录音的文件夹, wav 格式
     */
    private class var wavFilesFolder: NSURL {
        get { return self.createAudioFolder(kWavRecordFolder)}
    }
    
    class func deleteAllRecordingFiles() {
        self.deleteFilesWithPath(self.amrFilesFolder.path!)
        self.deleteFilesWithPath(self.wavFilesFolder.path!)
    }
    
    /**
     删除文件
     
     - parameter path: 路径
     */
    private class func deleteFilesWithPath(path: String) {
        let fileManager = NSFileManager.defaultManager()
        do {
            let files = try fileManager.contentsOfDirectoryAtPath(path)
            var recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix(kAudioFileTypeWav)
            })
            for var i = 0; i < recordings.count; i++ {
                let path = path + "/" + recordings[i]
                log.info("removing \(path)")
                do {
                    try fileManager.removeItemAtPath(path)
                } catch let error as NSError {
                    log.info("could not remove \(path)")
                    log.info(error.localizedDescription)
                }
            }
        } catch let error as NSError {
            log.info("could not get contents of directory at \(path)")
            log.info(error.localizedDescription)
        }
    }
}


