//
//  TSUploadModel.swift
//  TSWeChat
//
//  Created by Hilen on 3/2/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import ObjectMapper

// 上传图片接口返回的图片 Model
class UploadImageModel : TSModelProtocol {
    var originalURL : String?
    var originalHeight : CGFloat?
    var originalWidth : CGFloat?
    var thumbURL : String?
    var thumbHeight : CGFloat?
    var thumbWidth : CGFloat?
    var imageId : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        originalURL <- map["original_URL"]
        originalHeight <- map["original_height"]
        originalWidth <- map["original_width"]
        imageId <- map["image_Id"]
        thumbURL <- map["thumb_URL"]
        thumbHeight <- map["thumb_height"]
        thumbWidth <- map["thumb_width"]
    }
}


// 上传音频接口返回的图片 Model
class UploadAudioModel : TSModelProtocol {
    var audioId : String?
    var duration : Int?
    var audioURL : String?
    var fileSize : Int?
    var keyHash : String?
    var recordTime : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        audioId <- map["audio_id"]
        audioURL <- map["audio_url"]
        duration <- map["duration"]
        keyHash <- map["key_hash"]
        fileSize <- map["file_size"]
        recordTime <- map["recordTime"]
    }
}
