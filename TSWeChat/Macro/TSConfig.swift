//
//  TSConfig.swift
//  TSWeChat
//
//  Created by Hilen on 2/27/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

class TSConfig {
    static let testUserID = "wx1234skjksmsjdfwe234"
    static let ExpressionBundle = NSBundle(URL: NSBundle.mainBundle().URLForResource("Expression", withExtension: "bundle")!)
    static let ExpressionBundleName = "Expression.bundle"
    static let ExpressionPlist = NSBundle.mainBundle().pathForResource("Expression", ofType: "plist")
}
