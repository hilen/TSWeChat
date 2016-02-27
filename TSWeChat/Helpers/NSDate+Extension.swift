//
//  NSDate+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 2/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

extension NSDate {
    class var milliseconds: NSTimeInterval {
        get { return NSDate().timeIntervalSince1970 * 1000 }
    }
    
    func week() -> String {
        let myWeekday = NSCalendar.currentCalendar().components([NSCalendarUnit.Weekday], fromDate: self).weekday
        switch myWeekday {
        case 0:
            return "周日"
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        default:
            break
        }
        return "未取到数据"
    }
    
    class func messageAgoSinceDate(date: NSDate) -> String {
        return self.timeAgoSinceDate(date, numericDates: false)
    }
    
    class func timeAgoSinceDate(date: NSDate, numericDates: Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([
            NSCalendarUnit.Minute,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Day,
            NSCalendarUnit.WeekOfYear,
            NSCalendarUnit.Month,
            NSCalendarUnit.Year,
            NSCalendarUnit.Second
            ], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year) 年前"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 年前"
            } else {
                return "去年"
            }
        } else if (components.month >= 2) {
            return "\(components.month) 月前"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 个月前"
            } else {
                return "上个月"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) 周前"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 周前"
            } else {
                return "上一周"
            }
        } else if (components.day >= 2) {
            return "\(components.day) 天前"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 天前"
            } else {
                return "昨天"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) 小时前"
        } else if (components.hour >= 1){
            return "1 小时前"
        } else if (components.minute >= 2) {
            return "\(components.minute) 分钟前"
        } else if (components.minute >= 1){
            return "1 分钟前"
        } else if (components.second >= 3) {
            return "\(components.second) 秒前"
        } else {
            return "刚刚"
        }
    }
}
