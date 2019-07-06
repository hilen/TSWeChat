//
//  Date+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 2/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension Date {
    /// Convert NSDate to Millisecond
    static var ts_milliseconds: TimeInterval {
        get { return Date().timeIntervalSince1970 * 1000 }
    }

    // MARK: Intervals In Seconds
    static func ts_minuteInSeconds() -> Double { return 60 }
    static func ts_hourInSeconds() -> Double { return 3600 }
    static func ts_dayInSeconds() -> Double { return 86400 }
    static func ts_weekInSeconds() -> Double { return 604800 }
    static func ts_yearInSeconds() -> Double { return 31556926 }
}
