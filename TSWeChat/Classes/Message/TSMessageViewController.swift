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
    @IBOutlet fileprivate weak var listTableView: UITableView!
    fileprivate var itemDataSouce = [MessageModel]()
    var actionFloatView: TSMessageActionFloatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "微信"
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.navigationItem.rightButtonAction(TSAsset.Barbuttonicon_add.image) { () -> Void in
            self.actionFloatView.hide(!self.actionFloatView.isHidden)
        }
        
        //Init ActionFloatView
        self.actionFloatView = TSMessageActionFloatView()
        self.actionFloatView.delegate = self
        self.view.addSubview(self.actionFloatView)
        self.actionFloatView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0))
        }
        
        //Init listTableView
        self.listTableView.ts_registerCellNib(TSMessageTableViewCell.self)
        self.listTableView.estimatedRowHeight = 65
        self.listTableView.tableFooterView = UIView()
        
        self.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.actionFloatView.hide(true)
    }
    
    fileprivate func fetchData() {
        guard let JSONData = Data.ts_dataFromJSONFile("message") else { return }
        do {
            let jsonObject = try JSON(data: JSONData)
            var list = [MessageModel]()
            for dict in jsonObject["data"].arrayObject! {
                guard let model = TSMapper<MessageModel>().map(JSON: dict as! [String : Any]) else { continue }
                list.insert(model, at: list.count)
            }
            //Insert more data, make the UITableView long and long.  XD
            self.itemDataSouce.insert(contentsOf: list, at: 0)
            self.itemDataSouce.insert(contentsOf: list, at: 0)
            self.itemDataSouce.insert(contentsOf: list, at: 0)
            self.itemDataSouce.insert(contentsOf: list, at: 0)
            self.listTableView.reloadData()
        } catch {
            print("Error \(error)")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = TSChatViewController.ts_initFromNib() as! TSChatViewController
        viewController.messageModel = self.itemDataSouce[indexPath.row]
        self.ts_pushAndHideTabbar(viewController)
    }
}

// MARK: - @protocol UITableViewDataSource
extension TSMessageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listTableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TSMessageTableViewCell = tableView.ts_dequeueReusableCell(TSMessageTableViewCell.self)
        cell.setCellContnet(self.itemDataSouce[indexPath.row])
        return cell
    }
}

// MARK: - @protocol ActionFloatViewDelegate
extension TSMessageViewController: ActionFloatViewDelegate {
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        log.info("floatViewTapItemIndex:\(type)")
        switch type {
        case .groupChat:
            break
        case .addFriend:
            break
        case .scan:
            break
        case .payment:
            break
        }
    }
}

