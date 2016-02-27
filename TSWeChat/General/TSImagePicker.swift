//
//  TSImagePicker.swift
//  TSWeChat
//
//  Created by Hilen on 12/24/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import BSImagePicker
import Photos

/*

Copy the code snip below and paste in your UIViewController

---------------------
self!.TS_presentImagePickerController(
    maxNumberOfSelections: 6,
    select: { (asset: PHAsset) -> Void in
        print("Selected: \(asset)")
    }, deselect: { (asset: PHAsset) -> Void in
        print("Deselected: \(asset)")
    }, cancel: { (assets: [PHAsset]) -> Void in
        print("Cancel: \(assets)")
    }, finish: { (assets: [PHAsset]) -> Void in
        print("Finish: \(assets)")
    }, completion: { () -> Void in
        print("completion")
})
------------------
*/

public extension UIViewController {
    /**
     封装一下 BSImagePickerViewController ，改变 UINavigationBar 的颜色
     
     - parameter maxNumberOfSelections: 最多选 多少个
     - parameter select:                选中的图片
     - parameter deselect:              反选中的图片
     - parameter cancel:                取消按钮
     - parameter finish:                完成按钮
     - parameter completion:            dimiss回掉完成
     */
    func ts_presentImagePickerController(maxNumberOfSelections maxNumberOfSelections: Int, select: ((asset: PHAsset) -> Void)?, deselect: ((asset: PHAsset) -> Void)?, cancel: (([PHAsset]) -> Void)?, finish: (([PHAsset]) -> Void)?, completion: (() -> Void)?) {

        let viewController = BSImagePickerViewController()
        viewController.maxNumberOfSelections = maxNumberOfSelections
        viewController.albumButton.tintColor = UIColor.whiteColor()
        viewController.cancelButton.tintColor = UIColor.whiteColor()
        viewController.doneButton.tintColor = UIColor.whiteColor()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        self.bs_presentImagePickerController(viewController, animated: true,
            select: select, deselect: deselect, cancel: cancel, finish: finish, completion: {_ in
                TSApplicationManager.initNavigationBar()
                if let newCompletion = completion {
                    newCompletion()
                }
        })
    }
    
}

