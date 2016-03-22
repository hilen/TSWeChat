//
//  TSChatViewController+TestData.swift
//  TSWeChat
//
//  Created by Hilen on 3/1/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - @extension TSChatViewController
// 聊天测试数据 , 仅仅是测试
extension TSChatViewController {
    //第一次请求的数据
    func firstFetchMessageList() {
        guard let list = self.fetchData() else {
            return
        }
        self.itemDataSouce.insertContentsOf(list, at: 0)
        self.listTableView.reloadData({[unowned self] _ in
            self.isReloading = false
            })
        self.listTableView.setContentOffset(CGPointMake(0, CGFloat.max), animated: false)
    }
    
    /**
     下拉加载更多请求，模拟一下请求时间
     */
    func pullToLoadMore() {
        self.isEndRefreshing = false
        self.indicatorView.startAnimating()
        self.isReloading = true
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue, {
            guard let list = self.fetchData() else {
                self.indicatorView.stopAnimating()
                self.isReloading = false
                return
            }
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.itemDataSouce.insertContentsOf(list, at: 0)
                self.indicatorView.stopAnimating()
                //            self!.listTableView.tableHeaderView = nil
                self.updateTableWithNewRowCount(list.count)
                self.isEndRefreshing = true
            })
        })
    }
    
    //获取聊天列表数据
    func fetchData() -> [ChatModel]? {
        guard let JSONData = NSData.dataFromJSONFile("chat") else {
            return nil
        }
        
        var list = [ChatModel]()
        let jsonObj = JSON(data: JSONData)
        if jsonObj != JSON.null {
            var temp: ChatModel?
            for dict in jsonObj["data"].arrayObject! {
                guard let model = TSMapper<ChatModel>().map(dict) else {
                    continue
                }
                /**
                *  1，刷新获取的第一条数据，加上时间 model
                *  2，当后面的数据比前面一条多出 2 分钟以上，加上时间 model
                */
                if temp == nil || model.isLateForTwoMinutes(temp!) {
                    guard let timestamp = model.timestamp else {
                        continue
                    }
                    list.insert(ChatModel(timestamp: timestamp), atIndex: list.count)
                }
                list.insert(model, atIndex: list.count)
                temp = model
            }
        }
        return list
    }
    
    //下拉刷新加载数据， inert rows
    func updateTableWithNewRowCount(count: Int) {
        var contentOffset = self.self.listTableView.contentOffset

        UIView.setAnimationsEnabled(false)
        self.listTableView.beginUpdates()
        
        var heightForNewRows: CGFloat = 0
        var indexPaths = [NSIndexPath]()
        for i in 0 ..< count {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            indexPaths.append(indexPath)
            
            heightForNewRows += self.tableView(self.listTableView, heightForRowAtIndexPath: indexPath)
        }
        contentOffset.y += heightForNewRows
        
        self.listTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
        self.listTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.self.listTableView.setContentOffset(contentOffset, animated: false)
    }

}