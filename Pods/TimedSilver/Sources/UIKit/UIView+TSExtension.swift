//
//  UIView+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 11/6/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    /**
     Init from nib
     Notice: The nib file name is the same as the calss name
     
     - returns: UINib
     */
    class func ts_Nib() -> UINib {
        let hasNib: Bool = Bundle.main.path(forResource: self.ts_className, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Nib is not exist")
            return UINib()
        }
        return UINib(nibName: self.ts_className, bundle:nil)
    }
    
    /**
     Init from nib and get the view
     Notice: The nib file name is the same as the calss name
     
     Demo： UIView.ts_viewFromNib(TSCustomView)
     
     - parameter aClass: your class
     
     - returns: Your class's view
     */
    class func ts_viewFromNib<T>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        if Bundle.main.path(forResource: name, ofType: "nib") != nil {
            return UINib(nibName: name, bundle:nil).instantiate(withOwner: nil, options: nil)[0] as! T
        } else {
            fatalError("\(String(describing: aClass)) nib is not exist")
        }
    }

    /**
     All subviews of the UIView
     
     - returns: A group of UIView
     */
    func ts_allSubviews() -> [UIView] {
        var stack = [self]
        var views = [UIView]()
        while !stack.isEmpty {
            let subviews = stack[0].subviews as [UIView]
            views += subviews
            stack += subviews
            stack.remove(at: 0)
        }
        return views
    }
    
    /**
     Take snap shot
     
     - returns: UIImage
     */
    func ts_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// Check the view is visible
    @available(iOS 8.0, *)
    var ts_visible: Bool {
        get {
            if self.window == nil || self.isHidden || self.alpha == 0 {
                return true
            }
            
            let viewRect = self.convert(self.bounds, to: nil)
            guard let app = UIApplication.ts_sharedApplication() else {
                return false
            }
            guard let window = app.keyWindow else {
                return true
            }
            return viewRect.intersects(window.bounds) == false
        }
    }
}







