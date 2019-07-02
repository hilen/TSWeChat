//
//  NSObject+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 11/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension NSObject {
    /// The class's name
    class var ts_className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    /// The class's identifier, for UITableView，UICollectionView register its cell
    class var ts_identifier: String {
        return String(format: "%@_identifier", self.ts_className)
    }
}
