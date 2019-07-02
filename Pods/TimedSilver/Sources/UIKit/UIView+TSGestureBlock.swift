//
//  UIView+TSGestureBlock.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 1/6/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

fileprivate class TSClosureWrapper : NSObject {
    let _callback : () -> Void
    init(callback : @escaping () -> Void) {
        _callback = callback
    }
    
    @objc func invoke() {
        _callback()
    }
}

fileprivate var AssociatedClosure: UInt8 = 18

public extension UIView {
    /// Adds a tap gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func ts_tapped(callback: @escaping () -> Void) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = TSClosureWrapper(callback: callback)
        let gesture = UITapGestureRecognizer.init(target: wrapper, action: #selector(TSClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a long press gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func ts_longPressed(callback: @escaping () -> Void) -> UILongPressGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = TSClosureWrapper(callback: callback)
        let gesture = UILongPressGestureRecognizer.init(target: wrapper, action: #selector(TSClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a pinch press gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func ts_pinched(callback: @escaping () -> Void) -> UIPinchGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = TSClosureWrapper(callback: callback)
        let gesture = UIPinchGestureRecognizer.init(target: wrapper, action: #selector(TSClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a pan gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func ts_panned(callback: @escaping () -> Void) -> UIPanGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = TSClosureWrapper(callback: callback)
        let gesture = UIPanGestureRecognizer.init(target: wrapper, action: #selector(TSClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a rotation gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func ts_rotated(callback: @escaping () -> Void) -> UIRotationGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = TSClosureWrapper(callback: callback)
        let gesture = UIRotationGestureRecognizer.init(target: wrapper, action: #selector(TSClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
}



