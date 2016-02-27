//
//  UISearchBar+Extension.swift
//  TSWeChat
//
//  Created by luantianshu on 16/1/5.
//  Copyright © 2016年 Hilen. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    /// 获取 UISearchBar 的取消按钮
    var cancelButton: UIButton {
        get {
            var button = UIButton()
            for view in self.subviews {
                for subView in view.subviews {
                    if subView.isKindOfClass(UIButton) {
                        button = subView as! UIButton
                        return button
                    }
                }
            }
            return button
        }
    }
}