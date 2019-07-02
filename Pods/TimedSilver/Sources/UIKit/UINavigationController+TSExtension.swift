//
//  UINavigationController+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/10/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

extension UINavigationController {
    /**
     Push with UIViewAnimationTransition
     
     - parameter controller: target viewController
     - parameter transition: UIViewAnimationTransition
     */
    public func ts_pushViewController(_ controller: UIViewController, transition: UIView.AnimationTransition) {
        UIView.beginAnimations(nil, context: nil)
        self.pushViewController(controller, animated: false)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationTransition(transition, for: self.view, cache: true)
        UIView.commitAnimations()
    }
    
    /**
     Pop with UIViewAnimationTransition
     
     - parameter controller: target viewController
     - parameter transition: UIViewAnimationTransition
     
     - returns: UIViewController
     */
    public func ts_popViewController(_ controller: UIViewController, transition: UIView.AnimationTransition) -> UIViewController {
        UIView.beginAnimations(nil, context: nil)
        let controller = self.popViewController(animated: false)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationTransition(transition, for: self.view, cache: true)
        UIView.commitAnimations()
        return controller!
    }
}
