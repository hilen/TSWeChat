
//
//  TSChatActionBarView.swift
//  TSWeChat
//
//  Created by Hilen on 12/16/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

let kChatActionBarOriginalHeight: CGFloat = 50      //ActionBar orginal height
let kChatActionBarTextViewMaxHeight: CGFloat = 120   //Expandable textview max height

/**
 *  表情按钮和分享按钮来控制键盘位置
 */
protocol TSChatActionBarViewDelegate: class {
    /**
     不显示任何自定义键盘，并且回调中处理键盘frame
     当唤醒的自定义键盘时候，这时候点击切换录音 button。需要隐藏掉
     */
    func chatActionBarRecordVoiceHideKeyboard()
    
    /**
     显示表情键盘，并且处理键盘高度
     */
    func chatActionBarShowEmotionKeyboard()
    
    /**
     显示分享键盘，并且处理键盘高度
     */
    func chatActionBarShowShareKeyboard()
}

class TSChatActionBarView: UIView {
    enum ChatKeyboardType: Int {
        case `default`, text, emotion, share
    }
    
    var keyboardType: ChatKeyboardType? = .default
    weak var delegate: TSChatActionBarViewDelegate?
    var inputTextViewCurrentHeight: CGFloat = kChatActionBarOriginalHeight
    
    @IBOutlet weak var inputTextView: UITextView! { didSet{
        inputTextView.font = UIFont.systemFont(ofSize: 17)
        inputTextView.layer.borderColor = UIColor.init(ts_hexString:"#DADADA").cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.scrollsToTop = false
        inputTextView.textContainerInset = UIEdgeInsets.init(top: 7, left: 5, bottom: 5, right: 5)
        inputTextView.backgroundColor = UIColor.init(ts_hexString:"#f8fefb")
        inputTextView.returnKeyType = .send
        inputTextView.isHidden = false
        inputTextView.enablesReturnKeyAutomatically = true
        inputTextView.layoutManager.allowsNonContiguousLayout = false
        inputTextView.scrollsToTop = false
        }}
    
    @IBOutlet weak var voiceButton: TSChatButton!
    @IBOutlet weak var emotionButton: TSChatButton! { didSet{
        emotionButton.showTypingKeyboard = false
        }}
    
    @IBOutlet weak var shareButton: TSChatButton! { didSet{
        shareButton.showTypingKeyboard = false
        }}
    
    @IBOutlet weak var recordButton: UIButton! { didSet{
        recordButton.setBackgroundImage(UIImage.ts_imageWithColor(UIColor.init(ts_hexString:"#F3F4F8")), for: .normal)
        recordButton.setBackgroundImage(UIImage.ts_imageWithColor(UIColor.init(ts_hexString:"#C6C7CB")), for: .highlighted)
        recordButton.layer.borderColor = UIColor.init(ts_hexString:"#C2C3C7").cgColor
        recordButton.layer.borderWidth = 0.5
        recordButton.layer.cornerRadius = 5.0
        recordButton.layer.masksToBounds = true
        recordButton.isHidden = true
        }}

    override init (frame: CGRect) {
        super.init(frame : frame)
        self.initContent()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initContent() {
        let topBorder = UIView()
        let bottomBorder = UIView()
        topBorder.backgroundColor = UIColor.init(ts_hexString:"#C2C3C7")
        bottomBorder.backgroundColor = UIColor.init(ts_hexString: "#C2C3C7")
        self.addSubview(topBorder)
        self.addSubview(bottomBorder)
        
        topBorder.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        bottomBorder.snp.makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    override func awakeFromNib() {
        initContent()
    }
    
    deinit {
        log.verbose("deinit")
    }
}

// MARK: - @extension TSChatActionBarView
//控制键盘的各种互斥事件
extension TSChatActionBarView {
    //重置所有 Button 的图片
    func resetButtonUI() {
        self.voiceButton.setImage(TSAsset.Tool_voice_1.image, for: UIControl.State())
        self.voiceButton.setImage(TSAsset.Tool_voice_2.image, for: .highlighted)
        
        self.emotionButton.setImage(TSAsset.Tool_emotion_1.image, for: UIControl.State())
        self.emotionButton.setImage(TSAsset.Tool_emotion_2.image, for: .highlighted)
        
        self.shareButton.setImage(TSAsset.Tool_share_1.image, for: UIControl.State())
        self.shareButton.setImage(TSAsset.Tool_share_2.image, for: .highlighted)
    }
    
    //当是表情键盘 或者 分享键盘的时候，此时点击文本输入框，唤醒键盘事件。
    func inputTextViewCallKeyboard() {
        self.keyboardType = .text
        self.inputTextView.isHidden = false
        
        //设置接下来按钮的动作
        self.recordButton.isHidden = true
        self.voiceButton.showTypingKeyboard = false
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }

    //显示文字输入的键盘
    func showTyingKeyboard() {
        self.keyboardType = .text
        self.inputTextView.becomeFirstResponder()
        self.inputTextView.isHidden = false
        
        //设置接下来按钮的动作
        self.recordButton.isHidden = true
        self.voiceButton.showTypingKeyboard = false
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    //显示录音
    func showRecording() {
        self.keyboardType = .default
        self.inputTextView.resignFirstResponder()
        self.inputTextView.isHidden = true
        if let delegate = self.delegate {
            delegate.chatActionBarRecordVoiceHideKeyboard()
        }
        //设置接下来按钮的动作
        self.recordButton.isHidden = false
        self.voiceButton.showTypingKeyboard = true
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
 
    /*
    显示表情键盘
    当点击唤起自定义键盘时，操作栏的输入框需要 resignFirstResponder，这时候会给键盘发送通知。
    通知在  TSChatViewController+Keyboard.swift 中需要对 actionbar 进行重置位置计算
    */
    func showEmotionKeyboard() {
        self.keyboardType = .emotion
        self.inputTextView.resignFirstResponder()
        self.inputTextView.isHidden = false
        if let delegate = self.delegate {
            delegate.chatActionBarShowEmotionKeyboard()
        }
        
        //设置接下来按钮的动作
        self.recordButton.isHidden = true
        self.emotionButton.showTypingKeyboard = true
        self.shareButton.showTypingKeyboard = false
    }
    
    //显示分享键盘
    func showShareKeyboard() {
        self.keyboardType = .share
        self.inputTextView.resignFirstResponder()
        self.inputTextView.isHidden = false
        if let delegate = self.delegate {
            delegate.chatActionBarShowShareKeyboard()
        }

        //设置接下来按钮的动作
        self.recordButton.isHidden = true
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = true
    }
    
    //取消输入
    func resignKeyboard() {
        self.keyboardType = .default
        self.inputTextView.resignFirstResponder()
        
        //设置接下来按钮的动作
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    /**
     <暂无用到>
     控制切换键盘的时候光标的颜色
     如果是切到 表情或分享 ，就是透明
     如果是输入文字，就是蓝色
     
     - parameter color: 目标颜色
     */
    fileprivate func changeTextViewCursorColor(_ color: UIColor) {
        self.inputTextView.tintColor = color
        UIView.setAnimationsEnabled(false)
        self.inputTextView.resignFirstResponder()
        self.inputTextView.becomeFirstResponder()
        UIView.setAnimationsEnabled(true)
    }
}




