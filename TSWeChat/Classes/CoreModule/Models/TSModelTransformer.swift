//
//  TSModelTransformer.swift
//  TSWeChat
//
//  Created by Hilen on 2/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import ObjectMapper

//转换器：把 1423094023323 微秒时间转换成 几天前，几小时前
let TransformerTimestampToTimeAgo = TransformOf<String, NSNumber>(fromJSON: { (value: AnyObject?) -> String? in
    guard let value = value else {
        return ""
    }
    
    let seconds = Double(value as! NSNumber)/1000
    let timeInterval: TimeInterval = TimeInterval(seconds)
    let date = NSDate(timeIntervalSince1970: timeInterval)
    let string = NSDate.messageAgoSinceDate(date)
    return string
    }, toJSON: { (value: String?) -> NSNumber? in
        return nil
})


//把字符串转换为 Float
let TransformerStringToFloat = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
    guard let value = value else {
        return 0
    }
    let intValue: Float? = Float(value)
    return intValue
    }, toJSON: { (value: Float?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
})

//把字符串转换为 Int
let TransformerStringToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    guard let value = value else {
        return 0
    }
    let intValue: Int? = Int(value)
    return intValue
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
})

//把字符串转换为 CGFloat
let TransformerStringToCGFloat = TransformOf<CGFloat, String>(fromJSON: { (value: String?) -> CGFloat? in
    guard let value = value else {
        return nil
    }
    let intValue: CGFloat? = CGFloat(Int(value)!)
    return intValue
    }, toJSON: { (value: CGFloat?) -> String? in
        if let value = value {
            return String(describing: value)
        }
        return nil
})


//数组的坐标转换为 CLLocation
let TransformerArrayToLocation = TransformOf<CLLocation, [Double]>(fromJSON: { (value: [Double]?) -> CLLocation? in
    if let coordList = value, coordList.count == 2 {
        return CLLocation(latitude: coordList[1], longitude: coordList[0])
    }
    return nil
    }, toJSON: { (value: CLLocation?) -> [Double]? in
        if let location = value {
            return [Double(location.coordinate.longitude), Double(location.coordinate.latitude)]
        }
        return nil
})

