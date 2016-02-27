// The MIT License (MIT)
//
// Copyright (c) 2015 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Photos

/**
Extension on UIViewController to simply presentation of BSImagePicker
*/
public extension UIViewController {
    /**
        Present a given image picker with closures, any of the closures can be nil.
    
        - parameter imagePicker: a BSImagePickerViewController to present
        - parameter animated: To animate the presentation or not
        - parameter select: Closure to call when user selects an asset or nil
        - parameter deselect: Closure to call when user deselects an asset or nil
        - parameter cancel: Closure to call when user cancels or nil
        - parameter finish: Closure to call when user finishes or nil
        - parameter completion: presentation completed closure or nil
    */
    func bs_presentImagePickerController(imagePicker: BSImagePickerViewController, animated: Bool, select: ((asset: PHAsset) -> Void)?, deselect: ((asset: PHAsset) -> Void)?, cancel: (([PHAsset]) -> Void)?, finish: (([PHAsset]) -> Void)?, completion: (() -> Void)?) {
        BSImagePickerViewController.authorize(fromViewController: self) { (authorized) -> Void in
            // Make sure we are authorized before proceding
            guard authorized == true else {
                return
            }
            
            // Set blocks
            imagePicker.selectionClosure = select
            imagePicker.deselectionClosure = deselect
            imagePicker.cancelClosure = cancel
            imagePicker.finishClosure = finish
            
            // Present
            self.presentViewController(imagePicker, animated: animated, completion: completion)
        }
    }
}
