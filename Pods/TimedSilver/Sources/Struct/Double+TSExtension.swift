//
//  Double+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/10/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

// MARK: - Time extensions

public extension Double {
    var ts_millisecond: TimeInterval  { return self / 1000 }
    var ts_milliseconds: TimeInterval { return self / 1000 }
    var ts_ms: TimeInterval           { return self / 1000 }
    
    var ts_second: TimeInterval       { return self }
    var ts_seconds: TimeInterval      { return self }
    
    var ts_minute: TimeInterval       { return self * 60 }
    var ts_minutes: TimeInterval      { return self * 60 }
    
    var ts_hour: TimeInterval         { return self * 3600 }
    var ts_hours: TimeInterval        { return self * 3600 }
    
    var ts_day: TimeInterval          { return self * 3600 * 24 }
    var ts_days: TimeInterval         { return self * 3600 * 24 }
}
