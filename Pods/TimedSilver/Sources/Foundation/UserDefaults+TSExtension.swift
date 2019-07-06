//
//  UserDefault+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

/// Shortcut for `UserDefaults.standard`
///
/// **Pro-Tip:** If you want to use shared user defaults, just
///  redefine this global shortcut in your app target, like so:
///  ~~~
///  TSUserDefaults = UserDefaults(suiteName: "com.my.app")!
///  ~~~
public var TSUserDefaults = UserDefaults.standard

public extension UserDefaults {
    // MARK: - Getter
    /**
     Get object from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_objectForKey(_ key: String, defaultValue: AnyObject? = nil) -> AnyObject? {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue
        }
        return TSUserDefaults.object(forKey: key) as AnyObject?
    }
    
    /**
     Get integer from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_integerForKey(_ key: String, defaultValue: Int? = nil) -> Int {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.integer(forKey: key)
    }
    
    /**
     Get bool from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_boolForKey(_ key: String, defaultValue: Bool? = nil) -> Bool {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.bool(forKey: key)
    }
    
    /**
     Get float from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_floatForKey(_ key: String, defaultValue: Float? = nil) -> Float {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.float(forKey: key)
    }

    /**
     Get double from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_doubleForKey(_ key: String, defaultValue: Double? = nil) -> Double {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.double(forKey: key)
    }
    
    /**
     Get string from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_stringForKey(_ key: String, defaultValue: String? = nil) -> String? {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.string(forKey: key)
    }
    
    /**
     Get NSData from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_dataForKey(_ key: String, defaultValue: Data? = nil) -> Data? {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.data(forKey: key)
    }
    
    /**
     Get NSURL from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_URLForKey(_ key: String, defaultValue: URL? = nil) -> URL? {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.url(forKey: key)
    }
    
    /**
     Get array from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_arrayForKey(_ key: String, defaultValue: [AnyObject]? = nil) -> [AnyObject]? {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.array(forKey: key) as [AnyObject]?
    }
    
    /**
     Get dictionary from NSUserDefaults
     
     - parameter key:          key
     - parameter defaultValue: defaultValue, this can be nil
     
     - returns: AnyObject
     */
    class func ts_dictionaryForKey(_ key: String, defaultValue: [String : AnyObject]? = nil) -> [String : AnyObject]? {
        if (defaultValue != nil) && ts_objectForKey(key) == nil {
            return defaultValue!
        }
        return TSUserDefaults.dictionary(forKey: key) as [String : AnyObject]?
    }

    // MARK: - Setter
    
    /**
     Set object for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setObject(_ key: String, value: AnyObject?) {
        if value == nil {
            TSUserDefaults.removeObject(forKey: key)
        } else {
            TSUserDefaults.set(value, forKey: key)
        }
        TSUserDefaults.synchronize()
    }
    
    /**
     Set integer for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setInteger(_ key: String, value: Int) {
        TSUserDefaults.set(value, forKey: key)
        TSUserDefaults.synchronize()
    }
    
    /**
     Set bool for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setBool(_ key: String, value: Bool) {
        TSUserDefaults.set(value, forKey: key)
        TSUserDefaults.synchronize()
    }
    
    /**
     Set float for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setFloat(_ key: String, value: Float) {
        TSUserDefaults.set(value, forKey: key)
        TSUserDefaults.synchronize()
    }
    
    /**
     Set string for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setString(_ key: String, value: String?) {
        if (value == nil) {
            TSUserDefaults.removeObject(forKey: key)
        } else {
            TSUserDefaults.set(value, forKey: key)
        }
        TSUserDefaults.synchronize()
    }
    
    /**
     Set data for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setData(_ key: String, value: Data) {
        self.ts_setObject(key, value: value as AnyObject?)
    }
    
    /**
     Set array for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setArray(_ key: String, value: [AnyObject]) {
        self.ts_setObject(key, value: value as AnyObject?)
    }
    
    /**
     Set dictionary for key
     
     - parameter key:   key
     - parameter value: value
     */
    class func ts_setDictionary(_ key: String, value: [String : AnyObject]) {
        self.ts_setObject(key, value: value as AnyObject?)
    }
}



