//
//  Device.swift
//  TSWeChat
//
//  Created by Hilen on 12/22/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

//https://gist.github.com/imkevinxu/2bb1197552b095ab25c8

import Foundation

struct Device {
    
    // MARK: - Singletons
    
    static var TheCurrentDevice: UIDevice {
        struct Singleton {
            static let device = UIDevice.current
        }
        return Singleton.device
    }
    
    static var TheCurrentDeviceVersion: Float {
        struct Singleton {
            static let version = (UIDevice.current.systemVersion as NSString).floatValue
        }
        return Singleton.version
    }
    
    static var TheCurrentDeviceHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.main.bounds.size.height
        }
        return Singleton.height
    }
    
    // MARK: - Device Idiom Checks
    
    static var PHONE_OR_PAD: String {
        if isPhone() {
            return "iPhone"
        } else if isPad() {
            return "iPad"
        }
        return "Not iPhone nor iPad"
    }
    
    static var DEBUG_OR_RELEASE: String {
        #if DEBUG
            return "Debug"
        #else
            return "Release"
        #endif
    }
    
    static var SIMULATOR_OR_DEVICE: String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return "Simulator"
        #else
            return "Device"
        #endif
    }
    
    static func isPhone() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .phone
    }
    
    static func isPad() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .pad
    }
    
    static func isDebug() -> Bool {
        return DEBUG_OR_RELEASE == "Debug"
    }
    
    static func isRelease() -> Bool {
        return DEBUG_OR_RELEASE == "Release"
    }
    
    static func isSimulator() -> Bool {
        return SIMULATOR_OR_DEVICE == "Simulator"
    }
    
    static func isDevice() -> Bool {
        return SIMULATOR_OR_DEVICE == "Device"
    }
    
    // MARK: - Device Version Checks
    
    enum Versions: Float {
        case five  = 5.0
        case six   = 6.0
        case seven = 7.0
        case eight = 8.0
        case nine  = 9.0
    }
    
    static func isVersion(_ version: Versions) -> Bool {
        return TheCurrentDeviceVersion >= version.rawValue && TheCurrentDeviceVersion < (version.rawValue + 1.0)
    }
    
    static func isVersionOrLater(_ version: Versions) -> Bool {
        return TheCurrentDeviceVersion >= version.rawValue
    }
    
    static func isVersionOrEarlier(_ version: Versions) -> Bool {
        return TheCurrentDeviceVersion < (version.rawValue + 1.0)
    }
    
    static var CURRENT_VERSION: String {
        return "\(TheCurrentDeviceVersion)"
    }
    
    // MARK: iOS 5 Checks
    
    static func IS_OS_5() -> Bool {
        return isVersion(.five)
    }
    
    static func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(.five)
    }
    
    static func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.five)
    }
    
    // MARK: iOS 6 Checks
    
    static func IS_OS_6() -> Bool {
        return isVersion(.six)
    }
    
    static func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(.six)
    }
    
    static func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.six)
    }
    
    // MARK: iOS 7 Checks
    
    static func IS_OS_7() -> Bool {
        return isVersion(.seven)
    }
    
    static func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(.seven)
    }
    
    static func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.seven)
    }
    
    // MARK: iOS 8 Checks
    
    static func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }
    
    static func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }
    
    static func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }
    
    // MARK: iOS 9 Checks
    
    static func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }
    
    static func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }
    
    static func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }
    
    // MARK: - Device Size Checks
    
    enum Heights: CGFloat {
        case inches_3_5 = 480
        case inches_4 = 568
        case inches_4_7 = 667
        case inches_5_5 = 736
    }
    
    static func isSize(_ height: Heights) -> Bool {
        return TheCurrentDeviceHeight == height.rawValue
    }
    
    static func isSizeOrLarger(_ height: Heights) -> Bool {
        return TheCurrentDeviceHeight >= height.rawValue
    }
    
    static func isSizeOrSmaller(_ height: Heights) -> Bool {
        return TheCurrentDeviceHeight <= height.rawValue
    }
    
    static var CURRENT_SIZE: String {
        if IS_3_5_INCHES() {
            return "3.5 Inches"
        } else if IS_4_INCHES() {
            return "4 Inches"
        } else if IS_4_7_INCHES() {
            return "4.7 Inches"
        } else if IS_5_5_INCHES() {
            return "5.5 Inches"
        }
        return "\(TheCurrentDeviceHeight) Points"
    }
    
    // MARK: Retina Check
    
    static func IS_RETINA() -> Bool {
        return UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))
    }
    
    // MARK: 3.5 Inch Checks
    
    static func IS_3_5_INCHES() -> Bool {
        return isPhone() && isSize(.inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.inches_3_5)
    }
    
    // MARK: 4 Inch Checks
    
    static func IS_4_INCHES() -> Bool {
        return isPhone() && isSize(.inches_4)
    }
    
    static func IS_4_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_4)
    }
    
    static func IS_4_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.inches_4)
    }
    
    // MARK: 4.7 Inch Checks
    
    static func IS_4_7_INCHES() -> Bool {
        return isPhone() && isSize(.inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_4_7)
    }
    
    // MARK: 5.5 Inch Checks
    
    static func IS_5_5_INCHES() -> Bool {
        return isPhone() && isSize(.inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_5_5)
    }
    
    // MARK: - International Checks
    
    static var CURRENT_REGION: String {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
    }
}



