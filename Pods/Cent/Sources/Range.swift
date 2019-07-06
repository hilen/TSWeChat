//
//  Range.swift
//  Cent
//
//  Created by Ankur Patel on 6/30/14.
//  Copyright (c) 2014 Encore Dev Labs LLC. All rights reserved.
//

import Foundation

public extension CountableRange {

    /// For each index in the range invoke the callback by passing the item in range
    ///
    /// - parameter callback: The callback function to invoke that take an element
    func eachWithIndex(callback: (Element) -> ()) {
        for index in self {
            callback(index)
        }
    }

    /// For each index in the range invoke the callback
    ///
    /// - parameter callback: The callback function to invoke
    func each(callback: @escaping () -> ()) {
        self.eachWithIndex() { (T) -> () in
            callback()
        }
    }

}

public extension CountableClosedRange {

    /// For each index in the range invoke the callback by passing the item in range
    ///
    /// - parameter callback: The callback function to invoke that take an element
    func eachWithIndex(callback: (Element) -> ()) {
        for index in self {
            callback(index)
        }
    }

    /// For each index in the range invoke the callback
    ///
    /// - parameter callback: The callback function to invoke
    func each(callback: @escaping () -> ()) {
        self.eachWithIndex() { (T) -> () in
            callback()
        }
    }

}

/// Check if ranges are equal
///
/// - parameter left: Range to compare
/// - parameter right: Range to compare
/// - returns: true if they are smae otherwise false
public func ==<T: Comparable>(left: Range<T>, right: Range<T>) -> Bool {
    return left.lowerBound == right.lowerBound && left.upperBound == right.upperBound
}
