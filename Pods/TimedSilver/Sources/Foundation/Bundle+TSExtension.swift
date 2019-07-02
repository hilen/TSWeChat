//
//  Bundle+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/5/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension Bundle {
    /// The app's name
    public static var ts_appName: String? {
        guard let name =  Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String else {
            return nil
        }
        return name
    }
    
    /// The app's version
    public static var ts_appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /// The app's build number
    public static var ts_appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    /// The app's bundle identifier
    public static var ts_bundleIdentifier: String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    /// The app's bundle name
    public static var ts_bundleName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    /// The app's version and build number
    public static var ts_appVersionAndBuild: String {
        let version = ts_appVersion, build = ts_appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    
    /// App's icon file path
    public class var ts_iconFilePath: String {
        let iconFilename = Bundle.main.object(forInfoDictionaryKey: "CFBundleIconFile")
        let iconBasename = (iconFilename as! NSString).deletingPathExtension
        let iconExtension = (iconFilename as! NSString).pathExtension
        return Bundle.main.path(forResource: iconBasename, ofType: iconExtension)!
    }
    
    /**
     App's icon image
     
     - returns: UIImage
     */
    public class func ts_iconImage() -> UIImage? {
        guard let image = UIImage(contentsOfFile:self.ts_iconFilePath) else {
            return nil
        }
        return image
    }
    
}



