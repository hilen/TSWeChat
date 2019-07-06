//
//  UIImage+TSLaunchImage.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

public extension UIImage {
    /**
     LaunchImage
     
     - returns: UIImage
     */
    class func ts_launchImage() -> UIImage {
        func name() -> String {
            switch UIScreen.main.bounds.height {
            case 480: return "LaunchImage-700"
            case 568: return "LaunchImage-700-568h"
            case 667: return "LaunchImage-800-667h"
            case 736: return "LaunchImage-800-Portrait-736h"
            default:
                abort()
            }
        }
        return UIImage(named: name()) ?? UIImage()
    }
}
