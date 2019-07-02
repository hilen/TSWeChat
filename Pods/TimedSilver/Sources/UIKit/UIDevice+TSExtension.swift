//
//  UIDevice+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/4/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

public extension UIDevice {
    
    /// let modelName = UIDevice.currentDevice().ts_platform
    var ts_platform: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        //iPhone
        case "iPhone1,1": return "iPhone 1G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1": return "iPhone 4 (GSM)"
        case "iPhone3,3": return "iPhone 4 (CDMA)"
        case "iPhone4,1": return "iPhone 4S"
        case "iPhone5,1": return "iPhone 5 (GSM)"
        case "iPhone5,2": return "iPhone 5 (CDMA)"
        case "iPhone5,3": return "iPhone 5c"
        case "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1": return "iPhone 5s"
        case "iPhone6,2": return "iPhone 5s"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1": return "iPhone 7"
        case "iPhone9,2": return "iPhone 7 Plus"
        //iPod
        case "iPod1,1": return "iPod Touch 1G"
        case "iPod2,1": return "iPod Touch 2G"
        case "iPod3,1": return "iPod Touch 3G"
        case "iPod4,1": return "iPod Touch 4G"
        case "iPod5,1": return "iPod Touch 5G"
        case "iPod7,1": return "iPod Touch 6G"
        //iPad
        case "iPad1,1": return "iPad"
        case "iPad2,1": return "iPad 2 (WiFi)"
        case "iPad2,2": return "iPad 2 (GSM)"
        case "iPad2,3": return "iPad 2 (CDMA)"
        case "iPad2,4": return "iPad 2 (WiFi)"
        case "iPad2,5": return "iPad Mini (WiFi)"
        case "iPad2,6": return "iPad Mini (GSM)"
        case "iPad2,7": return "iPad Mini (CDMA)"
        case "iPad3,1": return "iPad 3 (WiFi)"
        case "iPad3,2": return "iPad 3 (CDMA)"
        case "iPad3,3": return "iPad 3 (GSM)"
        case "iPad3,4": return "iPad 4 (WiFi)"
        case "iPad3,5": return "iPad 4 (GSM)"
        case "iPad3,6": return "iPad 4 (CDMA)"
        case "iPad4,1": return "iPad Air (WiFi)"
        case "iPad4,2": return "iPad Air (GSM)"
        case "iPad4,3": return "iPad Air (CDMA)"
        case "iPad4,4": return "iPad Mini Retina (WiFi)"
        case "iPad4,5": return "iPad Mini Retina (Cellular)"
        case "iPad4,7": return "iPad Mini 3 (WiFi)"
        case "iPad4,8": return "iPad Mini 3 (Cellular)"
        case "iPad4,9": return "iPad Mini 3 (Cellular)"
        case "iPad5,1": return "iPad Mini 4 (WiFi)"
        case "iPad5,2": return "iPad Mini 4 (Cellular)"
        case "iPad5,3": return "iPad Air 2 (WiFi)"
        case "iPad5,4": return "iPad Air 2 (Cellular)"
        case "iPad6,3": return "iPad Pro 9.7-inch (WiFi)"
        case "iPad6,4": return "iPad Pro 9.7-inch (Cellular)"
        case "iPad6,7": return "iPad Pro 12.9-inch (WiFi)"
        case "iPad6,8": return "iPad Pro 12.9-inch (Cellular)"
        //AppleTV
        case "AppleTV5,3": return "Apple TV"
        //Simulator
        case "i386", "x86_64": return "Simulator"
        default: return identifier
        }
    }

    /// UUID
    var ts_UUIDString: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /// Disk total
    var ts_totalDiskSpaceInBytes: Int64 {
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
            return space!
        } catch {
            return 0
        }
    }
    
    /// Disk free
    var ts_freeDiskSpaceInBytes: Int64 {
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            return freeSpace!
        } catch {
            return 0
        }
    }
    
    /// Disk used
    var ts_usedDiskSpaceInBytes: Int64 {
        let usedSpace = ts_totalDiskSpaceInBytes - ts_freeDiskSpaceInBytes
        return usedSpace
    }
    
    /// IDFA
    var ts_IDFA: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /// IDFV
    var ts_IDFV: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
}




