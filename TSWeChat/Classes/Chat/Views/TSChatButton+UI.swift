//
//  TSChatButton+UI.swift
//  TSWeChat
//
//  Created by Hilen on 12/30/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

// MARK: - @extension TSChatButton
extension UIButton {
    /**
     控制——切换声音按钮和键盘切换的图标变化
     
     - parameter showKeyboard: 是否显示键盘
     */
    func emotionSwiftVoiceButtonUI(showKeyboard showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(TSAsset.Tool_keyboard_1.image, forState: .Normal)
            self.setImage(TSAsset.Tool_keyboard_2.image, forState: .Highlighted)
        } else {
            self.setImage(TSAsset.Tool_voice_1.image, forState: .Normal)
            self.setImage(TSAsset.Tool_voice_2.image, forState: .Highlighted)
        }
    }
    
    /**
     控制——表情按钮和键盘切换的图标变化
     
     - parameter showKeyboard: 是否显示键盘
     */
    func replaceEmotionButtonUI(showKeyboard showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(TSAsset.Tool_keyboard_1.image, forState: .Normal)
            self.setImage(TSAsset.Tool_keyboard_2.image, forState: .Highlighted)
        } else {
            self.setImage(TSAsset.Tool_emotion_1.image, forState: .Normal)
            self.setImage(TSAsset.Tool_emotion_2.image, forState: .Highlighted)
        }
    }
    
    /**
     控制--声音按钮的 UI 切换
     
     - parameter isRecording: 是否开始录音
     */
    func replaceRecordButtonUI(isRecording isRecording: Bool) {
        if isRecording {
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#C6C7CB")), forState: .Normal)
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#F3F4F8")), forState: .Highlighted)
        } else {
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#F3F4F8")), forState: .Normal)
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#C6C7CB")), forState: .Highlighted)
        }
    }
}


