//
//  UIControl+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

fileprivate class TSClosureWrapper : NSObject {
    let _callback : () -> Void
    init(callback : @escaping () -> Void) {
        _callback = callback
    }
    
    @objc func invoke() {
        _callback()
    }
}

fileprivate var AssociatedClosure: UInt8 = 0


public extension UIControl {
    /**
     UIControl with closure callback
     
     - parameter events:   UIControlEvents
     - parameter callback: callback
     */
    func ts_addEventHandler(forControlEvent controlEvent: UIControl.Event, handler callback: @escaping () -> Void) {
        let wrapper = TSClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(TSClosureWrapper.invoke), for: controlEvent)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}



