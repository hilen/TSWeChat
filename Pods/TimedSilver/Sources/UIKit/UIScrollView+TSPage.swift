//
//  UIScrollView+TSPage.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/10/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// All pages
    public var ts_pages: Int {
        get {
            let pages = Int(self.contentSize.width / self.frame.size.width);
            return pages
        }
    }

    /// The current page
    public var ts_currentPage:Int {
        get {
            let pages = Float(self.contentSize.width / self.frame.size.width);
            let scrollPercent = Float(self.ts_scrollPercent)
            let currentPage = roundf((pages-1)*scrollPercent)
            return Int(currentPage)
        }
    }
    
    /// UIScrollView scroll percent
    public var ts_scrollPercent: CGFloat {
        get {
            let width = self.contentSize.width - self.frame.size.width
            let scrollPercent = self.contentOffset.x / width
            return scrollPercent
        }
    }
    
    /**
     Set the horizontal UIScrollView to specified page
     
     - parameter page:     Page number
     - parameter animated: Animated
     */
    public func ts_setPageX(_ page: Int, animated: Bool? = nil) {
        let pageWidth = self.frame.size.width;
        let offsetY = self.contentOffset.y;
        let offsetX = CGFloat(page) * pageWidth;
        let offset = CGPoint(x: offsetX, y: offsetY);
        if animated == nil {
            self.setContentOffset(offset, animated: false)
        } else {
            self.setContentOffset(offset, animated: animated!)
        }
    }
    
    /**
     Set the vertical UIScrollView to specified page
     
     - parameter page:     Page number
     - parameter animated: Animated
     */
    public func ts_setPageY(_ page: Int, animated: Bool? = nil) {
        let pageHeight = self.frame.size.height;
        let offsetX = self.contentOffset.x;
        let offsetY = CGFloat(page) * pageHeight;
        let offset = CGPoint(x: offsetX, y: offsetY);
        if animated == nil {
            self.setContentOffset(offset, animated: false)
        } else {
            self.setContentOffset(offset, animated: animated!)
        }
    }
}


