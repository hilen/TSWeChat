//
//  ImageFilesManager.swift
//  TSWeChat
//
//  Created by Hilen on 2/24/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import Kingfisher

/*
    围绕 Kingfisher 构建的缓存器，先预存图片名称，等待上传完毕后改成 URL 的名字。
    https://github.com/onevcat/Kingfisher/blob/master/Sources%2FImageCache.swift#l625
*/

class ImageFilesManager {
    let imageCacheFolder = KingfisherManager.sharedManager.cache
    
    class func cachePathForKey(key: String) -> String? {
        let fileName = key.MD5String
        return (KingfisherManager.sharedManager.cache.diskCachePath as NSString).stringByAppendingPathComponent(fileName)
    }
    
    class func storeImage(image: UIImage, key: String, completionHandler: (() -> ())?) {
        KingfisherManager.sharedManager.cache.removeImageForKey(key)
        KingfisherManager.sharedManager.cache.storeImage(image, forKey: key, toDisk: true, completionHandler: completionHandler)
    }
    
    /**
     修改文件名称
     
     - parameter originPath:      原路径
     - parameter destinationPath: 目标路径
     
     - returns: 目标路径
     */
    class func renameFile(originPath: NSURL, destinationPath: NSURL) -> Bool {
        do {
            try NSFileManager.defaultManager().moveItemAtPath(originPath.path!, toPath: destinationPath.path!)
            return true
        } catch let error as NSError {
            log.error("error:\(error)")
            return false
        }
    }
}





