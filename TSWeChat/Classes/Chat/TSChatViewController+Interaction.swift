//
//  TSChatViewController+Interaction.swift
//  TSWeChat
//
//  Created by Hilen on 12/31/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import Photos
import MobileCoreServices

// MARK: - @protocol ChatShareMoreViewDelegate
// 分享更多里面的 Button 交互
extension TSChatViewController: ChatShareMoreViewDelegate {
   
    //选择打开相册
    func chatShareMoreViewPhotoTaped() {
        self.ts_presentImagePickerController(
            maxNumberOfSelections: 1,
            select: { (asset: PHAsset) -> Void in
                print("Selected: \(asset)")
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: {[weak self] (assets: [PHAsset]) -> Void in
                print("Finish: \(assets.get(index: 0))")
                guard let strongSelf = self else { return }
                if let image = assets.get(index: 0).getUIImage() {
                    strongSelf.resizeAndSendImage(image)
                }
            }, completion: { () -> Void in
                print("completion")
        })
    }
    
    //选择打开相机
    func chatShareMoreViewCameraTaped() {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == .notDetermined {
            self.checkCameraPermission()
        } else if authStatus == .restricted || authStatus == .denied {
            TSAlertView_show("无法访问您的相机", message: "请到设置 -> 隐私 -> 相机 ，打开访问权限" )
        } else if authStatus == .authorized {
            self.openCamera()
        }
    }
    
    
    func checkCameraPermission () {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {granted in
            if !granted {
                TSAlertView_show("无法访问您的相机", message: "请到设置 -> 隐私 -> 相机 ，打开访问权限" )
            }
        })
    }
    
