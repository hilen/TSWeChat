//
//  TSMessageViewController.swift
//  TSWeChat
//
//  Created by Hilen on 11/5/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import SwiftyJSON

class TSMessageViewController: UIViewController {
    @IBOutlet private weak var listTableView: UITableView!
    private var itemDataSouce = [MessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        self.view.backgroundColor = UIColor(colorNamed: TSColor.viewBackgroundColor)
        
        self.listTableView.registerNib(TSMessageTableViewCell.NibObject(), forCellReuseIdentifier: TSMessageTableViewCell.identifier)
        self.listTableView.estimatedRowHeight = 65
        self.listTableView.tableFooterView = UIView()
        
        self.fetchData()
    }
    
    func fetchData() {
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
            self.itemDataSouce.insertContentsOf(list, at: 0)
            self.itemDataSouce.insertContentsOf(list, at: 0)
            self.listTableView.reloadData()
        }
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
//        self.ts_goChatViewController(self.itemDataSouce[indexPath.row])
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


