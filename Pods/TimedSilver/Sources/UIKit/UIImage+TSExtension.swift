//
//  UIImage+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 11/24/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

//https://github.com/melvitax/AFImageHelper/blob/master/AFImageHelper/AFImageExtension.swift

import Foundation
import UIKit
import Photos
import QuartzCore
import CoreGraphics
import Accelerate

public extension UIImage {    
    /**
     Applies gradient color overlay to an image.
     
     - parameter gradientColors: An array of colors to use for the gradient
     - parameter blendMode:      The blending type to use
     
     - returns: new image
     */
    func ts_gradientImageWithColors(_ gradientColors: [UIColor], blendMode: CGBlendMode = CGBlendMode.normal) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(blendMode)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.draw(self.cgImage!, in: rect)
        // Create gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor as AnyObject? } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        // Apply gradient
        context?.clip(to: rect, mask: self.cgImage!)
        context?.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!;
    }

    
    /**
     Capture screen
     
     - parameter view: view
     - parameter rect: rect
     
     - returns: UIImage
     */
    @discardableResult
    class func ts_screenCaptureWithView(_ view: UIView, rect: CGRect) -> UIImage {
        let capture: UIImage
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        //        let layer: CALayer = view.layer
        let selector = NSSelectorFromString("drawViewHierarchyInRect:afterScreenUpdates:")
        if view.responds(to: selector) {
        //if view.responds(to, selector(UIView.drawViewHierarchyInRect(_:afterScreenUpdates:))) {
            view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        } else {
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        capture = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capture
    }
    
    /**
     Create UIImage with the color
     
     - parameter color: color
     
     - returns: UIImage
     */
    class func ts_imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     The Round corner radius
     
     - parameter cornerRadius: value
     
     - returns: UIImage
     */
    func ts_roundWithCornerRadius(_ cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    /**
     Check the image has alpha or not
     
     - returns: Bool
     */
    func ts_hasAlpha() -> Bool {
        let alpha: CGImageAlphaInfo = self.cgImage!.alphaInfo
        return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
    }
    
    /**
     Returns a copy of the given image, adding an alpha channel if it doesn't already have one.
     
     - returns: a new image
     */
    func ts_applyAlpha() -> UIImage? {
        if ts_hasAlpha() {
            return self
        }
        
        let imageRef = self.cgImage;
        let width = imageRef?.width;
        let height = imageRef?.height;
        let colorSpace = imageRef?.colorSpace
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let offscreenContext = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        offscreenContext?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)))
        let imageWithAlpha = UIImage(cgImage: (offscreenContext?.makeImage()!)!)
        return imageWithAlpha
    }
    
    
    /**
     Creates a new image with a border.
     
     - parameter border: The size of the border.
     - parameter color: The color of the border.
     
     - returns: a new image
     */
    func ts_applyBorder(_ border:CGFloat, color:UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = self.cgImage?.width
        let height = self.cgImage?.height
        let bits = self.cgImage?.bitsPerComponent
        let colorSpace = self.cgImage?.colorSpace
        let bitmapInfo = self.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
        context?.setLineWidth(border)
        let rect = CGRect(x: 0, y: 0, width: size.width*scale, height: size.height*scale)
        let inset = rect.insetBy(dx: border*scale, dy: border*scale)
        context?.strokeEllipse(in: inset)
        context?.draw(self.cgImage!, in: inset)
        let image = UIImage(cgImage: (context?.makeImage()!)!)
        UIGraphicsEndImageContext()
        return image
    }

    /**
     Applies a blur to an image based on the specified radius, tint color saturation and mask image
     
     - parameter blurRadius: The radius of the blur.
     - parameter tintColor: The optional tint color.
     - parameter saturationDeltaFactor: The detla for saturation.
     - parameter maskImage: The optional image for masking.
     
     - returns: New image or nil
     */
    func ts_applyBlur(_ blurRadius:CGFloat, tintColor:UIColor?, saturationDeltaFactor:CGFloat, maskImage:UIImage? = nil) -> UIImage? {
        guard size.width > 0 && size.height > 0 && cgImage != nil else {
            return nil
        }
        if maskImage != nil {
            guard maskImage?.cgImage != nil else {
                return nil
            }
        }
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        let hasBlur = blurRadius > CGFloat(Float.ulpOfOne)
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > CGFloat(Float.ulpOfOne)
        if (hasBlur || hasSaturationChange) {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let effectInContext = UIGraphicsGetCurrentContext()
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(cgImage!, in: imageRect)
            
            var effectInBuffer = vImage_Buffer(
                data: effectInContext?.data,
                height: UInt((effectInContext?.height)!),
                width: UInt((effectInContext?.width)!),
                rowBytes: (effectInContext?.bytesPerRow)!)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = vImage_Buffer(
                data: effectOutContext?.data,
                height: UInt((effectOutContext?.height)!),
                width: UInt((effectOutContext?.width)!),
                rowBytes: (effectOutContext?.bytesPerRow)!)
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.main.scale
                let sqrtValue = CGFloat(sqrt(2.0 * Double.pi))
                var radius = UInt32(floor(inputRadius * 3.0 * sqrtValue / 4.0 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
        
    }
}

