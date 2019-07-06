//
//  UIDevice+TSType.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

public extension UIDevice {
    // MARK: - The iOS screen size
    enum ts_DeviceMaxWidth: Float {
        case iPhone4     = 480.0
        case iPhone5     = 568.0
        case iPhone6     = 667.0
        case iPhone6Plus = 736.0
        case iPad        = 1024.0
        case iPadPro     = 1366.0
    }
    
    enum ts_DeviceType: String {
        case iPhone
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPad
        case iPadPro
        case iTV
        case Unknown
    }
    
    class func ts_maxDeviceWidth() -> Float {
        let w = Float(UIScreen.main.bounds.width)
        let h = Float(UIScreen.main.bounds.height)
        return fmax(w, h)
    }
    
    /**
     Get device type
     
     - returns: enum ts_DeviceType
     */
    class func ts_deviceType() -> ts_DeviceType {
        if ts_isPhone4()     { return ts_DeviceType.iPhone4     }
        if ts_isPhone5()     { return ts_DeviceType.iPhone5     }
        if ts_isPhone6()     { return ts_DeviceType.iPhone6     }
        if ts_isPhone6Plus() { return ts_DeviceType.iPhone6Plus }
        if ts_isPadPro()     { return ts_DeviceType.iPadPro     }
        if ts_isPad()        { return ts_DeviceType.iPad        }
        if ts_isPhone()      { return ts_DeviceType.iPhone      }
        if #available(iOS 9.0, *) {
            if ts_isTV() { return ts_DeviceType.iTV }
        }
        return ts_DeviceType.Unknown
    }
    
    /**
     Device is iPhone ?
     
     - returns: Bool
     */
    class func ts_isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /**
     Device is iPad ?
     
     - returns: Bool
     */
    class func ts_isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /**
     Device is iPadPro ?
     
     - returns: Bool
     */
    class func ts_isPadPro() -> Bool {
        return ts_isPad() && ts_maxDeviceWidth() == ts_DeviceMaxWidth.iPadPro.rawValue
    }
    
    /**
     Device is AppleTV ?
     
     - returns: Bool
     */
    @available(iOS 9, *)
    class func ts_isTV() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }
    
    /**
     Device < iPhone4
     
     - returns: Bool
     */
    class func ts_isPhone4Earlier() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() < ts_DeviceMaxWidth.iPhone4.rawValue
    }
    
    /**
     Device == iPhone4
     
     - returns: Bool
     */
    class func ts_isPhone4() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() == ts_DeviceMaxWidth.iPhone4.rawValue
    }
    
    /**
     Device >= iPhone4
     
     - returns: Bool
     */
    class func ts_isPhone4Later() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() >= ts_DeviceMaxWidth.iPhone4.rawValue
    }
    
    /**
     Device < iPhone5
     
     - returns: Bool
     */
    class func ts_isPhone5Earlier() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() < ts_DeviceMaxWidth.iPhone5.rawValue
    }
    
    /**
     Device == iPhone5
     
     - returns: Bool
     */
    class func ts_isPhone5() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() == ts_DeviceMaxWidth.iPhone5.rawValue
    }
    
    /**
     Device >= iPhone5
     
     - returns: Bool
     */
    class func ts_isPhone5Later() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() >= ts_DeviceMaxWidth.iPhone5.rawValue
    }
    
    /**
     Device < iPhone6
     
     - returns: Bool
     */
    class func ts_isPhone6Earlier() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() < ts_DeviceMaxWidth.iPhone6.rawValue
    }
    
    /**
     Device == iPhone6
     
     - returns: Bool
     */
    class func ts_isPhone6() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() == ts_DeviceMaxWidth.iPhone6.rawValue
    }
    
    /**
     Device >= iPhone6
     
     - returns: Bool
     */
    class func ts_isPhone6Later() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() >= ts_DeviceMaxWidth.iPhone6.rawValue
    }
    
    /**
     Device < iPhone 6 Plus
     
     - returns: Bool
     */
    class func ts_isPhone6PlusEarlier() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() < ts_DeviceMaxWidth.iPhone6Plus.rawValue
    }
    
    /**
     Device == iPhone 6 Plus
     
     - returns: Bool
     */
    class func ts_isPhone6Plus() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() == ts_DeviceMaxWidth.iPhone6Plus.rawValue
    }
    
    /**
     Device >= iPhone 6 Plus
     
     - returns: Bool
     */
    class func ts_isPhone6PlusLater() -> Bool {
        return ts_isPhone() && ts_maxDeviceWidth() >= ts_DeviceMaxWidth.iPhone6Plus.rawValue
    }
    
    // MARK: - The iOS system version
    
    enum ts_iOSType: Float {
        case iOS7 = 7.0
        case iOS8 = 8.0
        case iOS9 = 9.0
        case unknown = 0.0
    }
    
    /// Device's system version
    class var ts_systemVersion: Float {
        struct Singleton {
            static let version = (UIDevice.current.systemVersion as NSString).floatValue
        }
        return Singleton.version
    }
    
    /**
     Device's system version type
     
     - returns: ts_iOSType
     */
    class func ts_systemType() -> ts_iOSType {
        if ts_iOS7() { return ts_iOSType.iOS7 }
        if ts_iOS8() { return ts_iOSType.iOS8 }
        if ts_iOS9() { return ts_iOSType.iOS9 }
        return ts_iOSType.unknown
    }
    
    /**
     Device's system version is iOS7 ?
     
     - returns: Bool
     */
    class func ts_iOS7() -> Bool {
        return ts_isPhone() && ts_systemVersion == ts_iOSType.iOS7.rawValue
    }
    
    /**
     Device's system version is iOS8 ?
     
     - returns: Bool
     */
    class func ts_iOS8() -> Bool {
        return ts_isPhone() && ts_systemVersion == ts_iOSType.iOS8.rawValue
    }

    /**
     Device's system version is iOS9 ?
     
     - returns: Bool
     */
    class func ts_iOS9() -> Bool {
        return ts_isPhone() && ts_systemVersion == ts_iOSType.iOS9.rawValue
    }
}

