//
//  Nnn.swift
//  TSWeChat
//
//  Created by Hilen on 12/10/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

/// PDF image size : 20px * 20px is perfect one
public typealias ActionHandler = (Void) -> Void

public extension UIViewController {
    //Back bar with custom action
    func leftBackAction(action: ActionHandler) {
        self.leftBackBarButton(TSAsset.Back_icon.image, action: action)
    }

    //Back bar with go to previous action
    func leftBackToPrevious() {
        self.leftBackBarButton(TSAsset.Back_icon.image, action: nil)
    }

    //back action
    private func leftBackBarButton(backImage: UIImage, action: ActionHandler!) {
        guard self.navigationController != nil else {
            assert(false, "Your target ViewController doesn't have a UINavigationController")
            return
        }
        
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.setImage(backImage, forState: .Normal)
        button.frame = CGRectMake(0, 0, 40, 30)
        button.imageView!.contentMode = .ScaleAspectFit;
        button.contentHorizontalAlignment = .Left
        
        button.ngl_addAction(forControlEvents: .TouchUpInside, withCallback: {[weak self] in
            //If custom action ,call back
            if action != nil {
                action()
                return
            }
            
            if self!.navigationController!.viewControllers.count > 1 {
                self!.navigationController?.popViewControllerAnimated(true)
            } else if (self!.presentingViewController != nil) {
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
        })

        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        gapItem.width = -7  //fix the space
        self.navigationItem.leftBarButtonItems = [gapItem, barButton]
    }
}

public extension UINavigationItem {
    //left bar
    func leftButtonAction(image: UIImage, action:ActionHandler) {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.setImage(image, forState: .Normal)
        button.frame = CGRectMake(0, 0, 40, 30)
        button.imageView!.contentMode = .ScaleAspectFit;
        button.contentHorizontalAlignment = .Left
        button.ngl_addAction(forControlEvents: .TouchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.leftBarButtonItems = [gapItem, barButton]
    }

    //right bar
    func rightButtonAction(image: UIImage, action:ActionHandler) {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.setImage(image, forState: .Normal)
        button.frame = CGRectMake(0, 0, 40, 30)
        button.imageView!.contentMode = .ScaleAspectFit;
        button.contentHorizontalAlignment = .Right
        button.ngl_addAction(forControlEvents: .TouchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.rightBarButtonItems = [gapItem, barButton]
    }
}

/*
 Block of UIControl
*/
public class ClosureWrapper : NSObject {
    let _callback : Void -> Void
    init(callback : Void -> Void) {
        _callback = callback
    }
    
    public func invoke() {
        _callback()
    }
}

var AssociatedClosure: UInt8 = 0

extension UIControl {
    private func ngl_addAction(forControlEvents events: UIControlEvents, withCallback callback: Void -> Void) {
        let wrapper = ClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(ClosureWrapper.invoke), forControlEvents: events)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}



