//
//  TSUIImageVIew+WeChat.swift
//  TSWeChat
//
//  Created by Hilen on 11/6/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

/*
    对图片加载进行一次封装，现在使用 Kingfisher
*/

import Foundation
import Kingfisher


public extension UIImageView {
    //原始图
    func ts_setImageWithURLString(URLString: String?, placeholderImage placeholder: UIImage? = nil) {
        guard let URLString = URLString, URL = NSURL(string: URLString) else {
            print("URL wrong")
            return
        }
        self.kf_setImageWithURL(URL, placeholderImage: placeholder)
    }
    
    /**
     圆角图
     */
    func ts_setCircularImageWithURLString(URLString: String?, placeholderImage placeholder: UIImage? = nil) {
        self.ts_setRoundImageWithURLString(
            URLString,
            placeholderImage: placeholder,
            cornerRadiusRatio: self.width / 2
        )
    }
    
    /**
     设置 cornerRadiusRatio
     */
    func ts_setCornerRadiusImageWithURLString(
        URLString: String?,
        placeholderImage placeholder: UIImage? = nil ,
        cornerRadiusRatio: CGFloat? = nil)
    {
        self.ts_setRoundImageWithURLString(
            URLString,
            placeholderImage: placeholder,
            cornerRadiusRatio: cornerRadiusRatio
        )
    }
    
    func ts_setRoundImageWithURLString(
        URLString: String?,
        placeholderImage placeholder: UIImage? = nil ,
        cornerRadiusRatio: CGFloat? = nil,
        progressBlock: ImageDownloaderProgressBlock? = nil)
    {
        guard let URLString = URLString, URL = NSURL(string: URLString) else {
            print("URL wrong")
            return
        }
        
        let memoryImage = KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(URLString)
        let diskImage = KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(URLString)
        guard let image = memoryImage ?? diskImage else {
            let optionInfo: KingfisherOptionsInfo = [
                .ForceRefresh,
            ]
            KingfisherManager.sharedManager.downloader.downloadImageWithURL(URL, options: optionInfo, progressBlock: progressBlock) { (image, error, imageURL, originalData) -> () in
                if let image = image, originalData = originalData {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let roundedImage = image.roundWithCornerRadius(image.size.width * (cornerRadiusRatio ?? 0.5))
                        KingfisherManager.sharedManager.cache.storeImage(roundedImage, originalData: originalData, forKey: URLString, toDisk: true, completionHandler: {
                            self.ts_setImageWithURLString(URLString)
                        })
                    }
                }
            }
            return
        }
        self.image = image
    }
}


// MARK: - @extension UIImageView
/*
*   专门为了聊天里面设置头像而获取，聊天里面的数据没有用户头像，昵称，部门名称等信息。单独获取一次，并且缓存。
*
*/
extension UIImageView {
    /**
     根据聊天 id，设置用户头像, 并且返回用户 ContactModel
     
     - parameter ChatId:      聊天的 ID，（uid）
     - parameter placeholder: 占位图
     - parameter modelBlock:  返回 ContactModel ，设置昵称，部门的时候用
     */
//    func ts_setImageWithUserId(userId: String, placeholderImage placeholder: UIImage? = nil, modelBlock:(model: ContactModel) ->Void) {
//        //从缓存获取
//        if let model = CacheInstance.selectUserByUserId(userId) {
//            self.ts_setImageWithURLString(model.avatarSmallURL! , placeholderImage: placeholder)
//            modelBlock(model: model)
//        } else {
//            //没有则请求
//            HttpManager.getPersonInfo(["sid":userId], success: { [weak self] model in
//                if let newModel = model {
//                    CacheInstance.createUserFromContactModel(newModel)
//                    if (self == nil) {
//                        return
//                    }
//                    modelBlock(model: newModel)
//                    self!.ts_setCornerRadiusImageWithURLString(
//                        newModel.avatarSmallURL!,
//                        placeholderImage: placeholder,
//                        cornerRadiusRatio: self!.width / 2 / 180 * 30
//                    )
//                }
//                }, failure: {error in
//            })
//        }
//    }
}





