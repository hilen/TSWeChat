//
//  UIImage+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 11/24/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit
import Photos

public extension UIImage {
    //https://github.com/melvitax/AFImageHelper/blob/master/AFImageHelper%2FAFImageExtension.swift
    public enum UIImageContentMode {
        case ScaleToFill, ScaleAspectFit, ScaleAspectFill
    }
    
    /**
     Creates a resized copy of an image.
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     - Parameter quality:     The image quality
     
     - Returns A new image
     */
    func resize(size:CGSize, contentMode: UIImageContentMode = .ScaleToFill, quality: CGInterpolationQuality = .Medium) -> UIImage? {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .ScaleToFill:
            ratio = 1
        case .ScaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .ScaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, Int(rect.size.width), Int(rect.size.height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        let transform = CGAffineTransformIdentity
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(context, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, quality)
        
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        CGContextDrawImage(context, rect, self.CGImage)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    //iOS7+ capture screen
    func screenCaptureWithView(view: UIView, rect: CGRect) -> UIImage {
        var capture: UIImage
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y)
        //        let layer: CALayer = view.layer
        if view.respondsToSelector(#selector(UIView.drawViewHierarchyInRect(_:afterScreenUpdates:))) {
            view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        } else {
            view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        }
        capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capture
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func roundWithCornerRadius(cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        drawInRect(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func hasAlpha() -> Bool {
        let alpha: CGImageAlphaInfo = CGImageGetAlphaInfo(self.CGImage)
        return (alpha == .First || alpha == .Last || alpha == .PremultipliedFirst || alpha == .PremultipliedLast)
    }
}

