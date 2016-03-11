//
//  TSChatViewController+Subviews.swift
//  TSWeChat
//
//  Created by Hilen on 1/7/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

private let kCustomKeyboardHeight: CGFloat = 216

// MARK: - @extension TSChatViewController
extension TSChatViewController {
    /**
     创建聊天的各种子 view
     */
    func setupSubviews(delegate: UITextViewDelegate) {
        self.setupActionBar(delegate)
        self.initListTableView()
        self.setupKeyboardInputView()
        self.setupVoiceIndicatorView()
    }
    
    private func initListTableView() {
        //点击 UITableView 隐藏键盘
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        self.listTableView.addGestureRecognizer(tap)
        tap.rx_event.subscribeNext{[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideAllKeyboard()
        }.addDisposableTo(self.disposeBag)
        
        self.view.addSubview(self.listTableView)
        
        self.listTableView.snp_makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.chatActionBarView.snp_top)
        }
    }
    
    /**
     初始化操作栏
     */
    private func setupActionBar(delegate: UITextViewDelegate) {
        self.chatActionBarView = TSChatActionBarView.fromNib()
        self.chatActionBarView.delegate = self
        self.chatActionBarView.inputTextView.delegate = delegate
        self.view.addSubview(self.chatActionBarView)
        self.chatActionBarView.snp_makeConstraints { [weak self] (make) -> Void in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.view.snp_left)
            make.right.equalTo(strongSelf.view.snp_right)
            strongSelf.actionBarPaddingBottomConstranit = make.bottom.equalTo(strongSelf.view.snp_bottom).constraint
            make.height.equalTo(50)
        }
    }
    
    /**
     初始化表情键盘，分享更多键盘
     */
    private func setupKeyboardInputView() {
        //emotionInputView init
        self.emotionInputView = TSChatEmotionInputView.fromNib()
        self.emotionInputView.delegate = self
        self.view.addSubview(self.emotionInputView)
        self.emotionInputView.snp_makeConstraints {[weak self] (make) -> Void in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.view.snp_left)
            make.right.equalTo(strongSelf.view.snp_right)
            make.top.equalTo(strongSelf.chatActionBarView.snp_bottom).offset(0)
            make.height.equalTo(kCustomKeyboardHeight)
        }
        
        //shareMoreView init
        self.shareMoreView = TSChatShareMoreView.fromNib()
        self.shareMoreView!.delegate = self
        self.view.addSubview(self.shareMoreView)
        self.shareMoreView.snp_makeConstraints {[weak self] (make) -> Void in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.view.snp_left)
            make.right.equalTo(strongSelf.view.snp_right)
            make.top.equalTo(strongSelf.chatActionBarView.snp_bottom).offset(0)
            make.height.equalTo(kCustomKeyboardHeight)
        }
    }
    
    /**
     初始化 VoiceIndicator
     */
    private func setupVoiceIndicatorView() {
        //voiceIndicatorView init
        self.voiceIndicatorView = TSChatVoiceIndicatorView.fromNib()
        self.view.addSubview(self.voiceIndicatorView)
        self.voiceIndicatorView.snp_makeConstraints {[weak self] (make) -> Void in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf.view.snp_top).offset(100)
            make.left.equalTo(strongSelf.view.snp_left)
            make.bottom.equalTo(strongSelf.view.snp_bottom).offset(-100)
            make.right.equalTo(strongSelf.view.snp_right)
        }
        self.voiceIndicatorView.hidden = true
    }
}


