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
    
    fileprivate let itemDataSouce: [[(name: String, iconImage: UIImage?)]] = [
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
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.listTableView.ts_registerCellNib(TSMeAvatarTableViewCell.self)
        self.listTableView.ts_registerCellNib(TSImageTextTableViewCell.self)
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: @protocol - UITableViewDataSource
extension TSMeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.itemDataSouce[section]
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:TSMeAvatarTableViewCell = tableView.ts_dequeueReusableCell(TSMeAvatarTableViewCell.self)
            return cell
        } else {
            let cell:TSImageTextTableViewCell = tableView.ts_dequeueReusableCell(TSImageTextTableViewCell.self)
            let item = self.itemDataSouce[indexPath.section][indexPath.row]
            cell.iconImageView.image = item.iconImage
            cell.titleLabel.text = item.name
            return cell
        }
    }
}



