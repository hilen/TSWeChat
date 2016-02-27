//
//  AboutApp.swift
//  TSWeChat
//
//  Created by Hilen on 11/23/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

public struct App {
    public static var appName: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
    }
    
    public static var appVersion: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    public static var appBuild: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
    
    public static var bundleIdentifier: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    public static var bundleName: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    }
    
    public static var appStoreURL: NSURL {
        return NSURL(string: "your URL")!
    }
    
    public static var appVersionAndBuild: String {
        let version = appVersion, build = appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    public static var IDFA: String {
        return ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
    }
    
    public static var IDFV: String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
        
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.sharedApplication().statusBarOrientation
    }
    
    public static var screenStatusBarHeight: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }
    
    public static var screenHeightWithoutStatusBar: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.mainScreen().bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.mainScreen().bounds.size.width - screenStatusBarHeight
        }
    }
}



