//
//  UserDefault+TSArchiveData.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension UserDefaults {
    /**
     Set Archive Data
     
     - parameter object: object
     - parameter key:    key
     */
    func ts_setArchiveData<T: NSCoding>(_ object: T, forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        set(data, forKey: key)
    }
    
    /**
     Get Archive Data
     
     - parameter _:   type
     - parameter key: key
     
     - returns: T
     */
    func ts_archiveDataForKey<T: NSCoding>(_: T.Type, key: String) -> T? {
        guard let data = object(forKey: key) as? Data else { return nil }
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else { return nil }
        return object
    }
}
