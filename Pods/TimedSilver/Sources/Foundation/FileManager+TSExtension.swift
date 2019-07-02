//
//  FileManager+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/10/16.
//  Copyright © 2016 Hilen. All rights reserved.
//  https://github.com/shaojiankui/JKCategories/blob/master/JKCategories/Foundation/NSFileManager/NSFileManager%2BJKPaths.h

import Foundation

public extension FileManager {
    /**
     Get URL of Document directory.
     
     - returns: Document directory URL.
     */
    class func ts_documentURL() -> URL {
        return ts_URLForDirectory(.documentDirectory)!
    }
    
    /**
     Get String of Document directory.
     
     - returns: Document directory String.
     */
    class func ts_documentPath() -> String {
        return ts_pathForDirectory(.documentDirectory)!
    }
    
    /**
     Get URL of Library directory
     
     - returns: Library directory URL
     */
    class func ts_libraryURL() -> URL {
        return ts_URLForDirectory(.libraryDirectory)!
    }
    
    /**
     Get String of Library directory
     
     - returns: Library directory String
     */
    class func ts_libraryPath() -> String {
        return ts_pathForDirectory(.libraryDirectory)!
    }
    
    /**
     Get URL of Caches directory
     
     - returns: Caches directory URL
     */
    class func ts_cachesURL() -> URL {
        return ts_URLForDirectory(.cachesDirectory)!
    }
    
    /**
     Get String of Caches directory
     
     - returns: Caches directory String
     */
    class func ts_cachesPath() -> String {
        return ts_pathForDirectory(.cachesDirectory)!
    }
    
    /**
     Adds a special filesystem flag to a file to avoid iCloud backup it.
     
     - parameter filePath: Path to a file to set an attribute.
     */
    class func ts_addSkipBackupAttributeToFile(_ filePath: String) {
        let url: URL = URL(fileURLWithPath: filePath)
        do {
            try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
        } catch {}
    }
    
    /**
     Check available disk space in MB
     
     - returns: Double in MB
     */
    class func ts_availableDiskSpaceMb() -> Double {
        let fileAttributes = try? `default`.attributesOfFileSystem(forPath: ts_documentPath())
        if let fileSize = (fileAttributes![FileAttributeKey.systemSize] as AnyObject).doubleValue {
            return fileSize / Double(0x100000)
        }
        return 0
    }
    
    fileprivate class func ts_URLForDirectory(_ directory: FileManager.SearchPathDirectory) -> URL? {
        return `default`.urls(for: directory, in: .userDomainMask).last
    }
    
    fileprivate class func ts_pathForDirectory(_ directory: FileManager.SearchPathDirectory) -> String? {
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
    }
}

