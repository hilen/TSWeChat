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
    func leftBackAction(_ action: @escaping ActionHandler) {
        self.leftBackBarButton(TSAsset.Back_icon.image, action: action)
    }

    //Back bar with go to previous action
    func leftBackToPrevious() {
        self.leftBackBarButton(TSAsset.Back_icon.image, action: nil)
    }

    //back action
    fileprivate func leftBackBarButton(_ backImage: UIImage, action: ActionHandler!) {
        guard self.navigationController != nil else {
            assert(false, "Your target ViewController doesn't have a UINavigationController")
            return
        }
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(backImage, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .left
        
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {[weak self] in
            //If custom action ,call back
            if action != nil {
                action()
                return
            }
            
            if self!.navigationController!.viewControllers.count > 1 {
                self!.navigationController?.popViewController(animated: true)
            } else if (self!.presentingViewController != nil) {
                self!.dismiss(animated: true, completion: nil)
            }
        })

        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7  //fix the space
        self.navigationItem.leftBarButtonItems = [gapItem, barButton]
    }
}

public extension UINavigationItem {
    //left bar
    func leftButtonAction(_ image: UIImage, action:@escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(image, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .left
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.leftBarButtonItems = [gapItem, barButton]
    }

    //right bar
    func rightButtonAction(_ image: UIImage, action:@escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(image, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .right
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.rightBarButtonItems = [gapItem, barButton]
    }
}

/*
 Block of UIControl
*/
open class ClosureWrapper : NSObject {
    let _callback : (Void) -> Void
    init(callback : @escaping (Void) -> Void) {
        _callback = callback
    }
    
    open func invoke() {
        _callback()
    }
}

var AssociatedClosure: UInt8 = 0

extension UIControl {
    fileprivate func ngl_addAction(forControlEvents events: UIControlEvents, withCallback callback: @escaping (Void) -> Void) {
        let wrapper = ClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(ClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(self, &AssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}



