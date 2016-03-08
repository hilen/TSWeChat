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

typealias TSColor = UIColor.LocalColorName

import Foundation
import UIColor_Hex_Swift
import UIKit

extension UIColor {
    enum LocalColorName : String {
        case barTintColor = "#1A1A1A"  /*navigationbar 的颜色*/
        case tabbarSelectedTextColor = "#68BB1E"
        case viewBackgroundColor = "#E7EBEE"
    }
    
    convenience init!(colorNamed name: LocalColorName) {
        self.init(rgba: name.rawValue)
    }
}
