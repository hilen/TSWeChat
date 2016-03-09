//
//  TSMeViewController.swift
//  TSWeChat
//
//  Created by Hilen on 1/8/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

class TSMeViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    
    private let itemDataSouce: [[(name: String, iconImage: UIImage?)]] = [
        [
            ("", nil),
        ],
        [
            ("相册", TSAsset.MoreMyAlbum.image),
            ("收藏", TSAsset.MoreMyFavorites.image),
            ("钱包", TSAsset.MoreMyBankCard.image),
            ("优惠券", TSAsset.MyCardPackageIcon.image),
        ],
        [
            ("表情", TSAsset.MoreExpressionShops.image),
        ],
        [
            ("设置", TSAsset.MoreSetting.image),
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"
        self.view.backgroundColor = UIColor(colorNamed: TSColor.viewBackgroundColor)

        self.listTableView.registerNib(TSMeAvatarTableViewCell.NibObject(), forCellReuseIdentifier: TSMeAvatarTableViewCell.identifier)
        self.listTableView.registerNib(TSImageTextTableViewCell.NibObject(), forCellReuseIdentifier: TSImageTextTableViewCell.identifier)
        self.listTableView.tableFooterView = UIView()
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



// MARK: @protocol - UITableViewDelegate
extension TSMeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        } else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: @protocol - UITableViewDataSource
extension TSMeViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.itemDataSouce[section]
        return rows.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88.0
        } else {
            return 44.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(TSMeAvatarTableViewCell.identifier, forIndexPath: indexPath) as! TSMeAvatarTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TSImageTextTableViewCell.identifier, forIndexPath: indexPath) as! TSImageTextTableViewCell
            let item = self.itemDataSouce[indexPath.section][indexPath.row]
            cell.iconImageView.image = item.iconImage
            cell.titleLabel.text = item.name
            return cell
        }
    }
}



