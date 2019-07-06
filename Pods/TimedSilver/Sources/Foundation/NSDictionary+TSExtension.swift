//
//  NSDictionary+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/4/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension NSDictionary {
    /**
     Init from json string
     
     - parameter ts_JSONString: json string
     
     - returns: NSDictionary or nil
     */
    public convenience init? (ts_JSONString: String) {
        if let data = (try? JSONSerialization.jsonObject(with: ts_JSONString.data(using: String.Encoding.utf8, allowLossyConversion: true)!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
            self.init(dictionary: data)
        } else {
            self.init()
            return nil
        }
    }
    
    /**
     Make the NSDictionary to json string
     
     - returns: string or nil
     */
    public func ts_formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            return String(jsonStr ?? "")
        }
        return nil
    }
}


