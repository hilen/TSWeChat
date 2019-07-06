//
//  UINavigationItem+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/4/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

public extension UINavigationItem {
    /**
     UINavigationItem's button position
     
     - LeftItem:  Left
     - RightItem: Right
     */
    enum ts_ButtonItemPosition {
        case leftItem, rightItem
    }
    
    /**
     Custom UINavigationItem with a button
     
     - parameter button:    Your button, the class method 'ts_itemButton' can return a button with normal image or text. And you can also create your own button.
     - parameter position: Control the item's position, left or right
     - parameter action:    Handler
     */
    
    func ts_buttonItemAction(
        _ button: UIButton,
        position: ts_ButtonItemPosition,
        action:@escaping () -> Void)
    {
        button.ts_addEventHandler(forControlEvent: .touchUpInside, handler: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -6 //fix the space
        
        switch position {
        case .leftItem:
            button.contentHorizontalAlignment = .left
            self.leftBarButtonItems = [gapItem, barButton]
        case .rightItem:
            button.contentHorizontalAlignment = .right
            self.rightBarButtonItems = [gapItem, barButton]
        }
    }
    
    /**
     Create an item button.
     
     - parameter image: Button image, 20*20 is perfect one
     - parameter text:  Button text
     
     - returns: Item button
     */
    class func ts_itemButton(_ image: UIImage? = nil, text: String? = nil) -> UIButton {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        if let aImage = image {
            button.setImage(aImage, for: UIControl.State())
        }
        
        var buttonWidth: CGFloat = 40
        if let aText = text {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            let attributes: [NSAttributedString.Key : AnyObject] = [
                .font: button.titleLabel!.font,
                ]
            let size: CGSize = aText.boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
                ).size
            
            buttonWidth = size.width
            button.setTitle(aText, for: UIControl.State())
        }
        button.imageView!.contentMode = .scaleAspectFit;
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 30)
        return button
    }

    /**
     Control leftItem enable
     
     - parameter enabled: enabled
     */
    func ts_enableLeftItem(_ enabled: Bool ) {
        guard let barItems = self.leftBarButtonItems , barItems.count > 0 else {
            return
        }
        barItems.forEach({ obj in
            if obj.isKind(of: UIBarButtonItem.self) || obj.isMember(of: UIBarButtonItem.self) {
                obj.isEnabled = !enabled
            }
        })
    }
    
    /**
     Control rightItem enable
     
     - parameter enabled: enabled
     */
    func ts_enableRightItem(_ enabled: Bool ) {
        guard let barItems = self.rightBarButtonItems , barItems.count > 0 else {
            return
        }
        barItems.forEach({ obj in
            if obj.isKind(of: UIBarButtonItem.self) || obj.isMember(of: UIBarButtonItem.self) {
                obj.isEnabled = !enabled
            }
        })
    }

}


