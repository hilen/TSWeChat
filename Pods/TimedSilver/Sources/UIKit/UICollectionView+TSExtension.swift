//
//  UICollectionView+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/5/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    /**
     Last indexPath in section
     
     - parameter section: section
     
     - returns: NSIndexPath
     */
    func ts_lastIndexPathInSection(_ section: Int) -> IndexPath? {
        return IndexPath(row: self.numberOfItems(inSection: section)-1, section: section)
    }
    
    /// Last indexPath in UICollectionView
    var ts_lastIndexPath: IndexPath? {
        if (self.ts_totalItems - 1) > 0 {
            return IndexPath(row: self.ts_totalItems-1, section: self.numberOfSections)
        } else {
            return nil
        }
    }
    
    /// Total items in UICollectionView
    var ts_totalItems: Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfItems(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    /**
     Scroll to the bottom
     
     - parameter animated: animated
     */
    func ts_scrollToBottom(_ animated: Bool) {
        let section = self.numberOfSections - 1
        let row = self.numberOfItems(inSection: section) - 1
        if section < 0 || row < 0 {
            return
        }
        let path = IndexPath(row: row, section: section)
        let offset = contentOffset.y
        self.scrollToItem(at: path, at: .top, animated: animated)
        let delay = (animated ? 0.1 : 0.0) * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
            if self.contentOffset.y != offset {
                self.ts_scrollToBottom(false)
            }
        })
    }
    
    /**
     Reload data without flashing
     */
    func ts_reloadWithoutFlashing() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.reloadData()
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    /**
     Fetch indexPaths of UICollectionView's visibleCells
     
     - returns: NSIndexPath Array
     */
    func ts_visibleIndexPaths() -> [IndexPath] {
        var list = [IndexPath]()
        for cell in self.visibleCells {
            if let indexPath = self.indexPath(for: cell) {
                list.append(indexPath)
            }
        }
        return list
    }
    
    /**
     Fetch indexPaths of UICollectionView's rect
     
     - returns: NSIndexPath Array
     */
    func ts_indexPathsForElementsInRect(_ rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
        if (allLayoutAttributes?.count ?? 0) == 0 {return []}
        var indexPaths: [IndexPath] = []
        indexPaths.reserveCapacity(allLayoutAttributes!.count)
        for layoutAttributes in allLayoutAttributes! {
            let indexPath = layoutAttributes.indexPath
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    /**
     Reload data with completion block
     
     - parameter completion: completion block
     */
    func ts_reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
        
    }
}





