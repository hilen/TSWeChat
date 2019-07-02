//
//  UITableView+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/5/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    /**
     Last indexPath in section
     
     - parameter section: section
     
     - returns: NSIndexPath
     */
    func ts_lastIndexPathInSection(_ section: Int) -> IndexPath? {
        return IndexPath(row: self.numberOfRows(inSection: section)-1, section: section)
    }
    
    /// Last indexPath in UITableView
    var ts_lastIndexPath: IndexPath? {
        if (self.ts_totalRows - 1) > 0{
            return IndexPath(row: self.ts_totalRows-1, section: self.numberOfSections)
        } else {
            return nil
        }
    }
    
    /// Total rows in UITableView
    var ts_totalRows: Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    /**
     Remove table header view
     */
    func ts_removeTableHeaderView() {
        self.tableHeaderView = UIView(frame:  CGRect(x: 0, y: 0, width: UIScreen.ts_width, height: 0.1))
    }
    
    /**
     Remove table footer view
     */
    func ts_removeTableFooterView() {
        self.tableFooterView = UIView(frame:  CGRect(x: 0, y: 0, width: UIScreen.ts_width, height: 0.1))
    }

    /**
     Scroll to the bottom
     
     - parameter animated: animated
     */
    func ts_scrollToBottom(_ animated: Bool) {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section) - 1
        if section < 0 || row < 0 {
            return
        }
        let path = IndexPath(row: row, section: section)
        let offset = contentOffset.y
        self.scrollToRow(at: path, at: .top, animated: animated)
        let delay = (animated ? 0.1 : 0.0) * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
            if self.contentOffset.y != offset {
                self.ts_scrollToBottom(false)
            }
        })
    }
    
    /**
     Scroll to the bottom without flashing
     */
    func ts_scrollBottomWithoutFlashing() {
        guard let indexPath = self.ts_lastIndexPath else {
            return
        }
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
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
     Fetch indexPaths of UITableView's visibleCells
     
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
     Reload data with completion block
     
     - parameter completion: completion block
     */
    func ts_reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
        
    }
}



