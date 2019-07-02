//
//  NSString+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension NSString {
    /**
     Returns true if email is valid. This validation is checking string for matching regexp only.
     It will not check domain extensions. It's not guarantee you that it's a real email address also.
     
     - parameter email: your email
     
     - returns: Bool
     */
    class func ts_isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        return result
    }
}
