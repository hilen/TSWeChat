//
//  HttpManager.swift
//  TSWeChat
//
//  Created by Hilen on 11/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit

//简写的 key->value
public typealias ts_parameters = [String : AnyObject]
public typealias SuccessClosure = AnyObject -> Void
public typealias FailureClosure = NSError -> Void

class HttpManager: NSObject {
    class var sharedInstance : HttpManager {
        struct Static {
            static let instance : HttpManager = HttpManager()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
    }
}
