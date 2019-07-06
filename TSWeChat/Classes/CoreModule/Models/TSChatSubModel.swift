//
//  TSChatModel.swift
//  TSWeChat
//
//  Created by Hilen on 12/9/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import ObjectMapper

/*
* 聊天内的子 model，根据字典返回类型做处理
*/
class ChatAudioModel : NSObject, TSModelProtocol {
    var audioId : String?
    var audioURL : String?
    var bitRate : String?
    var channels : String?
    var createTime : String?
    var duration : Float?
    var fileSize : String?
    var formatName : String?
    var keyHash : String?
    var mimeType : String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        audioId <- map["audio_id"]
        audioURL <- map["audio_url"]
        bitRate <- map["bit_rate"]
        channels <- map["channels"]
        createTime <- map["ctime"]
        duration <- (map["duration"], TransformerStringToFloat)
        fileSize <- map["file_size"]
        formatName <- map["format_name"]
        keyHash <- map["key_hash"]
        mimeType <- map["mime_type"]
    }
}

/*
* 聊天内的子 model，根据字典返回类型做处理
*/
class ChatImageModel : NSObject, TSModelProtocol {
    var imageHeight : CGFloat?
    var imageWidth : CGFloat?
    var imageId : String?
    var originalURL : String?
    var thumbURL : String?
    var localStoreName: String?  //拍照，选择相机的图片的临时名称
    var localThumbnailImage: UIImage? {  //从 Disk 加载出来的图片
        if let theLocalStoreName = localStoreName {
            let path = ImageFilesManager.cachePathForKey(theLocalStoreName)
            return UIImage(contentsOfFile: path!)
        } else {
            return nil
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageHeight <- (map["height"], TransformerStringToCGFloat)
        imageWidth <- (map["width"], TransformerStringToCGFloat)
        originalURL <- map["original_url"]
        thumbURL <- map["thumb_url"]
        imageId <- map["image_id"]
    }
}






