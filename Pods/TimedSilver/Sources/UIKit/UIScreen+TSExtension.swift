//
//  UIScreen+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 11/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    /// The screen size
    class var ts_size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// The screen's width
    class var ts_width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// The screen's height
    class var ts_height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /// The screen's orientation size
    @available(iOS 8.0, *)
    class var ts_orientationSize: CGSize {
        guard let app = UIApplication.ts_sharedApplication() else {
            return CGSize.zero
        }
        let systemVersion = (UIDevice.current.systemVersion as NSString).floatValue
        let isLand: Bool = app.statusBarOrientation.isLandscape
        return (systemVersion > 8.0 && isLand) ? UIScreen.ts_swapSize(self.ts_size) : self.ts_size
    }
    
    /// The screen's orientation width
    class var ts_orientationWidth: CGFloat {
        return self.ts_orientationSize.width
    }
    
    /// The screen's orientation height
    class var ts_orientationHeight: CGFloat {
        return self.ts_orientationSize.height
    }
    
    /// The screen's DPI size
    class var ts_DPISize: CGSize {
        let size: CGSize = UIScreen.main.bounds.size
        let scale: CGFloat = UIScreen.main.scale
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
    
    /**
     Swap size
     
     - parameter size: The target size
     
     - returns: CGSize
     */
    class func ts_swapSize(_ size: CGSize) -> CGSize {
        return CGSize(width: size.height, height: size.width)
    }
    
    /// The screen's height without status bar's height
    @available(iOS 8.0, *)
    class var ts_screenHeightWithoutStatusBar: CGFloat {
        guard let app = UIApplication.ts_sharedApplication() else {
            return 0
        }
        
        if app.statusBarOrientation.isLandscape {
            return UIScreen.main.bounds.size.height - app.statusBarFrame.height
        } else {
            return UIScreen.main.bounds.size.width - app.statusBarFrame.height
        }
    }
}



