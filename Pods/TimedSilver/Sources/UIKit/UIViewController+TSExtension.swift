//
//  UIViewController+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 11/6/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    /**
     UIViewController init from a inb with same name of the class.
     
     - returns: UIViewController
     */
    class func ts_initFromNib() -> UIViewController {
        let hasNib: Bool = Bundle.main.path(forResource: self.ts_className, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // here
            return UIViewController()
        }
        return self.init(nibName: self.ts_className, bundle: nil)
    }
    
    /**
     Back bar with go to previous action
     
     - parameter backImage: Your image. 20px * 20px is perfect
     */
    func ts_leftBackToPrevious(_ backImage: UIImage) {
        self.ts_leftBackBarButton(backImage, action: {})
    }
    
    /**
     Be sure of your viewController has a UINavigationController
     Left back bar. If your viewController is from push action, then handler will execute popViewControllerAnimated method. If your viewController is from present action, then handler will excute dismissViewControllerAnimated method.
     
     - parameter backImage: Your image. 20px * 20px is perfect
     - parameter action:    Handler
     */
    func ts_leftBackBarButton(_ backImage: UIImage, action: () -> Void) {
        guard self.navigationController != nil else {
            assert(false, "Your target ViewController doesn't have a UINavigationController")
            return
        }
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(backImage, for: UIControl.State())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .left
        
        button.ts_addEventHandler(forControlEvent: .touchUpInside, handler: {[weak self] in
            guard let strongSelf = self else { return }
            if let navigationController = strongSelf.navigationController {
                if navigationController.viewControllers.count > 1 {
                    navigationController.popViewController(animated: true)
                } else if (strongSelf.presentingViewController != nil) {
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            } else {
                assert(false, "Your target ViewController doesn't have a UINavigationController")
            }
        })
        
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7  //fix the space
        navigationItem.leftBarButtonItems = [gapItem, barButton]
    }
    
    /**
     Back to previous, pop or dismiss
     */
    func ts_backToPrevious() {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            } else if (self.presentingViewController != nil) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            assert(false, "Your target ViewController doesn't have a UINavigationController")
        }
    }

}




