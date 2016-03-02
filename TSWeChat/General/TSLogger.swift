//
//  TSLogger.swift
//  TSWeChat
//
//  Created by Hilen on 12/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import XCGLogger

let documentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

let cacheDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.defaultInstance()
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose: .lightGrey,
        .Debug: .darkGrey,
        .Info: .darkGreen,
        .Warning: .orange,
        .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.clearColor()), // Optionally use a UIColor
        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    
    #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
        log.removeLogDestination(XCGLogger.constants.baseConsoleLogDestinationIdentifier)
        log.addLogDestination(XCGNSLogDestination(owner: log, identifier: XCGLogger.constants.nslogDestinationIdentifier))
        log.logAppDetails()
    #else
        let logPath: NSURL = cacheDirectory.URLByAppendingPathComponent("ts_wechat_Log.txt")
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
    #endif
    
    return log
}()
