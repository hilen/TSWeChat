//
//  Array.swift
//  Cent
//
//  Created by Ankur Patel on 6/28/14.
//  Copyright (c) 2014 Encore Dev Labs LLC. All rights reserved.
//

import Foundation
import Dollar

public extension Array {

    /// Creates an array of elements from the specified indexes, or keys, of the collection.
    /// Indexes may be specified as individual arguments or as arrays of indexes.
    ///
    /// - parameter indexes: Get elements from these indexes
    /// - returns: New array with elements from the indexes specified.
    func at(indexes: Int...) -> [Element] {
        return Dollar.at(self, indexes: indexes)
    }

    /// Cycles through the array n times passing each element into the callback function
    ///
    /// - parameter times: Number of times to cycle through the array
    /// - parameter callback: function to call with the element
    func cycle<U>(times: Int, callback: (Element) -> U) {
        Dollar.cycle(self, times, callback: callback)
    }

    /// Cycles through the array indefinetly passing each element into the callback function
    ///
    /// - parameter callback: function to call with the element
    func cycle<U>(callback: (Element) -> U) {
        Dollar.cycle(self, callback: callback)
    }

    /// For each item in the array invoke the callback by passing the elem
    ///
    /// - parameter callback: The callback function to invoke that take an element
    /// - returns: array itself
    @discardableResult func eachWithIndex(callback: (Int, Element) -> ()) -> [Element] {
        for (index, elem) in self.enumerated() {
            callback(index, elem)
        }
        return self
    }

    /// For each item in the array invoke the callback by passing the elem along with the index
    ///
    /// - parameter callback: The callback function to invoke
    /// - returns: The array itself
    @discardableResult func each(callback: (Element) -> ()) -> [Element] {
        self.eachWithIndex { (index, elem) -> () in
            callback(elem)
        }
        return self
    }

    /// For each item in the array that meets the when conditon, invoke the callback by passing the elem
    ///
    /// - parameter when: The condition to check each element against
    /// - parameter callback: The callback function to invoke
    /// - returns: The array itself
    @discardableResult func each(when: (Element) -> Bool, callback: (Element) -> ()) -> [Element] {
        return Dollar.each(self, when: when, callback: callback)
    }

    /// Checks if the given callback returns true value for all items in the array.
    ///
    /// - parameter callback: Check whether element value is true or false.
    /// - returns: First element from the array.
    func every(callback: (Element) -> Bool) -> Bool {
        return Dollar.every(self, callback: callback)
    }

    /// Get element from an array at the given index which can be negative
    /// to find elements from the end of the array
    ///
    /// - parameter index: Can be positive or negative to find from end of the array
    /// - parameter orElse: Default value to use if index is out of bounds
    /// - returns: Element fetched from the array or the default value passed in orElse
    func fetch(index: Int, orElse: Element? = .none) -> Element! {
        return Dollar.fetch(self, index, orElse: orElse)
    }

    /// This method is like find except that it returns the index of the first element
    /// that passes the callback check.
    ///
    /// - parameter callback: Function used to figure out whether element is the same.
    /// - returns: First element's index from the array found using the callback.
    func findIndex(callback: (Element) -> Bool) -> Int? {
        return Dollar.findIndex(self, callback: callback)
    }

    /// This method is like findIndex except that it iterates over elements of the array
    /// from right to left.
    ///
    /// - parameter callback: Function used to figure out whether element is the same.
    /// - returns: Last element's index from the array found using the callback.
    func findLastIndex(callback: (Element) -> Bool) -> Int? {
        return Dollar.findLastIndex(self, callback: callback)
    }

    /// Gets the first element in the array.
    ///
    /// - returns: First element from the array.
    func first() -> Element? {
        return Dollar.first(self)
    }

    /// Flattens the array
    ///
    /// - returns: Flatten array of elements
    func flatten() -> [Element] {
        return Dollar.flatten(self)
    }

    /// Get element at index
    ///
    /// - parameter index: The index in the array
    /// - returns: Element at that index
    func get(index: Int) -> Element! {
        return self.fetch(index: index)
    }

    /// Gets all but the last element or last n elements of an array.
    ///
    /// - parameter numElements: The number of elements to ignore in the end.
    /// - returns: Array of initial values.
    func initial(numElements: Int? = 1) -> [Element] {
        return Dollar.initial(self, numElements: numElements!)
    }

