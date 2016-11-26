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
    
    fileprivate var sortedkeys = [String]()  //UITableView 右侧索引栏的 value
    fileprivate var dataDict: Dictionary<String, NSMutableArray>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        self.view.backgroundColor = UIColor(colorNamed: TSColor.viewBackgroundColor)

        self.listTableView.register(TSContactTableViewCell.NibObject(), forCellReuseIdentifier: TSContactTableViewCell.identifier)
        self.listTableView.estimatedRowHeight = 54
        self.listTableView.sectionIndexColor = UIColor.darkGray
        self.listTableView.tableFooterView = self.footerView

        self.fetchContactList()
    }
    
    func fetchContactList() {
        guard let JSONData = Data.dataFromJSONFile("contact") else { return }
        let jsonObject = JSON(data: JSONData)
        if jsonObject != JSON.null {
            //创建群聊和公众帐号的数据
            let topArray: NSMutableArray = [
                ContactModelEnum.newFriends.model,
                ContactModelEnum.groupChat.model,
                ContactModelEnum.tags.model,
                ContactModelEnum.publicAccout.model,
            ]
            //添加 群聊和公众帐号的数据 的 key
            self.sortedkeys.append("")
            self.dataDict = ["" : topArray]
            
            //解析星标联系人数据
            if let startArray = jsonObject["data"][0].arrayObject, startArray.count > 0 {
                let tempList = NSMutableArray()
                for dict in startArray {
                    guard let model = TSMapper<ContactModel>().map(JSON:dict as! [String : Any]) else { continue }
                    tempList.add(model)
                }
                tempList.sortedArray(using: #selector(ContactModel.compareContact(_:)))
                self.sortedkeys.append("★")
                self.dataDict = self.dataDict! + ["★" : tempList]
            }
            
            //解析联系人数据
            if let contactArray = jsonObject["data"][1].arrayObject, contactArray.count > 0 {
                let tempList = NSMutableArray()
                for dict in contactArray {
                    guard let model = TSMapper<ContactModel>().map(JSON:dict as! [String : Any]) else { continue }
                    tempList.add(model)
                }
                
                self.totalNumberLabel.text = String("\(tempList.count)位联系人")
                
                //重新 a-z 排序
                var dataSource = Dictionary<String, NSMutableArray>()
                for index in 0..<tempList.count {
                    let contactModel = tempList[index] as! ContactModel
                    guard let nameSpell: String = contactModel.nameSpell else { continue }
                    let firstLettery: String = nameSpell[0..<1].uppercased()
                    if let letterArray: NSMutableArray = dataSource[firstLettery] {
                        letterArray.add(contactModel)
                    } else {
                        let tempArray = NSMutableArray()
                        tempArray.add(contactModel)
                        dataSource[firstLettery] = tempArray
                    }
                }
                let sortedKeys = Array(dataSource.keys).sorted(by: <)
                self.sortedkeys.append(contentsOf: sortedKeys)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
//        let key = self.sortedkeys[indexPath.section]
//        let dataArray: NSMutableArray = self.dataDict![key]!

        if section == 0 {
            let type = ContactModelEnum(rawValue: row)!
            switch type {
            case .newFriends:
                break
            case .groupChat:
                break
            case .tags:
                break
            case .publicAccout:
                break
            }
        } else {
        
        }
    }
}

// MARK: - @protocol UITableViewDataSource
extension TSContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sortedkeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key: String = self.sortedkeys[section]
        let dataArray: NSMutableArray = self.dataDict![key]!
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listTableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TSContactTableViewCell.identifier, for: indexPath) as! TSContactTableViewCell
        //判断一下数组越界问题
        guard indexPath.section < self.sortedkeys.count else { return cell }
        let key: String = self.sortedkeys[indexPath.section]
        let dataArray: NSMutableArray = self.dataDict![key]!
        cell.setCellContnet(dataArray[indexPath.row] as! ContactModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        let title = self.sortedkeys[section]
        if title == "★" {
            return "★ 星标朋友"
        }
        return title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let _ = self.dataDict else {
            return []
        }
        let titles: [String] = self.sortedkeys as NSArray as! [String]
        return titles
    }
}



