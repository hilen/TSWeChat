//
//  TSContactModel.swift
//  TSWeChat
//
//  Created by Hilen on 2/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import ObjectMapper

/// 联系人列表的 model
@objc class ContactModel: NSObject, TSModelProtocol {
    var avatarSmallURL : String?   //头像小图
    var chineseName : String? //中文名称
    var nameSpell : String?   //中文名称拼音
    var phone : String?
    var userId : String?
    
    required init?(map: Map) {
        
    }
    
    override init() {
        super.init()
    }
    
    func mapping(map: Map) {
        avatarSmallURL <- map["avatar_url"]
        chineseName <- map["name"]
        nameSpell <- map["name_spell"]
        phone <- map["phone"]
        userId <- map["userid"]
    }
    
    func compareContact(_ contactModel: ContactModel) -> ComparisonResult {
        let result = self.nameSpell?.compare(contactModel.nameSpell!)
        return result!
    }
}



//通讯录模拟出来的数据
enum ContactModelEnum: Int {
    case newFriends = 0
    case publicAccout
    case groupChat
    case tags
    
    var model: ContactModel {
        let model = ContactModel()
        switch (self) {
        case .groupChat:
            model.chineseName = "群聊"
            model.avatarSmallURL = "http://ww1.sinaimg.cn/large/6a011e49jw1f18hercci7j2030030glf.jpg"
            return model
        case .publicAccout:
            model.chineseName = "公众号"
            model.avatarSmallURL = "http://ww2.sinaimg.cn/large/6a011e49jw1f18hkv6i5kj20300303yb.jpg"
            return model
        case .newFriends:
            model.chineseName = "新的朋友"
            model.avatarSmallURL = "http://ww4.sinaimg.cn/large/6a011e49jw1f18hftp0foj2030030dfn.jpg"
            return model
        case .tags:
            model.chineseName = "标签"
            model.avatarSmallURL = "http://ww2.sinaimg.cn/large/6a011e49jw1f18hh48jr3j2030030743.jpg"
            return model
        }
    }
}



