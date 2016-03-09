
//
//  TSChatActionBarView.swift
//  TSWeChat
//
//  Created by Hilen on 12/16/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

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
        case Default, Text, Emotion, Share
    }
    
    var keyboardType: ChatKeyboardType? = .Default
    weak var delegate: TSChatActionBarViewDelegate?
    
    @IBOutlet weak var inputTextView: UITextView! { didSet{
        inputTextView.font = UIFont.systemFontOfSize(17)
        inputTextView.layer.borderColor = UIColor(rgba: "#DADADA").CGColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.scrollsToTop = false
        inputTextView.textContainerInset = UIEdgeInsetsMake(7, 5, 5, 5)
        inputTextView.backgroundColor = UIColor(rgba: "#f8fefb")
        inputTextView.returnKeyType = .Send
        inputTextView.hidden = false
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
        recordButton.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#F3F4F8")), forState: .Normal)
        recordButton.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#C6C7CB")), forState: .Highlighted)
        recordButton.layer.borderColor = UIColor(rgba: "#C2C3C7").CGColor
        recordButton.layer.borderWidth = 0.5
        recordButton.layer.cornerRadius = 5.0
        recordButton.layer.masksToBounds = true
        recordButton.hidden = true
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
    }
    
    /**
     画两根线, 也可以贴两个 UIView , 哈哈
     */
    override func drawRect(rect: CGRect) {
        let scale = self.window!.screen.scale
        let width = 1 / scale
        let centerChoice: CGFloat = scale % 2 == 0 ? 4 : 2
        let offset = scale / centerChoice * width
        let context = UIGraphicsGetCurrentContext()

        CGContextSetLineWidth(context, width)
        CGContextSetStrokeColorWithColor(context, UIColor(rgba: "#C2C3C7").CGColor)
        
        let x1: CGFloat = 0 + offset
        let y1: CGFloat = 0 + offset
        let x2: CGFloat = UIScreen.width + offset
        let y2: CGFloat = 0 + offset
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, x1, y1)
        CGContextAddLineToPoint(context, x2, y2)
        
        let x3: CGFloat = 0 + offset
        let y3: CGFloat = 49.5 + offset
        let x4: CGFloat = UIScreen.width + offset
        let y4: CGFloat = 49.5 + offset
        
        CGContextMoveToPoint(context, x3, y3)
        CGContextAddLineToPoint(context, x4, y4)
        CGContextStrokePath(context)
    }
    
    override func awakeFromNib() {

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
        self.voiceButton.setImage(TSAsset.Tool_voice_1.image, forState: .Normal)
        self.voiceButton.setImage(TSAsset.Tool_voice_2.image, forState: .Highlighted)
        
        self.emotionButton.setImage(TSAsset.Tool_emotion_1.image, forState: .Normal)
        self.emotionButton.setImage(TSAsset.Tool_emotion_2.image, forState: .Highlighted)
        
        self.shareButton.setImage(TSAsset.Tool_share_1.image, forState: .Normal)
        self.shareButton.setImage(TSAsset.Tool_share_2.image, forState: .Highlighted)
    }
    
    //当是表情键盘 或者 分享键盘的时候，此时点击文本输入框，唤醒键盘事件。
    func inputTextViewCallKeyboard() {
        self.keyboardType = .Text
        self.inputTextView.hidden = false
        
        //设置接下来按钮的动作
        self.recordButton.hidden = true
        self.voiceButton.showTypingKeyboard = false
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }

    //显示文字输入的键盘
    func showTyingKeyboard() {
        self.keyboardType = .Text
        self.inputTextView.becomeFirstResponder()
        self.inputTextView.hidden = false
        
        //设置接下来按钮的动作
        self.recordButton.hidden = true
        self.voiceButton.showTypingKeyboard = false
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = false
    }
    
    //显示录音
    func showRecording() {
        self.keyboardType = .Default
        self.inputTextView.resignFirstResponder()
        self.inputTextView.hidden = true
        if let delegate = self.delegate {
            delegate.chatActionBarRecordVoiceHideKeyboard()
        }
        //设置接下来按钮的动作
        self.recordButton.hidden = false
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
        self.keyboardType = .Emotion
        self.inputTextView.resignFirstResponder()
        self.inputTextView.hidden = false
        if let delegate = self.delegate {
            delegate.chatActionBarShowEmotionKeyboard()
        }
        
        //设置接下来按钮的动作
        self.recordButton.hidden = true
        self.emotionButton.showTypingKeyboard = true
        self.shareButton.showTypingKeyboard = false
    }
    
    //显示分享键盘
    func showShareKeyboard() {
        self.keyboardType = .Share
        self.inputTextView.resignFirstResponder()
        self.inputTextView.hidden = false
        if let delegate = self.delegate {
            delegate.chatActionBarShowShareKeyboard()
        }

        //设置接下来按钮的动作
        self.recordButton.hidden = true
        self.emotionButton.showTypingKeyboard = false
        self.shareButton.showTypingKeyboard = true
    }
    
    //取消输入
    func resignKeyboard() {
        self.keyboardType = .Default
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
    private func changeTextViewCursorColor(color: UIColor) {
        self.inputTextView.tintColor = color
        UIView.setAnimationsEnabled(false)
        self.inputTextView.resignFirstResponder()
        self.inputTextView.becomeFirstResponder()
        UIView.setAnimationsEnabled(true)
    }
}




