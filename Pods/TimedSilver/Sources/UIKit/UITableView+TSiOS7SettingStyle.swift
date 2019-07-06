//
//  UITableView+TSiOS7SettingStyle.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/4/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    //http://stackoverflow.com/questions/18822619/ios-7-tableview-like-in-settings-app-on-ipad
    /**
     iOS 7 TableView like in Settings App on iPad
     
     - parameter cell:      cell
     - parameter indexPath: indexPath
     */
    func ts_applyiOS7SettingsStyleGrouping(_ cell: UITableViewCell, indexPath: IndexPath) {
        if (!cell.responds(to: #selector(getter: UIView.tintColor))){
            return
        }
        
        let cornerRadius : CGFloat = 12.0
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef:CGMutablePath = CGMutablePath()
        let bounds: CGRect = cell.bounds.insetBy(dx: 25, dy: 0)
        var addLine: Bool = false
        
        if ((indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).row == self.numberOfRows(inSection: (indexPath as NSIndexPath).section)-1) {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if ((indexPath as NSIndexPath).row == 0) {
            pathRef.move(to: CGPoint.init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint.init(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint.init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint.init(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint.init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if ((indexPath as NSIndexPath).row == self.numberOfRows(inSection: (indexPath as NSIndexPath).section)-1) {
            pathRef.move(to: CGPoint.init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint.init(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint.init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint.init(x: bounds.maxY, y: bounds.maxY), tangent2End: CGPoint.init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8).cgColor
        
        if (addLine == true) {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x: bounds.minX+10, y: bounds.size.height-lineHeight, width: bounds.size.width-10, height: lineHeight)
            lineLayer.backgroundColor = self.separatorColor!.cgColor
            layer.addSublayer(lineLayer)
        }
        let testView: UIView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = UIColor.clear
        cell.backgroundView = testView
    }
    
    
}
