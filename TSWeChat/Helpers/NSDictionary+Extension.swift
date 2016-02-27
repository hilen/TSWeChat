//
//  NSDictionary+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 11/23/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// Merges the dictionary with dictionaries passed. The latter dictionaries will override
    /// values of the keys that are already set
    ///
    /// :param dictionaries A comma seperated list of dictionaries
    mutating func merge<K, V>(dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                self.updateValue(value as! Value, forKey: key as! Key)
            }
        }
    }
    
    func combine(targetDictionary: Dictionary<String, AnyObject>, resultDictionary: Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        var temp = resultDictionary
        for (key, value) in targetDictionary {
            temp[key] = value
        }
        return temp
    }
}


public func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    var map = Dictionary<K, V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}


