//
//  Int.swift
//  Cent
//
//  Created by Ankur Patel on 6/30/14.
//  Copyright (c) 2014 Encore Dev Labs LLC. All rights reserved.
//

import Foundation
import Dollar

public extension Int {

    /// Invoke a callback n times
    ///
    /// - parameter callback: The function to invoke that accepts the index
    public func times(callback: @escaping (Int) -> ()) {
        (0..<self).forEach(callback)
    }

    /// Invoke a callback n times
    ///
    /// - parameter function: The function to invoke
    public func times(function: @escaping () -> ()) {
        self.times { (index: Int) -> () in
            function()
        }
    }


    /// Check if it is even
    ///
    /// - returns: Bool whether int is even
    public var isEven: Bool {
        get {
            return self % 2 == 0
        }
    }

    /// Check if it is odd
    ///
    /// - returns: Bool whether int is odd
    public var isOdd: Bool {
        get {
            return self % 2 == 1
        }
    }

    /// Get ASCII character from integer
    ///
    /// - returns: Character represented for the given integer
    public var char: Character {
        get {
            return Character(UnicodeScalar(self)!)
        }
    }

    /// Splits the int into array of digits
    ///
    /// - returns: Bool whether int is odd
    public func digits() -> [Int] {
        var digits: [Int] = []
        var selfCopy = self
        while selfCopy > 0 {
            _ = digits << (selfCopy % 10)
            selfCopy = (selfCopy / 10)
        }
        return Array(digits.reversed())
    }

    /// Get the next int
    ///
    /// - returns: next int
    public func next() -> Int {
        return self + 1
    }

    /// Get the previous int
    ///
    /// - returns: previous int
    public func prev() -> Int {
        return self - 1
    }

    /// Invoke the callback from int up to and including limit
    ///
    /// - parameter limit: the max value to iterate upto
    /// - parameter callback: to invoke
    public func upTo(limit: Int, callback: @escaping () -> ()) {
        (self...limit).forEach { _ in
            callback()
        }
    }

    /// Invoke the callback from int up to and including limit passing the index
    ///
    /// - parameter limit: the max value to iterate upto
    /// - parameter callback: to invoke
    public func upTo(limit: Int, callback: @escaping (Int) -> ()) {
        (self...limit).forEach(callback)
    }

    /// Invoke the callback from int down to and including limit
    ///
    /// - parameter limit: the min value to iterate upto
    /// - parameter callback: to invoke
    public func downTo(limit: Int, callback: () -> ()) {
        var selfCopy = self
        while selfCopy >= limit {
            callback()
            selfCopy -= 1
        }
    }

    /// Invoke the callback from int down to and including limit passing the index
    ///
    /// - parameter limit: the min value to iterate upto
    /// - parameter callback: to invoke
    public func downTo(limit: Int, callback: (Int) -> ()) {
        var selfCopy = self
        while selfCopy >= limit {
            callback(selfCopy)
            selfCopy -= 1
        }
    }

    /// GCD metod return greatest common denominator with number passed
    ///
    /// - parameter number:
    /// - returns: Greatest common denominator
    public func gcd(number: Int) -> Int {
        return Dollar.gcd(self, number)
    }

    /// LCM method return least common multiple with number passed
    ///
    /// - parameter number:
    /// - returns: Least common multiple
    public func lcm(number: Int) -> Int {
        return Dollar.lcm(self, number)
    }

    /// Returns random number from 0 upto but not including value of integer
    ///
    /// - returns: Random number
    public func random() -> Int {
        return Dollar.random(self)
    }

    /// Returns Factorial of integer
    ///
    /// - returns: factorial
    public func factorial() -> Int {
        return Dollar.factorial(self)
    }

    

    /// Returns true if i is in closed interval
    ///
    /// - parameter interval: to check in
    /// - returns: true if it is in interval otherwise false
    func isIn(interval: CountableClosedRange<Int>) -> Bool {
        return Dollar.it(self, isIn: Range(interval))
    }
//    /// Returns true if i is in closed interval
//    ///
//    /// - parameter interval: to check in
//    /// - returns: true if it is in interval otherwise false
//    func isIn(interval: ClosedRange<Int>) -> Bool {
//        return Dollar.it(self, isIn: Range(interval))
//    }
    /// Returns true if i is in half open interval
    ///
    /// - parameter interval: to check in
    /// - returns: true if it is in interval otherwise false
    public func isIn(interval: Range<Int>) -> Bool {
        return Dollar.it(self, isIn: interval)
    }

    private func mathForUnit(unit: Calendar.Component) -> CalendarMath {
        return CalendarMath(unit: unit, value: self)
    }

    var seconds: CalendarMath {
        return mathForUnit(unit: .second)
    }

    var second: CalendarMath {
        return seconds
    }

    var minutes: CalendarMath {
        return mathForUnit(unit: .minute)
    }

    var minute: CalendarMath {
        return minutes
    }

    var hours: CalendarMath {
        return mathForUnit(unit: .hour)
    }

    var hour: CalendarMath {
        return hours
    }

    var days: CalendarMath {
        return mathForUnit(unit: .day)
    }

    var day: CalendarMath {
        return days
    }

    var weeks: CalendarMath {
        return mathForUnit(unit: .weekOfYear)
    }

    var week: CalendarMath {
        return weeks
    }

    var months: CalendarMath {
        return mathForUnit(unit: .month)
    }

    var month: CalendarMath {
        return months
    }

    var years: CalendarMath {
        return mathForUnit(unit: .year)
    }

    var year: CalendarMath {
        return years
    }


    struct CalendarMath {
        private let unit: Calendar.Component
        private let value: Int
        private var calendar: Calendar {
            return NSCalendar.autoupdatingCurrent
        }

        public init(unit: Calendar.Component, value: Int) {
            self.unit = unit
            self.value = value
        }

        private func generateComponents(modifer: (Int) -> (Int) = (+)) -> DateComponents {
            var components = DateComponents()
            components.setValue(modifer(value), for: unit)
            return components
        }

        public func from(date: Date) -> Date? {
            return calendar.date(byAdding: generateComponents(), to: date)
        }

        public var fromNow: Date? {
            return from(date: Date())
        }

        public func before(date: Date) -> Date? {
            return calendar.date(byAdding: generateComponents(modifer: -), to: date)
        }

        public var ago: Date? {
            return before(date: Date())
        }
    }
}
