//
//  NSData+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 11/25/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

extension NSData {
    public var tokenString: String {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString:"<>")
        let deviceTokenString: String = (self.description as NSString).stringByTrimmingCharactersInSet(characterSet).stringByReplacingOccurrencesOfString(" ", withString:"") as String
        return deviceTokenString
    }
    
    class func dataFromJSONFile(fileName: String) -> NSData? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                return data
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        } else {
            print("Invalid filename/path.")
            return nil
        }
    }
    
    var MD5String: String {
        let MD5Calculator = MD5(Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(self.bytes), count: self.length)))
        let MD5Data = MD5Calculator.calculate()
        
        let MD5String = NSMutableString()
        for c in MD5Data {
            MD5String.appendFormat("%02x", c)
        }
        return MD5String as String
    }
}