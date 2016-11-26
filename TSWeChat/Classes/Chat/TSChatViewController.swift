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
    @IBOutlet var refreshView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    lazy var listTableView: UITableView = {
        let listTableView = UITableView(frame: CGRect.zero, style: .plain)
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.backgroundColor = UIColor.clear
        listTableView.separatorStyle = .none
        // This background image is stolen from Telegram App
        listTableView.backgroundView = UIImageView(image: TSAsset.Chat_background.image)
        return listTableView
    }()
    
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
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true

        //TableView init
        self.listTableView.register(TSChatTextCell.ts_Nib(), forCellReuseIdentifier: TSChatTextCell.identifier)
        self.listTableView.register(TSChatImageCell.ts_Nib(), forCellReuseIdentifier: TSChatImageCell.identifier)
        self.listTableView.register(TSChatVoiceCell.ts_Nib(), forCellReuseIdentifier: TSChatVoiceCell.identifier)
        self.listTableView.register(TSChatSystemCell.ts_Nib(), forCellReuseIdentifier: TSChatSystemCell.identifier)
        self.listTableView.register(TSChatTimeCell.ts_Nib(), forCellReuseIdentifier: TSChatTimeCell.identifier)
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
    
    override func viewDidAppear(_ animated: Bool) {
        AudioRecordInstance.checkPermissionAndSetupRecord()
        self.checkCameraPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        AudioPlayInstance.stopPlayer()
    }
    
    deinit {
        log.verbose("deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - @protocol UITableViewDelegate
extension TSChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - @protocol UITableViewDataSource
extension TSChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let chatModel = self.itemDataSouce.get(index: indexPath.row) else {return 0}
        let type: MessageContentType = chatModel.messageContentType
        return type.chatCellHeight(chatModel)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatModel = self.itemDataSouce.get(index: indexPath.row) else {return TSChatBaseCell()}
        let type: MessageContentType = chatModel.messageContentType
        return type.chatCell(tableView, indexPath: indexPath, model: chatModel, viewController: self)!
    }
}


// MARK: - @protocol UIScrollViewDelegate
extension TSChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < kChatLoadMoreOffset) {
            if self.isEndRefreshing {
                log.info("pull to refresh");
                self.pullToLoadMore()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.hideAllKeyboard()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y - scrollView.contentInset.top < kChatLoadMoreOffset) {
            if self.isEndRefreshing {
                log.info("pull to refresh");
                self.pullToLoadMore()
            }
        }
    }
}









