//
//  CGSize+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

public extension CGSize {
    /**
     Aspect fit size
     
     - parameter boundingSize: boundingSize
     
     - returns: CGSize
     */
    func ts_aspectFit(_ boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width*minRatio, height: height*minRatio)
    }
    
    /**
     Pixel size
     
     - returns: CGSize
     */
    func ts_toPixel() -> CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}
