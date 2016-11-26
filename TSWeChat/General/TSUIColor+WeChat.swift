//
//  UICollor+WeChat.swift
//  TSWeChat
//
//  Created by Hilen on 11/6/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

/*
*   颜色扩展，项目内所用到的颜色，在这里进行配置
*/

import Foundation
import UIKit

extension UIColor {
    class var barTintColor: UIColor {
        get {return UIColor.init(ts_hexString: "#1A1A1A")}
    }
    
    class var tabbarSelectedTextColor: UIColor {
        get {return UIColor.init(ts_hexString: "#68BB1E")}
    }
    
    class var viewBackgroundColor: UIColor {
        get {return UIColor.init(ts_hexString: "#E7EBEE")}
    }
}
