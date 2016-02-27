//
//  TSUserDefaults.swift
//  TSWeChat
//
//  Created by Hilen on 11/12/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

/// NSUserDefaults 的简单封装

import Foundation

private let TSDefaults = NSUserDefaults.standardUserDefaults()

class TSUserDefaults {
    // MARK: - getter
    
    class func getObject(key: String) -> AnyObject? {
        return TSDefaults.objectForKey(key)
    }
    
    class func getInt(key: String) -> Int {
        return TSDefaults.integerForKey(key)
    }
    
    class func getBool(key: String) -> Bool {
        return TSDefaults.boolForKey(key)
    }
    
    class func getFloat(key: String) -> Float {
        return TSDefaults.floatForKey(key)
    }
    
    class func getString(key: String) -> String? {
        return TSDefaults.stringForKey(key)
    }
    
    class func getData(key: String) -> NSData? {
        return TSDefaults.dataForKey(key)
    }
    
    class func getArray(key: String) -> NSArray? {
        return TSDefaults.arrayForKey(key)
    }
    
    class func getDictionary(key: String) -> NSDictionary? {
        return TSDefaults.dictionaryForKey(key)
    }
    
    // MARK: - getter 获取 Value 带上默认值

    class func getObject(key: String, defaultValue: AnyObject) -> AnyObject? {
        if getObject(key) == nil {
            return defaultValue ?? ""
        }
        return getObject(key)
    }
    
    class func getInt(key: String, defaultValue: Int) -> Int {
        if getObject(key) == nil {
            return defaultValue
        }
        return getInt(key)
    }
    
    class func getBool(key: String, defaultValue: Bool) -> Bool {
        if getObject(key) == nil {
            return defaultValue
        }
        return getBool(key)
    }
    
    class func getFloat(key: String, defaultValue: Float) -> Float {
        if getObject(key) == nil {
            return defaultValue
        }
        return getFloat(key)
    }
    
    class func getString(key: String, defaultValue: String) -> String? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getString(key)
    }
    
    class func getData(key: String, defaultValue: NSData) -> NSData? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getData(key)
    }
    
    class func getArray(key: String, defaultValue: NSArray) -> NSArray? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getArray(key)
    }
    
    class func getDictionary(key: String, defaultValue: NSDictionary) -> NSDictionary? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getDictionary(key)
    }
    
    
    // MARK: - Setter
    
    class func setObject(key: String, value: AnyObject?) {
        if value == nil {
            TSDefaults.removeObjectForKey(key)
        } else {
            TSDefaults.setObject(value, forKey: key)
        }
        TSDefaults.synchronize()
    }
    
    class func setInt(key: String, value: Int) {
        TSDefaults.setInteger(value, forKey: key)
        TSDefaults.synchronize()
    }
    
    class func setBool(key: String, value: Bool) {
        TSDefaults.setBool(value, forKey: key)
        TSDefaults.synchronize()
    }
    
    class func setFloat(key: String, value: Float) {
        TSDefaults.setFloat(value, forKey: key)
        TSDefaults.synchronize()
    }
    
    class func setString(key: String, value: NSString?) {
        if (value == nil) {
            TSDefaults.removeObjectForKey(key)
        } else {
            TSDefaults.setObject(value, forKey: key)
        }
        TSDefaults.synchronize()
    }
    
    class func setData(key: String, value: NSData) {
        setObject(key, value: value)
    }
    
    class func setArray(key: String, value: NSArray) {
        setObject(key, value: value)
    }
    
    class func setDictionary(key: String, value: NSDictionary) {
        setObject(key, value: value)
    }
    
    // MARK: - Synchronize
    
    class func Sync() {
        TSDefaults.synchronize()
    }
}


