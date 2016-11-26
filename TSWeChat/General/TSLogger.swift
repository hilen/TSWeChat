//
//  TSLogger.swift
//  TSWeChat
//
//  Created by Hilen on 12/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import XCGLogger

let XCCacheDirectory: URL = {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1]
}()

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.default
    
    #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
        log.remove(destinationWithIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier)
        log.add(destination: AppleSystemLogDestination(identifier: XCGLogger.Constants.systemLogDestinationIdentifier))
        log.logAppDetails()
    #else
        let logPath: URL = XCCacheDirectory.appendingPathComponent("XCGLogger_Log.txt")
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
        
        // Add colour (using the ANSI format) to our file log, you can see the colour when `cat`ing or `tail`ing the file in Terminal on macOS
        // This is mostly useful when testing in the simulator, or if you have the app sending you log files remotely
        if let fileDestination: FileDestination = log.destination(withIdentifier: XCGLogger.Constants.fileDestinationIdentifier) as? FileDestination {
            let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
            ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
            ansiColorLogFormatter.colorize(level: .debug, with: .black)
            ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
            ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
            ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
            ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
            fileDestination.formatters = [ansiColorLogFormatter]
        }
        
        // Add colour to the console destination.
        // - Note: You need the XcodeColors Plug-in https://github.com/robbiehanson/XcodeColors installed in Xcode
        // - to see colours in the Xcode console. Plug-ins have been disabled in Xcode 8, so offically you can not see
        // - coloured logs in Xcode 8.
        //if let consoleDestination: ConsoleDestination = log.destination(withIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier) as? ConsoleDestination {
        //    let xcodeColorsLogFormatter: XcodeColorsLogFormatter = XcodeColorsLogFormatter()
        //    xcodeColorsLogFormatter.colorize(level: .verbose, with: .lightGrey)
        //    xcodeColorsLogFormatter.colorize(level: .debug, with: .darkGrey)
        //    xcodeColorsLogFormatter.colorize(level: .info, with: .blue)
        //    xcodeColorsLogFormatter.colorize(level: .warning, with: .orange)
        //    xcodeColorsLogFormatter.colorize(level: .error, with: .red)
        //    xcodeColorsLogFormatter.colorize(level: .severe, with: .white, on: .red)
        //    consoleDestination.formatters = [xcodeColorsLogFormatter]
        //}
    #endif
    
    // You can also change the labels for each log level, most useful for alternate languages, French, German etc, but Emoji's are more fun
    //    log.levelDescriptions[.verbose] = "🗯"
    //    log.levelDescriptions[.debug] = "🔹"
    //    log.levelDescriptions[.info] = "ℹ️"
    //    log.levelDescriptions[.warning] = "⚠️"
    //    log.levelDescriptions[.error] = "‼️"
    //    log.levelDescriptions[.severe] = "💣"
    // Alternatively, you can use emoji to highlight log levels (you probably just want to use one of these methods at a time).
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    log.formatters = [emojiLogFormatter]
    
    return log
}()
