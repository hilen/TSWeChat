//
//  UIWindow+TSHierarchy.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/4/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    /**
     The top ViewController
     
     - returns: UIViewController
     */
    func ts_topViewController() -> UIViewController? {
        var topController = self.rootViewController
        while let pVC = topController?.presentedViewController {
            topController = pVC
        }
        
        if topController == nil {
            assert(false, "Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return topController
    }
}