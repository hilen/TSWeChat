//
//  NSRange+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 9/15/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension NSRange {
    /**
     Init with location and length
     
     - parameter ts_location: location
     - parameter ts_length:   length
     
     - returns: NSRange
     */
    init(ts_location:Int, ts_length:Int) {
        self.init()
        self.location = ts_location
        self.length = ts_length
    }
    
    /**
     Init with location and length
     
     - parameter ts_location: location
     - parameter ts_length:   length
     
     - returns: NSRange
     */
    init(_ ts_location:Int, _ ts_length:Int) {
        self.init()
        self.location = ts_location
        self.length = ts_length
    }
    
    /**
     Init from Range
     
     - parameter ts_range:   Range
     
     - returns: NSRange
     */
    init(ts_range:Range <Int>) {
        self.init()
        self.location = ts_range.lowerBound
        self.length = ts_range.upperBound - ts_range.lowerBound
    }
    
    /**
     Init from Range
     
     - parameter ts_range:   Range
     
     - returns: NSRange
     */
    init(_ ts_range:Range <Int>) {
        self.init()
        self.location = ts_range.lowerBound
        self.length = ts_range.upperBound - ts_range.lowerBound
    }
    
    
    /// Get NSRange start index
    var ts_startIndex:Int { get { return location } }
    
    /// Get NSRange end index
    var ts_endIndex:Int { get { return location + length } }
    
    /// Convert NSRange to Range
    var ts_asRange:Range<Int> { get { return location..<location + length } }
    
    /// Check empty
    var ts_isEmpty:Bool { get { return length == 0 } }
    
    /**
     Check NSRange contains index
     
     - parameter index: index
     
     - returns: Bool
     */
    func ts_contains(index:Int) -> Bool {
        return index >= location && index < ts_endIndex
    }
    
    /**
     Get NSRange's clamp Index
     
     - parameter index: index
     
     - returns: Bool
     */
    func ts_clamp(index:Int) -> Int {
        return max(self.ts_startIndex, min(self.ts_endIndex - 1, index))
    }
    
    /**
     Check NSRange intersects another NSRange
     
     - parameter range: NSRange
     
     - returns: Bool
     */
    func ts_intersects(range:NSRange) -> Bool {
        return NSIntersectionRange(self, range).ts_isEmpty == false
    }
    
    /**
     Get the two NSRange's intersection
     
     - parameter range: NSRange
     
     - returns: NSRange
     */
    func ts_intersection(range:NSRange) -> NSRange {
        return NSIntersectionRange(self, range)
    }
    
    /**
     Get the two NSRange's union value
     
     - parameter range: NSRange
     
     - returns: NSRange
     */
    func ts_union(range:NSRange) -> NSRange {
        return NSUnionRange(self, range)
    }
}
