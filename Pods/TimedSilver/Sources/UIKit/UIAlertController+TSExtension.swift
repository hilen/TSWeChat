//
//  UIAlertController+TSExtension.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/11/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

public extension UIAlertController {
    /**
     Single button alert
     
     - parameter title:      title
     - parameter message:    message
     - parameter buttonText: buttonText can be nil, but default is "OK"
     - parameter completion: completion
     
     - returns: UIAlertController
     */
    @discardableResult
    class func ts_singleButtonAlertWithTitle(
        _ title: String,
        message: String,
        buttonText: String? = "OK",
        completion: (() -> Void)?) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }))
        alert.ts_show()
        return alert
    }
    
    /**
     Two button alert
     
     - parameter title:            title
     - parameter message:          message
     - parameter buttonText: buttonText can be nil, but default is "OK"
     - parameter otherButtonTitle: otherButtonTitle
     - parameter completion:       completion
     
     - returns: UIAlertController
     */
    @discardableResult
    class func ts_doubleButtonAlertWithTitle(
        _ title: String,
        message: String,
        buttonText: String? = "OK",
        otherButtonTitle: String,
        completion: (() -> Void)?) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: otherButtonTitle, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }))
        alert.ts_show()
        return alert
    }

    /**
     Show UIAlertController
     */
    func ts_show() {
        self.ts_present(true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    func ts_present(_ animated: Bool, completion: (() -> Void)?) {
        guard let app = UIApplication.ts_sharedApplication() else {
            return
        }
        if let rootVC = app.keyWindow?.rootViewController {
            self.ts_presentFromController(rootVC, animated: animated, completion: completion)
        }
    }
    
    func ts_presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            self.ts_presentFromController(visibleVC, animated: animated, completion: completion)
        }  else {
            controller.present(self, animated: animated, completion: completion);
        }
    }
    
    func ts_dismiss() {
        
    }
}

