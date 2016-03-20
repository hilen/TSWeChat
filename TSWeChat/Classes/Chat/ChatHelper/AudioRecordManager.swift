//
//  AudioRecordManager.swift
//  TSWeChat
//
//  Created by Hilen on 12/21/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import AVFoundation

//private let soundPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
let kAudioFileTypeWav = "wav"
let kAudioFileTypeAmr = "amr"
let AudioRecordInstance = AudioRecordManager.sharedInstance
private let TempWavRecordPath = AudioFilesManager.wavPathWithName("wav_temp_record") //wav 临时路径
private let TempAmrFilePath = AudioFilesManager.amrPathWithName("amr_temp_record")   //amr 临时路径

class AudioRecordManager: NSObject {
    var recorder: AVAudioRecorder!
    var operationQueue: NSOperationQueue!
    weak var delegate: RecordAudioDelegate?
    
    private var startTime: CFTimeInterval! //录音开始时间
    private var endTimer: CFTimeInterval! //录音结束时间
    private var audioTimeInterval: NSNumber!
    private var isFinishRecord: Bool = true
    private var isCancelRecord: Bool = false
    
    class var sharedInstance : AudioRecordManager {
        struct Static {
            static let instance : AudioRecordManager = AudioRecordManager()
        }
        return Static.instance
    }
    
    private override init() {
        self.operationQueue = NSOperationQueue()
        super.init()
    }
    
    /**
     获取录音权限并初始化录音
     */
    func checkPermissionAndSetupRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DuckOthers)
            do {
                try session.setActive(true)
                session.requestRecordPermission{allowed in
                    if !allowed {
                        TSAlertView_show("无法访问您的麦克风", message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限")
                    }
                }
            } catch let error as NSError {
                log.error("Could not activate the audio session:\(error)")
                TSAlertView_show("无法访问您的麦克风", message: error.localizedFailureReason!)
            }
        } catch let error as NSError {
            log.error("An error occurred in setting the audio ,session category. Error = \(error)")
            TSAlertView_show("无法访问您的麦克风", message: error.localizedFailureReason!)
        }
    }
    
    /**
     监听耳机插入的动作
     */
    func checkHeadphones() {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    log.info("headphones are plugged in")
                    break
                } else {
                    log.info("headphones are unplugged")
                }
            }
        } else {
            log.info("checking headphones requires a connection to a device")
        }
    }
    
    /**
     开始录音
     */
    func startRecord() {
        self.isCancelRecord = false
        self.startTime = CACurrentMediaTime()
//        self.tempAudioFileURL = AudioFilesManager.wavPathWithName(kTempWavRecordName)
        do {
            //基础参数
            let recordSettings:[String : AnyObject] = [
                //线性采样位数  8、16、24、32
                AVLinearPCMBitDepthKey: NSNumber(int: 16),
                //设置录音格式  AVFormatIDKey == kAudioFormatLinearPCM
                AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM),
                //录音通道数  1 或 2
                AVNumberOfChannelsKey: NSNumber(int: 1),
                //设置录音采样率(Hz) 如：AVSampleRateKey == 8000/44100/96000（影响音频的质量）
                AVSampleRateKey: NSNumber(float: 8000.0),
            ]

            self.recorder = try AVAudioRecorder(URL: TempWavRecordPath, settings: recordSettings)
            self.recorder.delegate = self
            self.recorder.meteringEnabled = true
            self.recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            self.recorder = nil
            log.error("error localizedDescription:\(error.localizedDescription)")
            TSAlertView_show("初始化录音功能失败", message: error.localizedDescription)
        }
        self.performSelector("readyStartRecord", withObject: self, afterDelay: 0.0)
    }
    
    /**
     准备录音
     */
    func readyStartRecord() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch let error as NSError  {
            log.error("setActive fail:\(error)")
            TSAlertView_show("无法访问您的麦克风", message: error.localizedDescription)
            return
        }
        
        do {
            try audioSession.setActive(true)
        } catch let error as NSError {
            log.error("setActive fail:\(error)")
            TSAlertView_show("无法访问您的麦克风", message: error.localizedDescription)
            return
        }
        self.recorder.record()
        let operation = NSBlockOperation()
        operation.addExecutionBlock(updateMeters)
        self.operationQueue.addOperation(operation)
    }
    
    /**
     更新进度
     */
    func updateMeters() {
        guard let recorder = self.recorder else { return }
        
        repeat {
            recorder.updateMeters()
            self.audioTimeInterval = NSNumber(float: NSNumber(double: recorder.currentTime).floatValue)
            let averagePower = recorder.averagePowerForChannel(0)
            let lowPassResults = pow(10, (0.05 * averagePower)) * 10
            dispatch_async_safely_to_main_queue({ () -> () in
                self.delegate?.audioRecordUpdateMetra(lowPassResults)
            })
            //如果大于 60 ,停止录音
            if self.audioTimeInterval.intValue > 60 {
                self.stopRecord()
            }
        
            NSThread.sleepForTimeInterval(0.05)
        } while(recorder.recording)
    }
    
    /**
     停止录音
     */
    func stopRecord() {
        self.isFinishRecord = true
        self.isCancelRecord = false
        self.endTimer = CACurrentMediaTime()
        if (self.endTimer - self.startTime) < 0.5 {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "readyStartRecord", object: self)
            dispatch_async_safely_to_main_queue({ () -> () in
                self.delegate?.audioRecordTooShort()
            })
        } else {
            self.audioTimeInterval = NSNumber(int: NSNumber(double: self.recorder.currentTime).intValue)
            if self.audioTimeInterval.intValue < 1 {
                self.performSelector("readyStopRecord", withObject: self, afterDelay: 0.4)
            } else {
                self.readyStopRecord()
            }
        }
        self.operationQueue.cancelAllOperations()
    }
    
    /**
     取消录音
     */
    func cancelRrcord() {
        self.isCancelRecord = true
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "readyStartRecord", object: self)
        self.isFinishRecord = false
        self.recorder.stop()
        self.recorder.deleteRecording()
        self.recorder = nil
        self.delegate?.audioRecordCanceled()
    }
    
    func readyStopRecord() {
        self.recorder.stop()
        self.recorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, withOptions: .NotifyOthersOnDeactivation)
        } catch let error as NSError {
            log.error("error:\(error)")
        }
    }
    
    /**
     删除录音文件
     */
    func deleteRecordFiles() {
        AudioFilesManager.deleteAllRecordingFiles()
    }
}


