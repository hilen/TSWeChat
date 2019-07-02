//
//  DispatchQueue+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 9/18/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension DispatchQueue {
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current threxad is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func ts_safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
