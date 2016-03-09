//
//  TSProgressHUD.swift
//  TSWeChat
//
//  Created by Hilen on 11/11/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

/// 对 HUD 层进行一次封装

import Foundation
import SVProgressHUD

class TSProgressHUD: NSObject {
    class func ts_initHUD() {
        SVProgressHUD.setBackgroundColor(UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 ))
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setFont(UIFont.systemFontOfSize(14))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.None)
    }
    
    //成功
    class func ts_showSuccessWithStatus(string: String) {
        self.TSProgressHUDShow(.Success, status: string)
    }
    
    //失败 ，NSError
    class func ts_showErrorWithObject(error: NSError) {
        self.TSProgressHUDShow(.ErrorObject, status: nil, error: error)
    }
    
    //失败，String
    class func ts_showErrorWithStatus(string: String) {
        self.TSProgressHUDShow(.ErrorString, status: string)
    }
    
    //转菊花
    class func ts_showWithStatus(string: String) {
        self.TSProgressHUDShow(.Loading, status: string)
    }
    
    //警告
    class func ts_showWarningWithStatus(string: String) {
        self.TSProgressHUDShow(.Info, status: string)
    }
    
    //dismiss消失
    class func ts_dismiss() {
        SVProgressHUD.dismiss()
    }
    
    //私有方法
    private class func TSProgressHUDShow(type: HUDType, status: String? = nil, error: NSError? = nil) {
        SVProgressHUD.setDefaultMaskType(.None)
        switch type {
        case .Success:
            SVProgressHUD.showSuccessWithStatus(status)
            
            SVProgressHUD.showSuccessWithStatus(status, maskType: .None)
            break
        case .ErrorObject:
            guard let newError = error else {
                SVProgressHUD.showErrorWithStatus("Error:出错拉")
//                SVProgressHUD.showErrorWithStatus("Error:出错拉", maskType: .None)
                return
            }
            
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showErrorWithStatus("Error:出错拉")
//                SVProgressHUD.showErrorWithStatus("Error:出错拉", maskType: .None)
            } else {
                SVProgressHUD.showErrorWithStatus(error!.localizedFailureReason)
//                SVProgressHUD.showErrorWithStatus(error!.localizedFailureReason, maskType: .None)
            }
            break
        case .ErrorString:
            SVProgressHUD.showErrorWithStatus(status)
//            SVProgressHUD.showErrorWithStatus(status, maskType: .None)
            break
        case .Info:
            SVProgressHUD.showInfoWithStatus(status)
//            SVProgressHUD.showInfoWithStatus(status, maskType: .None)
            break
        case .Loading:
            SVProgressHUD.showWithStatus(status)
//            SVProgressHUD.showWithStatus(status, maskType: .None)
            break
        }
    }
    
    private enum HUDType: Int {
        case Success, ErrorObject, ErrorString, Info, Loading
    }
}