// MARK: - @protocol AVAudioRecorderDelegate
extension AudioRecordManager : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag && self.isFinishRecord {
            //转换 amr 音频文件
            if TSVoiceConverter.convertWavToAmr(TempWavRecordPath.path!, amrSavePath: TempAmrFilePath.path!) {
                //获取 amr 文件的 NSData, 改名字使用
                guard let amrAudioData = NSData(contentsOfURL: TempAmrFilePath) else {
                    self.delegate?.audioRecordFailed()
                    return
                }
                let fileName = amrAudioData.MD5String
                let amrDestinationURL = AudioFilesManager.amrPathWithName(fileName)
                log.warning("amr destination URL:\(amrDestinationURL)")
                AudioFilesManager.renameFile(TempAmrFilePath, destinationPath: amrDestinationURL)
                
                //缓存：将录音 temp 文件改名为 amr 文件 NSData 的 md5 值
                let wavDestinationURL = AudioFilesManager.wavPathWithName(fileName)
                AudioFilesManager.renameFile(TempWavRecordPath, destinationPath: wavDestinationURL)
                
                self.delegate?.audioRecordFinish(amrAudioData, recordTime: self.audioTimeInterval.floatValue, fileHash: fileName)
            } else {
                self.delegate?.audioRecordFailed()
            }
        } else {
            //如果不是取消录音，再进行回调 failed 方法
            if !self.isCancelRecord {
                self.delegate?.audioRecordFailed()
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        if let e = error {
            log.error("\(e.localizedDescription)")
            self.delegate?.audioRecordFailed()
        }
    }
}





