//
//  Data+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 11/25/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import Foundation

public extension Data {
    /// Convert the iOS deviceToken to String
    var ts_tokenString: String {
        let characterSet: CharacterSet = CharacterSet(charactersIn:"<>")
        let deviceTokenString: String = (self.description as NSString).trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with:"") as String
        return deviceTokenString
    }
    
    /**
     Create NSData from JSON file
     
     - parameter fileName: name
     
     - returns: NSData
     */
    static func ts_dataFromJSONFile(_ fileName: String) -> Data? {
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
}

