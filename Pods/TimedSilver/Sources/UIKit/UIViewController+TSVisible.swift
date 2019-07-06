//
//  UIViewController+TSVisible.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/4/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
    /// Check visible
    var ts_isVisible: Bool {
        return self.isViewLoaded && view.window != nil
    }
}
