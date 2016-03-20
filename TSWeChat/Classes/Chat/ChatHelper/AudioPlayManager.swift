//
//  AudioPlayerManager.swift
//  TSWeChat
//
//  Created by Hilen on 12/22/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

let AudioPlayInstance = AudioPlayManager.sharedInstance

class AudioPlayManager: NSObject {
    private var audioPlayer: AVAudioPlayer?
    weak var delegate: PlayAudioDelegate?
    
    class var sharedInstance : AudioPlayManager {
        struct Static {
            static let instance : AudioPlayManager = AudioPlayManager()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
        //监听听筒和扬声器
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, name: UIDeviceProximityStateDidChangeNotification, object: UIDevice.currentDevice(), handler: {
            observer, notification in
            if UIDevice.currentDevice().proximityState {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                } catch _ {}
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                } catch _ {}
            }
        })
    }
    
    func startPlaying(audioModel: ChatAudioModel) {
        if AVAudioSession.sharedInstance().category == AVAudioSessionCategoryRecord {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {}
        }
        
        guard let keyHash = audioModel.keyHash else {
            self.delegate?.audioPlayFailed()
            return
        }
        //已有 wav 文件，直接播放
        let wavFilePath = AudioFilesManager.wavPathWithName(keyHash)
        if NSFileManager.defaultManager().fileExistsAtPath(wavFilePath.path!) {
            self.playSoundWithPath(wavFilePath.path!)
            return
        }
        
        //已有 amr 文件，转换，再进行播放
        let amrFilePath = AudioFilesManager.amrPathWithName(keyHash)
        if NSFileManager.defaultManager().fileExistsAtPath(amrFilePath.path!) {
            self.convertAmrToWavAndPlaySound(audioModel)
            return
        }
        
        //都没有，就进行下载
        self.downloadAudio(audioModel)
    }
    
    // AVAudioPlayer 只能播放 wav 格式，不能播放 amr
    private func playSoundWithPath(path: String) {
        let fileData = NSData(contentsOfFile: path)
        do {
            self.audioPlayer = try AVAudioPlayer(data: fileData!)
            
            guard let player = self.audioPlayer else { return }
            
            player.delegate = self
            player.prepareToPlay()
            
            guard let delegate = self.delegate else {
                log.error("delegate is nil")
                return
            }
            
            if player.play() {
                UIDevice.currentDevice().proximityMonitoringEnabled = true
                delegate.audioPlayStart()
            } else {
                delegate.audioPlayFailed()
            }
        } catch {
            self.destroyPlayer()
        }
    }
    
    func destroyPlayer() {
        self.stopPlayer()
    }
    
    func stopPlayer() {
        if self.audioPlayer == nil {
            return
        }
        self.audioPlayer!.delegate = nil
        self.audioPlayer!.stop()
        self.audioPlayer = nil
        UIDevice.currentDevice().proximityMonitoringEnabled = false
    }
    
    // 转换，并且播放声音
    private func convertAmrToWavAndPlaySound(audioModel: ChatAudioModel) {
        if self.audioPlayer != nil {
            self.stopPlayer()
        }
        
        guard let fileName = audioModel.keyHash where fileName.length > 0 else { return}

        let amrPathString = AudioFilesManager.amrPathWithName(fileName).path!
        let wavPathString = AudioFilesManager.wavPathWithName(fileName).path!
        
        if NSFileManager.defaultManager().fileExistsAtPath(wavPathString) {
            self.playSoundWithPath(wavPathString)
        } else {
            if TSVoiceConverter.convertAmrToWav(amrPathString, wavSavePath: wavPathString) {
                self.playSoundWithPath(wavPathString)
            } else {
                if let delegate = self.delegate {
                    delegate.audioPlayFailed()
                }
            }
        }
    }
    
    /**
     使用 Alamofire 下载并且存储文件
     */
    private func downloadAudio(audioModel: ChatAudioModel) {
        let fileName = audioModel.keyHash!
        let filePath = AudioFilesManager.amrPathWithName(fileName)
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = { (temporaryURL, response)  in
            log.info("checkAndDownloadAudio response:\(response)")
            if response.statusCode == 200 {
                if NSFileManager.defaultManager().fileExistsAtPath(filePath.path!) {
                    try! NSFileManager.defaultManager().removeItemAtURL(filePath)
                }
                log.info("filePath:\(filePath)")
                return filePath
            } else {
                return temporaryURL
            }
        }
        
        Alamofire.download(.GET, audioModel.audioURL!, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    log.info("Total bytes read on main queue: \(totalBytesRead)")
                }
            }
            .response { [weak self] request, response, _, error in
                if let error = error, let delegate = self!.delegate {
                    log.error("Failed with error: \(error)")
                    delegate.audioPlayFailed()
                } else {
                    log.info("Downloaded file successfully")
                    self!.convertAmrToWavAndPlaySound(audioModel)
                }
        }
    }
}

// MARK: - @protocol AVAudioPlayerDelegate
extension AudioPlayManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        log.info("Finished playing the song")
        UIDevice.currentDevice().proximityMonitoringEnabled = false
        if flag {
            self.delegate?.audioPlayFinished()
        } else {
            self.delegate?.audioPlayFailed()
        }
        self.stopPlayer()
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        self.stopPlayer()
        self.delegate?.audioPlayFailed()
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        self.stopPlayer()
        self.delegate?.audioPlayFailed()
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer, withOptions flags: Int) {
        
    }
}











