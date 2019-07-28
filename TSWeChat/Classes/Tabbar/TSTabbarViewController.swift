//
//  TSTabbarViewController.swift
//  TSWeChat
//
//  Created by Hilen on 11/5/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import TimedSilver
import Dollar

class TSTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()
    }
    
    func setupViewController() {
        let titleArray = ["微信", "通讯录", "发现", "我"]
        
        let normalImagesArray = [
            TSAsset.Tabbar_mainframe.image,
            TSAsset.Tabbar_contacts.image,
            TSAsset.Tabbar_discover.image,
            TSAsset.Tabbar_me.image,
        ]
        
        let selectedImagesArray = [
            TSAsset.Tabbar_mainframeHL.image,
            TSAsset.Tabbar_contactsHL.image,
            TSAsset.Tabbar_discoverHL.image,
            TSAsset.Tabbar_meHL.image,
        ]
        
        let viewControllerArray = [
            TSMessageViewController.ts_initFromNib(),  //消息
            TSContactsViewController.ts_initFromNib(), //联系人
            TSDiscoverViewController.ts_initFromNib(), //发现
            TSMeViewController.ts_initFromNib()   //我
        ]
        
        let navigationVCArray = NSMutableArray()
        for (index, controller) in viewControllerArray.enumerated() {
            controller.tabBarItem!.title = Dollar.fetch(titleArray, index)
            controller.tabBarItem!.image = Dollar.fetch(normalImagesArray, index).withRenderingMode(.alwaysOriginal)
            controller.tabBarItem!.selectedImage = Dollar.fetch(selectedImagesArray, index).withRenderingMode(.alwaysOriginal)
            controller.tabBarItem!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: UIControl.State())
            controller.tabBarItem!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabbarSelectedTextColor], for: .selected)
            let navigationController = UINavigationController(rootViewController: controller)
            navigationVCArray.add(navigationController)
        }
        self.viewControllers = navigationVCArray.mutableCopy() as! [UINavigationController]
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
