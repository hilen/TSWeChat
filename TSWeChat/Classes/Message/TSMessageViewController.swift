//
//  TSMessageViewController.swift
//  TSWeChat
//
//  Created by Hilen on 11/5/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class TSMessageViewController: UIViewController {
    @IBOutlet private weak var listTableView: UITableView!
    private var itemDataSouce = [MessageModel]()
    var actionFloatView: TSMessageActionFloatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "微信"
        self.view.backgroundColor = UIColor(colorNamed: TSColor.viewBackgroundColor)
        self.navigationItem.rightButtonAction(TSAsset.Barbuttonicon_add.image) { (Void) -> Void in
            self.actionFloatView.hide(!self.actionFloatView.hidden)
        }
        
        //Init ActionFloatView
        self.actionFloatView = TSMessageActionFloatView()
        self.actionFloatView.delegate = self
        self.view.addSubview(self.actionFloatView)
        self.actionFloatView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        
        //Init listTableView
        self.listTableView.registerNib(TSMessageTableViewCell.NibObject(), forCellReuseIdentifier: TSMessageTableViewCell.identifier)
        self.listTableView.estimatedRowHeight = 65
        self.listTableView.tableFooterView = UIView()
        
        self.fetchData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.actionFloatView.hide(true)
    }
    
    private func fetchData() {
        guard let JSONData = NSData.dataFromJSONFile("message") else {
            return
        }
        let jsonObject = JSON(data: JSONData)
        if jsonObject != JSON.null {
            var list = [MessageModel]()
            for dict in jsonObject["data"].arrayObject! {
                guard let model = TSMapper<MessageModel>().map(dict) else {
                    continue
                }
                list.insert(model, atIndex: list.count)
            }
            //Insert more data, make the UITableView long and long.  XD
            self.itemDataSouce.insertContentsOf(list, at: 0)
            self.itemDataSouce.insertContentsOf(list, at: 0)
            self.itemDataSouce.insertContentsOf(list, at: 0)
            self.itemDataSouce.insertContentsOf(list, at: 0)
            self.listTableView.reloadData()
        }
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
extension TSMessageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let viewController = TSChatViewController.initFromNib() as! TSChatViewController
        viewController.messageModel = self.itemDataSouce[indexPath.row]
        self.ts_pushAndHideTabbar(viewController)
    }
}

// MARK: - @protocol UITableViewDataSource
extension TSMessageViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.listTableView.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TSMessageTableViewCell.identifier, forIndexPath: indexPath) as! TSMessageTableViewCell
        cell.setCellContnet(self.itemDataSouce[indexPath.row])
        return cell
    }
}

// MARK: - @protocol ActionFloatViewDelegate
extension TSMessageViewController: ActionFloatViewDelegate {
    func floatViewTapItemIndex(type: ActionFloatViewItemType) {
        log.info("floatViewTapItemIndex:\(type)")
        switch type {
        case .GroupChat:
            break
        case .AddFriend:
            break
        case .Scan:
            break
        case .Payment:
            break
        }
    }
}

