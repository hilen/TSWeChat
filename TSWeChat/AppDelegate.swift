//
//  AppDelegate.swift
//  TSWeChat
//
//  Created by Hilen on 1/8/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

/*
 Free file download: http://download.wavetlan.com/SVV/Media/HTTP/http-index.htm
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabbarController: TSTabbarViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.tabbarController = TSTabbarViewController()
        self.window!.rootViewController = self.tabbarController
        self.window!.makeKeyAndVisible()
        TSApplicationManager.applicationConfigInit()
        return true
    }

}





