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
        self.itemDataSouce.insert(contentsOf: list, at: 0)
        self.listTableView.reloadData({[unowned self] _ in
            self.isReloading = false
            })
        self.listTableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
    }
    
    /**
     下拉加载更多请求，模拟一下请求时间
     */
    func pullToLoadMore() {
        self.isEndRefreshing = false
        self.indicatorView.startAnimating()
        self.isReloading = true
        
        let backgroundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        backgroundQueue.async(execute: {
            guard let list = self.fetchData() else {
                self.indicatorView.stopAnimating()
                self.isReloading = false
                return
            }
            sleep(1)
            DispatchQueue.main.async(execute: { () -> Void in
                self.itemDataSouce.insert(contentsOf: list, at: 0)
                self.indicatorView.stopAnimating()
                //            self!.listTableView.tableHeaderView = nil
                self.updateTableWithNewRowCount(list.count)
                self.isEndRefreshing = true
            })
        })
    }
    
    //获取聊天列表数据
    func fetchData() -> [ChatModel]? {
        guard let JSONData = Data.dataFromJSONFile("chat") else {
            return nil
        }
        
        var list = [ChatModel]()
        let jsonObj = JSON(data: JSONData)
        if jsonObj != JSON.null {
            var temp: ChatModel?
            for dict in jsonObj["data"].arrayObject! {
                guard let model = TSMapper<ChatModel>().map(JSON: dict as! [String : Any]) else {
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
                    list.insert(ChatModel(timestamp: timestamp), at: list.count)
                }
                list.insert(model, at: list.count)
                temp = model
            }
        }
        return list
    }
    
    //下拉刷新加载数据， inert rows
    func updateTableWithNewRowCount(_ count: Int) {
        var contentOffset = self.self.listTableView.contentOffset

        UIView.setAnimationsEnabled(false)
        self.listTableView.beginUpdates()
        
        var heightForNewRows: CGFloat = 0
        var indexPaths = [IndexPath]()
        for i in 0 ..< count {
            let indexPath = IndexPath(row: i, section: 0)
            indexPaths.append(indexPath)
            
            heightForNewRows += self.tableView(self.listTableView, heightForRowAt: indexPath)
        }
        contentOffset.y += heightForNewRows
        
        self.listTableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.none)
        self.listTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.self.listTableView.setContentOffset(contentOffset, animated: false)
    }

}
