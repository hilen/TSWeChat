//
//  TSUserManager.swift
//  TSWeChat
//
//  Created by Hilen on 11/6/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON

let UserInstance = UserManager.sharedInstance

private let kNickname    = "kTS_wechat_username"
private let kAvatar      = "kTS_wechat_avatar"
private let kAccessToken = "kTS_wechat_accessToken"
private let kUserId      = "kTS_wechat_userId"
private let kIsLogin     = "kTS_wechat_isLogin"
private let kLoginName   = "kTS_wechat_loginName"
private let kPassword    = "kTS_wechat_password"

class UserManager: NSObject {
    class var sharedInstance : UserManager {
        struct Static {
            static let instance : UserManager = UserManager()
        }
        return Static.instance
    }
    
    let TSKeychain = Keychain(service: "com.wechat.Hilen") //keychain
    var accessToken: String? {
        get { return UserDefaults.ts_stringForKey(kAccessToken, defaultValue: "这是我的 AccessToken") }
        set (newValue) { UserDefaults.ts_setString(kAccessToken, value: newValue) }
    }
    /// 用户昵称，不是登录名
    var nickname: String? {
        get { return UserDefaults.ts_stringForKey(kNickname, defaultValue: "") }
        set (newValue) { UserDefaults.ts_setString(kNickname, value: newValue) }
    }
    var avatar: String?
    var userId: String? {
        get { return UserDefaults.ts_stringForKey(kUserId, defaultValue: TSConfig.testUserID) }
        set (newValue) { UserDefaults.ts_setString(kUserId, value: newValue) }
    }
    var isLogin: Bool {
        get { return UserDefaults.ts_boolForKey(kIsLogin, defaultValue: false) }
        set (newValue) { UserDefaults.ts_setBool(kIsLogin, value: newValue) }
    }
    
    /// 用户手机号 ,存在 keychain
    var loginName: String? {
        get { return  TSKeychain[kLoginName] ?? "" }
        set (newValue) { TSKeychain[kLoginName] = newValue }
    }
    
    ///密码, 存在 keychain
    var password: String?  {
        get { return  TSKeychain[kPassword] ?? "" }
        set (newValue) { TSKeychain[kPassword] = newValue }
    }

    fileprivate override init() {
        super.init()
    }
    
    func readAllData() {
        self.nickname = UserDefaults.ts_stringForKey(kNickname, defaultValue: "")
        self.avatar = UserDefaults.ts_stringForKey(kAvatar, defaultValue: "")
        self.userId = UserDefaults.ts_stringForKey(kUserId, defaultValue: "")
        self.isLogin = UserDefaults.ts_boolForKey(kIsLogin, defaultValue: false)
        self.loginName = TSKeychain[kLoginName] ?? ""
        self.password = TSKeychain[kPassword] ?? ""
    }
    
    /**
     登录成功
     - parameter result: 登录成功后传进来的字典
     */
    func userLoginSuccess(_ result: JSON) {
        self.loginName = result["username"].stringValue
        self.password = result["password"].stringValue
        self.nickname = result["nickname"].stringValue
        self.userId = result["user_id"].stringValue
        self.isLogin = true
    }
    
    /**
     退出登录
     */
    func userLogout() {
        self.accessToken = ""
        self.loginName = ""
        self.password = ""
        self.nickname = ""
        self.userId = ""
        self.isLogin = false
    }
    
    func resetAccessToken(_ token: String) {
        UserDefaults.ts_setString(kAccessToken, value: token)
        if token.count > 0 {
            print("token success")
        } else {
            self.userLogout()
        }
    }
}