    func openCamera() {
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    //处理图片，并且发送图片消息
    func resizeAndSendImage(_ theImage: UIImage) {
        let originalImage = UIImage.fixImageOrientation(theImage)
        let storeKey = "send_image"+String(format: "%f", Date.milliseconds)
        let thumbSize = ChatConfig.getThumbImageSize(originalImage.size)
        
        //获取缩略图失败 ，抛出异常：发送失败
        guard let thumbNail = originalImage.ts_resize(thumbSize) else { return }
        ImageFilesManager.storeImage(thumbNail, key: storeKey, completionHandler: { [weak self] in
            guard let strongSelf = self else { return }
            //发送图片消息
            let sendImageModel = ChatImageModel()
            sendImageModel.imageHeight = originalImage.size.height
            sendImageModel.imageWidth = originalImage.size.width
            sendImageModel.localStoreName = storeKey
            strongSelf.chatSendImage(sendImageModel)
            
            /**
            *  异步上传原图, 然后上传成功后，把 model 值改掉
            *  但因为还没有找到上传的 API，所以这个函数会返回错误  T.T
            * //TODO: 原图尺寸略大，需要剪裁
            */
            HttpManager.uploadSingleImage(originalImage, success: {model in
                //修改 sendImageModel 的值
                sendImageModel.imageHeight = model.originalHeight
                sendImageModel.imageWidth = model.originalWidth
                sendImageModel.thumbURL = model.thumbURL
                sendImageModel.originalURL = model.originalURL
                sendImageModel.imageId = String(describing: model.imageId)
                
                //修改缩略图的名称
                let tempStorePath = URL(string:ImageFilesManager.cachePathForKey(storeKey)!)
                let targetStorePath = URL(string:ImageFilesManager.cachePathForKey(sendImageModel.thumbURL!)!)
                ImageFilesManager.renameFile(tempStorePath!, destinationPath: targetStorePath!)
            }, failure: {
                    
            })
        })

    }
}

// MARK: - @protocol UIImagePickerControllerDelegate
// 拍照完成，进行上传图片，并且发送的请求
extension TSChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType = info[UIImagePickerControllerMediaType] as? NSString else { return }
        if mediaType.isEqual(to: kUTTypeImage as String) {
            guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            if picker.sourceType == .camera {
                self.resizeAndSendImage(image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - @protocol RecordAudioDelegate
// 语音录制完毕后
extension TSChatViewController: RecordAudioDelegate {
    func audioRecordUpdateMetra(_ metra: Float) {
        self.voiceIndicatorView.updateMetersValue(metra)
    }
    
    func audioRecordTooShort() {
        self.voiceIndicatorView.messageTooShort()
    }
    
    func audioRecordFinish(_ uploadAmrData: Data, recordTime: Float, fileHash: String) {
        self.voiceIndicatorView.endRecord()
        
        //发送本地音频
        let audioModel = ChatAudioModel()
        audioModel.keyHash = fileHash
        audioModel.audioURL = ""
        audioModel.duration = recordTime
        self.chatSendVoice(audioModel)

        /**
        *  异步上传音频文件, 然后上传成功后，把 model 值改掉
        *  因为还没有上传的 API，所以这个函数会返回错误  T.T
        */
        HttpManager.uploadAudio(uploadAmrData, recordTime: String(recordTime), success: {model in
            audioModel.keyHash = model.keyHash
            audioModel.audioURL = model.audioURL
            audioModel.duration = recordTime
        }, failure: {
        
        })
    }
    
    func audioRecordFailed() {
        TSAlertView_show("录音失败，请重试")
    }
    
    func audioRecordCanceled() {
        
    }
}

// MARK: - @protocol PlayAudioDelegate
extension TSChatViewController: PlayAudioDelegate {
    /**
     播放完毕
     */
    func audioPlayStart() {
    
    }
    
    /**
     播放完毕
     */
    func audioPlayFinished() {
        self.currentVoiceCell.resetVoiceAnimation()
    }
    
    /**
     播放失败
     */
    func audioPlayFailed() {
        self.currentVoiceCell.resetVoiceAnimation()
    }
    
    
    /**
     播放被中断
     */
    func audioPlayInterruption() {
        self.currentVoiceCell.resetVoiceAnimation()
    }
}


// MARK: - @protocol ChatEmotionInputViewDelegate
// 表情点击完毕后
extension TSChatViewController: ChatEmotionInputViewDelegate {
    //点击表情
    func chatEmoticonInputViewDidTapCell(_ cell: TSChatEmotionCell) {
        var string = self.chatActionBarView.inputTextView.text
        string = string! + cell.emotionModel!.text
        self.chatActionBarView.inputTextView.text = string
    }
    
    //点击撤退删除
    func chatEmoticonInputViewDidTapBackspace(_ cell: TSChatEmotionCell) {
        self.chatActionBarView.inputTextView.deleteBackward()
    }
    
    //点击发送文字，包含表情
    func chatEmoticonInputViewDidTapSend() {
        self.chatSendText()
    }
}


// MARK: - @protocol UITextViewDelegate
extension TSChatViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //点击发送文字，包含表情
            self.chatSendText()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textView.contentSize.height
        guard contentHeight < kChatActionBarTextViewMaxHeight else {
            return
        }

        self.chatActionBarView.inputTextViewCurrentHeight = contentHeight + 17
        self.controlExpandableInputView(showExpandable: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //设置键盘类型，响应 UIKeyboardWillShowNotification 事件
        self.chatActionBarView.inputTextViewCallKeyboard()
        
        //使 UITextView 滚动到末尾的区域
        UIView.setAnimationsEnabled(false)
        let range = NSMakeRange(textView.text.length - 1, 1)
        textView.scrollRangeToVisible(range)
        UIView.setAnimationsEnabled(true)
        return true
    }
}


// MARK: - @protocol TSChatCellDelegate
extension TSChatViewController: TSChatCellDelegate {
    /**
     点击了 cell 本身
     */
    func cellDidTaped(_ cell: TSChatBaseCell) {
        
    }
    
    /**
     点击了 cell 的头像
     */
    func cellDidTapedAvatarImage(_ cell: TSChatBaseCell) {
        TSAlertView_show("点击了头像")
    }
    
    /**
     点击了 cell 的图片
     */
    func cellDidTapedImageView(_ cell: TSChatBaseCell) {
        TSAlertView_show("点击了图片")
    }
    
    /**
     点击了 cell 中文字的 URL
     */
    func cellDidTapedLink(_ cell: TSChatBaseCell, linkString: String) {
        let viewController = TSWebViewController(URLString: linkString)
        self.ts_pushAndHideTabbar(viewController)
    }
    
    /**
     点击了 cell 中文字的 电话
     */
    func cellDidTapedPhone(_ cell: TSChatBaseCell, phoneString: String) {
        TSAlertView_show("点击了电话")
    }
    
    /**
     点击了声音 cell 的播放 button
     */
    func cellDidTapedVoiceButton(_ cell: TSChatVoiceCell, isPlayingVoice: Bool) {
        //在切换选中的语音 cell 之前把之前的动画停止掉
        if self.currentVoiceCell != nil && self.currentVoiceCell != cell {
            self.currentVoiceCell.resetVoiceAnimation()
        }
        
        if isPlayingVoice {
            self.currentVoiceCell = cell
            guard let audioModel = cell.model!.audioModel else {
                AudioPlayInstance.stopPlayer()
                return
            }
            AudioPlayInstance.startPlaying(audioModel)
        } else {
            AudioPlayInstance.stopPlayer()
        }
    }
}




