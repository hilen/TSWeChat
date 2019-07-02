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
    func emotionSwiftVoiceButtonUI(showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(TSAsset.Tool_keyboard_1.image, for: UIControl.State())
            self.setImage(TSAsset.Tool_keyboard_2.image, for: .highlighted)
        } else {
            self.setImage(TSAsset.Tool_voice_1.image, for: UIControl.State())
            self.setImage(TSAsset.Tool_voice_2.image, for: .highlighted)
        }
    }
    
    /**
     控制——表情按钮和键盘切换的图标变化
     
     - parameter showKeyboard: 是否显示键盘
     */
    func replaceEmotionButtonUI(showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(TSAsset.Tool_keyboard_1.image, for: UIControl.State())
            self.setImage(TSAsset.Tool_keyboard_2.image, for: .highlighted)
        } else {
            self.setImage(TSAsset.Tool_emotion_1.image, for: UIControl.State())
            self.setImage(TSAsset.Tool_emotion_2.image, for: .highlighted)
        }
    }
    
    /**
     控制--声音按钮的 UI 切换
     
     - parameter isRecording: 是否开始录音
     */
    func replaceRecordButtonUI(isRecording: Bool) {
        if isRecording {
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#C6C7CB"), forState: .normal)
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#F3F4F8"), forState: .highlighted)
        } else {
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#F3F4F8"), forState: .normal)
            self.ts_setBackgroundColor(UIColor.init(ts_hexString: "#C6C7CB"), forState: .highlighted)
        }
    }
}