    /// Gets the last element from the array.
    ///
    /// - returns: Last element from the array.
    func last() -> Element? {
        return Dollar.last(self)
    }

    /// The opposite of initial this method gets all but the first element or first n elements of an array.
    ///
    /// - parameter numElements: The number of elements to exclude from the beginning.
    /// - returns: The rest of the elements.
    func rest(numElements: Int? = 1) -> [Element] {
        return Dollar.rest(self, numElements: numElements!)
    }

    /// Retrieves the minimum value in an array.
    ///
    /// - returns: Minimum value from array.
    func min<T: Comparable>() -> T? {
        return Dollar.min(map { $0 as! T })
    }

    /// Retrieves the maximum value in an array.
    ///
    /// - returns: Maximum element in array.
    func max<T: Comparable>() -> T? {
        return Dollar.max(map { $0 as! T })
    }

    /// Gets the index at which the first occurrence of value is found.
    ///
    /// - parameter value: Value whose index needs to be found.
    /// - returns: Index of the element otherwise returns nil if not found.
    func indexOf<T: Equatable>(value: T) -> Int? {
        return Dollar.indexOf(map { $0 as! T }, value: value)
    }

    /// Remove element from array
    ///
    /// - parameter value: Value that is to be removed from array
    /// - returns: Element at that index
    mutating func remove<T: Equatable>(value: T) -> T? {
        if let index = Dollar.indexOf(map { $0 as! T }, value: value) {
            return (remove(at: index) as? T)
        } else {
            return .none
        }
    }

    /// Checks if a given value is present in the array.
    ///
    /// - parameter value: The value to check.
    /// - returns: Whether value is in the array.
    func contains<T: Equatable>(value: T) -> Bool {
        return Dollar.contains(map { $0 as! T }, value: value)
    }

    /// Return the result of repeatedly calling `combine` with an accumulated value initialized
    /// to `initial` on each element of `self`, in turn with a corresponding index.
    ///
    /// - parameter initial: the value to be accumulated
    /// - parameter combine: the combiner with the result, index, and current element
    /// - throws: Rethrows the error generated from combine
    /// - returns: combined result
    func reduceWithIndex<T>(initial: T, combine: (T, Int, Array.Iterator.Element) throws -> T) rethrows -> T {
        var result = initial
        for (index, element) in self.enumerated() {
            result = try combine(result, index, element)
        }
        return result
    }

    /// Checks if the array has one or more elements.
    ///
    /// - returns: true if the array is not empty, or false if it is empty.
    public var isNotEmpty: Bool {
        get {
            return !self.isEmpty
        }
    }

    /// Move item in array from old index to new index
    ///
    /// - parameter oldIndex: index of item to be moved
    /// - parameter newIndex: index to move item to
    mutating func moveElement(at oldIndex: Int, to newIndex: Int) {
        let element = self[newIndex]
        self[newIndex] = self[oldIndex]
        self[oldIndex] = element
    }
}

extension Array where Element: Hashable {

    /// Creates an object composed from arrays of keys and values.
    ///
    /// - parameter values: The array of values.
    /// - returns: Dictionary based on the keys and values passed in order.
    public func zipObject<T>(values: [T]) -> [Element:T] {
        return Dollar.zipObject(self, values: values)
    }
}

/// Overloaded operator to appends another array to an array
///
/// - parameter left: array to insert elements into
/// - parameter right: array to source elements from
/// - returns: array with the element appended in the end
public func<<<T>(left: inout [T], right: [T]) -> [T] {
    left += right
    return left
}

/// Overloaded operator to append element to an array
///
/// - parameter array: array to insert element into
/// - parameter elem: element to insert
/// - returns: array with the element appended in the end
public func<<<T>( array: inout [T], elem: T) -> [T] {
    array.append(elem)
    return array
}

/// Overloaded operator to remove elements from first array
///
/// - parameter left: array from which elements will be removed
/// - parameter right: array containing elements to remove
/// - returns: array with the elements from second array removed
public func -<T: Hashable>(left: [T], right: [T]) -> [T] {
    return Dollar.difference(left, right)
}
