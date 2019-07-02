//
//  UISearchBar+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 16/1/5.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UISearchBar {
    /// Get the canlcel button
    var ts_cancelButton: UIButton {
        get {
            var button = UIButton()
            for view in self.subviews {
                for subView in view.subviews {
                    if subView.isKind(of: UIButton.self) {
                        button = subView as! UIButton
                        return button
                    }
                }
            }
            return button
        }
    }
}
