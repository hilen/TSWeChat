//
//  UITableView+ChatAdditions.swift
//  TSWeChat
//
//  Created by Hilen on 1/29/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

extension UITableView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }

    
    func insertRowsAtBottom(rows: [NSIndexPath]) {
        //保证 insert row 不闪屏
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRowsAtIndexPaths(
            rows,
            withRowAnimation: .None
        )
        self.endUpdates()
        self.scrollToRowAtIndexPath(rows[0], atScrollPosition: .Bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRowsInSection(i)
            i++
        }
        return rowCount
    }
    
    var lastIndexPath: NSIndexPath? {
        if (self.totalRows()-1) > 0{
            return NSIndexPath(forRow: self.totalRows()-1, inSection: 0)
        } else {
            return nil
        }
    }
    
    //插入数据后调用
    func scrollBottomWithoutFlashing() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    //键盘动画结束后调用
    func scrollBottomToLastRow() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
    }
    
    func scrollToBottom(animated animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y:self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    var isContentInsetBottomZero: Bool {
        get { return self.contentInset.bottom == 0 }
    }
    
    func resetContentInsetAndScrollIndicatorInsets() {
        self.contentInset = UIEdgeInsetsZero
        self.scrollIndicatorInsets = UIEdgeInsetsZero
    }
}


