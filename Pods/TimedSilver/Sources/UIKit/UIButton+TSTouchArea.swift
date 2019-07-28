//
//  UIButton+TSTouchArea.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 9/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

private var ts_touchAreaEdgeInsets: UIEdgeInsets = .zero

extension UIButton {
    /// Increase your button touch area.
    /// If your button frame is (0,0,40,40). Then call button.ts_touchInsets = UIEdgeInsetsMake(-30, -30, -30, -30), it will Increase the touch area
    public var ts_touchInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &ts_touchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }
            else {
                return .zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &ts_touchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.ts_touchInsets == .zero || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }
        
        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by:self.ts_touchInsets)//UIEdgeInsetsInsetRect(relativeFrame, self.ts_touchInsets)
        return hitFrame.contains(point)
    }
}


