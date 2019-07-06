//
//  IndexPath+TSOffset.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/5/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

public extension IndexPath {
    /// The previous row's NSIndexPath. UITableView
    var ts_previousRow: IndexPath {
        let indexPath = IndexPath(row: (self as NSIndexPath).row - 1, section: (self as NSIndexPath).section)
        return indexPath
    }
    
    /// The next row's NSIndexPath. UITableView
    var ts_nextRow: IndexPath {
        let indexPath = IndexPath(row: (self as NSIndexPath).row + 1, section: (self as NSIndexPath).section)
        return indexPath
    }
    
    /// The previous item's NSIndexPath. UICollectionView
    var ts_previousItem: IndexPath {
        let indexPath = IndexPath(item: (self as NSIndexPath).item - 1, section: (self as NSIndexPath).section)
        return indexPath
    }
    
    /// The next item's NSIndexPath. UICollectionView
    var ts_nextItem: IndexPath {
        let indexPath = IndexPath(item: (self as NSIndexPath).item + 1, section: (self as NSIndexPath).section)
        return indexPath
    }
    
    /// The previous section. Both of UICollectionView and UITableView
    var ts_previousSection: IndexPath {
        let indexPath = IndexPath(row: (self as NSIndexPath).row, section: (self as NSIndexPath).section - 1)
        return indexPath
    }
    
    /// The next section. Both of UICollectionView and UITableView
    var ts_nextSection: IndexPath {
        let indexPath = IndexPath(row: (self as NSIndexPath).row, section: (self as NSIndexPath).section + 1)
        return indexPath
    }
}



