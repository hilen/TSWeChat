//
//  UITableView+ChatAdditions.swift
//  TSWeChat
//
//  Created by Hilen on 1/29/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

extension UITableView {
    func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }

    
    func insertRowsAtBottom(_ rows: [IndexPath]) {
        //保证 insert row 不闪屏
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRows(at: rows, with: .none)
        self.endUpdates()
        self.scrollToRow(at: rows[0], at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    var lastIndexPath: IndexPath? {
        if (self.totalRows()-1) > 0{
            return IndexPath(row: self.totalRows()-1, section: 0)
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
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    //键盘动画结束后调用
    func scrollBottomToLastRow() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y:self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    var isContentInsetBottomZero: Bool {
        get { return self.contentInset.bottom == 0 }
    }
    
    func resetContentInsetAndScrollIndicatorInsets() {
        self.contentInset = UIEdgeInsets.zero
        self.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}


