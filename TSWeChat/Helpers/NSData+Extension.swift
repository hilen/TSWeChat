//
//  NSData+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 11/25/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

extension Data {
    public var tokenString: String {
        let characterSet: CharacterSet = CharacterSet(charactersIn:"<>")
        let deviceTokenString: String = (self.description as NSString).trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with:"") as String
        return deviceTokenString
    }
    
    static func dataFromJSONFile(_ fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
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
        let MD5Calculator = MD5(Array(UnsafeBufferPointer(start: (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count), count: self.count)))
        let MD5Data = MD5Calculator.calculate()
        
        let MD5String = NSMutableString()
        for c in MD5Data {
            MD5String.appendFormat("%02x", c)
        }
        return MD5String as String
    }
}
