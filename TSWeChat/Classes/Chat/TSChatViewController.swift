//
//  TSChatViewController.swift
//  TSWeChat
//
//  Created by Hilen on 12/10/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import BSImagePicker
import Photos
import SwiftyJSON

/*
*   聊天详情的 ViewController
*/
private let kChatLoadMoreOffset: CGFloat = 30

final class TSChatViewController: UIViewController {
    var messageModel: MessageModel?
    @IBOutlet weak var tableViewMarginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var refreshView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var chatActionBarView: TSChatActionBarView!  //action bar
    var actionBarPaddingBottomConstranit: Constraint? //action bar 的 bottom Constraint
    var keyboardHeightConstraint: NSLayoutConstraint?  //键盘高度的 Constraint
    var emotionInputView: TSChatEmotionInputView! //表情键盘
    var shareMoreView: TSChatShareMoreView!    //分享键盘
    var voiceIndicatorView: TSChatVoiceIndicatorView! //声音的显示 View
    let disposeBag = DisposeBag()
    var imagePicker: UIImagePickerController!   //照相机
    var itemDataSouce = [ChatModel]()
    var isReloading: Bool = false               //UITableView 是否正在加载数据, 如果是，把当前发送的消息缓存起来后再进行发送
    var currentVoiceCell: TSChatVoiceCell!     //现在正在播放的声音的 cell
    var isEndRefreshing: Bool = true            // 是否结束了下拉加载更多
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.messageModel!.nickname!
        self.view.backgroundColor = UIColor(colorNamed: TSColor.viewBackgroundColor)
        self.navigationController!.interactivePopGestureRecognizer!.enabled = true

        //TableView init
        self.listTableView.registerNib(TSChatTextCell.NibObject(), forCellReuseIdentifier: TSChatTextCell.identifier)
        self.listTableView.registerNib(TSChatImageCell.NibObject(), forCellReuseIdentifier: TSChatImageCell.identifier)
        self.listTableView.registerNib(TSChatVoiceCell.NibObject(), forCellReuseIdentifier: TSChatVoiceCell.identifier)
        self.listTableView.registerNib(TSChatSystemCell.NibObject(), forCellReuseIdentifier: TSChatSystemCell.identifier)
        self.listTableView.registerNib(TSChatTimeCell.NibObject(), forCellReuseIdentifier: TSChatTimeCell.identifier)
        self.listTableView.tableFooterView = UIView()
        self.listTableView.tableHeaderView = self.refreshView
        
        //初始化子 View，键盘控制，动作 bar
        self.setupSubviews(self)
        self.keyboardControl()
        self.setupActionBarButtonInterAction()
        
        //设置录音 delegate
        AudioRecordInstance.delegate = self
        //设置播放 delegate
        AudioPlayInstance.delegate = self
        
        //获取第一屏的数据
        self.firstFetchMessageList()
    }
    
    override func viewDidAppear(animated: Bool) {
        AudioRecordInstance.checkPermissionAndSetupRecord()
        self.checkCameraPermission()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        AudioPlayInstance.stopPlayer()
    }
    
    deinit {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - @protocol UITableViewDelegate
extension TSChatViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


// MARK: - @protocol UITableViewDataSource
extension TSChatViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let chatModel = self.itemDataSouce.get(indexPath.row)
        guard let type: MessageContentType = chatModel.messageContentType where chatModel != nil else {
            return 0
        }
        return type.chatCellHeight(chatModel)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chatModel = self.itemDataSouce.get(indexPath.row)
        guard let type: MessageContentType = chatModel.messageContentType where chatModel != nil else {
            return TSChatBaseCell()
        }
        return type.chatCell(tableView, indexPath: indexPath, model: chatModel, viewController: self)!
    }
}


// MARK: - @protocol UIScrollViewDelegate
extension TSChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < kChatLoadMoreOffset) {
            if self.isEndRefreshing {
                log.info("pull to refresh");
                self.pullToLoadMore()
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.hideAllKeyboard()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y - scrollView.contentInset.top < kChatLoadMoreOffset) {
            if self.isEndRefreshing {
                log.info("pull to refresh");
                self.pullToLoadMore()
            }
        }
    }
}









