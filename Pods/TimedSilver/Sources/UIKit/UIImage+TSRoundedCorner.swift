//
//  UIImage+TSRoundedCorner.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/5/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics
import Accelerate

public extension UIImage {
    /**
     Creates a new image with rounded corners.
     
     - parameter cornerRadius: The corner radius
     
     - returns: a new image
     */
    func ts_roundCorners(_ cornerRadius:CGFloat) -> UIImage? {
        // If the image does not have an alpha layer, add one
        let imageWithAlpha = ts_applyAlpha()
        if imageWithAlpha == nil {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = imageWithAlpha?.cgImage?.width
        let height = imageWithAlpha?.cgImage?.height
        let bits = imageWithAlpha?.cgImage?.bitsPerComponent
        let colorSpace = imageWithAlpha?.cgImage?.colorSpace
        let bitmapInfo = imageWithAlpha?.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!)*scale, height: CGFloat(height!)*scale)
        
        context?.beginPath()
        if (cornerRadius == 0) {
            context?.addRect(rect)
        } else {
            context?.saveGState()
            context?.translateBy(x: rect.minX, y: rect.minY)
            context?.scaleBy(x: cornerRadius, y: cornerRadius)
            let fw = rect.size.width / cornerRadius
            let fh = rect.size.height / cornerRadius
            context?.move(to: CGPoint(x: fw, y: fh/2))
            context?.addArc(tangent1End: CGPoint.init(x: fw, y: fh), tangent2End: CGPoint.init(x: fw/2, y: fh), radius: 1)
            context?.addArc(tangent1End: CGPoint.init(x: 0, y: fh), tangent2End: CGPoint.init(x: 0, y: fh/2), radius: 1)
            context?.addArc(tangent1End: CGPoint.init(x: 0, y: 0), tangent2End: CGPoint.init(x: fw/2, y: 0), radius: 1)
            context?.addArc(tangent1End: CGPoint.init(x: fw, y: 0), tangent2End: CGPoint.init(x: fw, y: fh/2), radius: 1)
            context?.restoreGState()
        }
        context?.closePath()
        context?.clip()
        
        context?.draw((imageWithAlpha?.cgImage)!, in: rect)
        let image = UIImage(cgImage: (context?.makeImage()!)!, scale:scale, orientation: .up)
        UIGraphicsEndImageContext()
        return image
    }

}



