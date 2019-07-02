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
    @discardableResult
    class func amrPathWithName(_ fileName: String) -> URL {
        let filePath = self.amrFilesFolder.appendingPathComponent("\(fileName).\(kAudioFileTypeAmr)")
        return filePath
    }
    
    
    /**
     返回 wav 的完整路径
     
     - parameter fileName: 文件名字，不包含后缀
     
     - returns: 返回路径
     */
    @discardableResult
    class func wavPathWithName(_ fileName: String) -> URL {
        let filePath = self.wavFilesFolder.appendingPathComponent("\(fileName).\(kAudioFileTypeWav)")
        return filePath
    }
    
    
    /**
     修改文件名称
     
     - parameter originPath:      原路径
     - parameter destinationPath: 目标路径
     
     - returns: 目标路径
     */
    @discardableResult
    class func renameFile(_ originPath: URL, destinationPath: URL) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: originPath.path, toPath: destinationPath.path)
            return true
        } catch let error as NSError {
            log.error("error:\(error)")
            return false
        }
    }
    
    /**
     创建录音的文件夹
     */
    @discardableResult
    class fileprivate func createAudioFolder(_ folderName :String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let folder = documentsDirectory.appendingPathComponent(folderName)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folder.absoluteString) {
            do {
                try fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
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
    fileprivate class var amrFilesFolder: URL {
        get { return self.createAudioFolder(kAmrRecordFolder)}
    }
    
    /**
     创建录音的文件夹, wav 格式
     */
    fileprivate class var wavFilesFolder: URL {
        get { return self.createAudioFolder(kWavRecordFolder)}
    }
    
    class func deleteAllRecordingFiles() {
        self.deleteFilesWithPath(self.amrFilesFolder.path)
        self.deleteFilesWithPath(self.wavFilesFolder.path)
    }
    
    /**
     删除文件
     
     - parameter path: 路径
     */
    fileprivate class func deleteFilesWithPath(_ path: String) {
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            var recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix(kAudioFileTypeWav)
            })
            for i in 0 ..< recordings.count {
                let path = path + "/" + recordings[i]
                log.info("removing \(path)")
                do {
                    try fileManager.removeItem(atPath: path)
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


