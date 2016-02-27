// The MIT License (MIT)
//
// Copyright (c) 2015 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/**
Used as an overlay on selected cells
*/
@IBDesignable final class SelectionView: UIView {
    var selectionString: String = "" {
        didSet {
            if selectionString != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    var settings: BSImagePickerSettings = Settings()
    
    override func drawRect(rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        
        //// Shadow Declarations
        let shadow2Offset = CGSize(width: 0.1, height: -0.1);
        let shadow2BlurRadius: CGFloat = 2.5;
        
        //// Frames
        let checkmarkFrame = bounds;
        
        //// Subframes
        let group = CGRect(x: CGRectGetMinX(checkmarkFrame) + 3, y: CGRectGetMinY(checkmarkFrame) + 3, width: CGRectGetWidth(checkmarkFrame) - 6, height: CGRectGetHeight(checkmarkFrame) - 6)
        
        //// CheckedOval Drawing
        let checkedOvalPath = UIBezierPath(ovalInRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.0 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.0 + 0.5), floor(CGRectGetWidth(group) * 1.0 + 0.5) - floor(CGRectGetWidth(group) * 0.0 + 0.5), floor(CGRectGetHeight(group) * 1.0 + 0.5) - floor(CGRectGetHeight(group) * 0.0 + 0.5)))
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, settings.selectionShadowColor.CGColor)
        settings.selectionFillColor.setFill()
        checkedOvalPath.fill()
        CGContextRestoreGState(context)
        
        settings.selectionStrokeColor.setStroke()
        checkedOvalPath.lineWidth = 1
        checkedOvalPath.stroke()
        
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        //// Check mark for single assets
        if (settings.maxNumberOfSelections == 1) {
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            
            let checkPath = UIBezierPath()
            checkPath.moveToPoint(CGPoint(x: 7, y: 12.5))
            checkPath.addLineToPoint(CGPoint(x: 11, y: 16))
            checkPath.addLineToPoint(CGPoint(x: 17.5, y: 9.5))
            checkPath.stroke()
            return;
        }
        
        //// Bezier Drawing (Picture Number)
        let size = selectionString.sizeWithAttributes(settings.selectionTextAttributes)

        selectionString.drawInRect(CGRectMake(CGRectGetMidX(checkmarkFrame) - size.width / 2.0,
            CGRectGetMidY(checkmarkFrame) - size.height / 2.0,
            size.width,
            size.height), withAttributes: settings.selectionTextAttributes)
    }
}
