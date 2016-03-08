//
//  ApplicationManager.swift
//  TSWeChat
//
//  Created by Hilen on 11/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class TSApplicationManager: NSObject {
    static func applicationConfigInit() {
        self.initNavigationBar()
        self.initNotifications()
        TSProgressHUD.ts_initHUD()
    }

    /**
     导航条初始化
     */
    static func initNavigationBar() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UINavigationBar.appearance().barTintColor = UIColor(colorNamed: TSColor.barTintColor)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = true
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(19.0),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    /**
     注册推送
     */
    static func initNotifications() {
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
}





