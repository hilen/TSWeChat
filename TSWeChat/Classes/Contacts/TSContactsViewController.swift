//
//  TSContactsViewController.swift
//  TSWeChat
//
//  Created by Hilen on 1/8/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cent

class TSContactsViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var footerLineHeightConstraint: NSLayoutConstraint! {
        didSet{footerLineHeightConstraint.constant = 0.5}
    }
    
    private var sortedkeys = [String]()  //UITableView 右侧索引栏的 value
    private var dataDict: Dictionary<String, NSMutableArray>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        self.view.backgroundColor = UIColor(colorNamed: TSColor.viewBackgroundColor)

        self.listTableView.registerNib(TSContactTableViewCell.NibObject(), forCellReuseIdentifier: TSContactTableViewCell.identifier)
        self.listTableView.estimatedRowHeight = 54
        self.listTableView.sectionIndexColor = UIColor.darkGrayColor()
        self.listTableView.tableFooterView = self.footerView

        self.fetchContactList()
    }
    
    func fetchContactList() {
        guard let JSONData = NSData.dataFromJSONFile("contact") else { return }
        let jsonObject = JSON(data: JSONData)
        if jsonObject != JSON.null {
            //创建群聊和公众帐号的数据
            let topArray: NSMutableArray = [
                ContactModelEnum.NewFriends.model,
                ContactModelEnum.GroupChat.model,
                ContactModelEnum.Tags.model,
                ContactModelEnum.PublicAccout.model,
            ]
            //添加 群聊和公众帐号的数据 的 key
            self.sortedkeys.append("")
            self.dataDict = ["" : topArray]
            
            //解析星标联系人数据
            if let startArray = jsonObject["data"][0].arrayObject where startArray.count > 0 {
                let tempList = NSMutableArray()
                for dict in startArray {
                    guard let model = TSMapper<ContactModel>().map(dict) else { continue }
                    tempList.addObject(model)
                }
                tempList.sortedArrayUsingSelector(Selector("compareContact:"))
                self.sortedkeys.append("★")
                self.dataDict = self.dataDict! + ["★" : tempList]
            }
            
            //解析联系人数据
            if let contactArray = jsonObject["data"][1].arrayObject where contactArray.count > 0 {
                let tempList = NSMutableArray()
                for dict in contactArray {
                    guard let model = TSMapper<ContactModel>().map(dict) else { continue }
                    tempList.addObject(model)
                }
                
                self.totalNumberLabel.text = String("\(tempList.count)位联系人")
                
                //重新 a-z 排序
                var dataSource = Dictionary<String, NSMutableArray>()
                for index in 0..<tempList.count {
                    let contactModel = tempList[index] as! ContactModel
                    guard let nameSpell: String = contactModel.nameSpell else { continue }
                    let firstLettery: String = nameSpell[0..<1].uppercaseString
                    if let letterArray: NSMutableArray = dataSource[firstLettery] {
                        letterArray.addObject(contactModel)
                    } else {
                        let tempArray = NSMutableArray()
                        tempArray.addObject(contactModel)
                        dataSource[firstLettery] = tempArray
                    }
                }
                let sortedKeys = Array(dataSource.keys).sort(<)
                self.sortedkeys.appendContentsOf(sortedKeys)
                self.dataDict = self.dataDict! + dataSource
            }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - @protocol UITableViewDelegate
extension TSContactsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
//        let key = self.sortedkeys[indexPath.section]
//        let dataArray: NSMutableArray = self.dataDict![key]!

        if section == 0 {
            let type = ContactModelEnum(rawValue: row)!
            switch type {
            case .NewFriends:
                break
            case .GroupChat:
                break
            case .Tags:
                break
            case .PublicAccout:
                break
            }
        } else {
        
        }
    }
}

// MARK: - @protocol UITableViewDataSource
extension TSContactsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sortedkeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key: String = self.sortedkeys[section]
        let dataArray: NSMutableArray = self.dataDict![key]!
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.listTableView.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TSContactTableViewCell.identifier, forIndexPath: indexPath) as! TSContactTableViewCell
        //判断一下数组越界问题
        guard indexPath.section < self.sortedkeys.count else { return cell }
        let key: String = self.sortedkeys[indexPath.section]
        let dataArray: NSMutableArray = self.dataDict![key]!
        cell.setCellContnet(dataArray[indexPath.row] as! ContactModel)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        let title = self.sortedkeys[section]
        if title == "★" {
            return "★ 星标朋友"
        }
        return title
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        guard let _ = self.dataDict else {
            return []
        }
        let titles: [String] = self.sortedkeys as NSArray as! [String]
        return titles
    }
}



