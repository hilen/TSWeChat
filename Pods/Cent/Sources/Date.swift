//
//  Date.swift
//  Cent
//
//  Created by Ankur Patel on 6/30/14.
//  Copyright (c) 2014 Encore Dev Labs LLC. All rights reserved.
//

import Foundation

public extension Date {

    /// Returns a new Date given the year month and day
    ///
    /// - parameter year:
    /// - parameter month:
    /// - parameter day:
    /// - returns: Date
    public static func from(year: Int, month: Int, day: Int) -> Date? {
        let c = DateComponents(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day)
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)

        return gregorian.date(from: c)
    }

    /// Returns a new Date given the unix timestamp
    ///
    /// - parameter unix: timestamp
    /// - returns: Date
    public static func from(unix: Double) -> Date {
        return Date(timeIntervalSince1970: unix)
    }

    /// Parses the date based on the format and return a new Date
    ///
    /// - parameter dateStr: String version of the date
    /// - parameter format: By default it is year month day
    /// - returns: Date
    public static func parse(dateStr: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = format
        dateFmt.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        return dateFmt.date(from: dateStr)!
    }

    /// Returns the unix timestamp of the date passed in or
    /// the current unix timestamp
    ///
    /// - parameter date:
    /// - returns: Double
    public static func unix(date: Date = Date()) -> Double {
       return date.timeIntervalSince1970 as Double
    }
}
