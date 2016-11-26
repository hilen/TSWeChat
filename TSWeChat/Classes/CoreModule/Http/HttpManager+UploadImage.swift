//
//  HttpManager+UploadImage.swift
//  TSWeChat
//
//  Created by Hilen on 11/27/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import Alamofire

//上传图片 ,multipartFormData 上传。key = attach

extension HttpManager {
    /**
    上传单张图片
    
    - parameter image:   UIImage
    - parameter success: 成功回调图片 model
    - parameter failure: 失败
    */
    class func uploadSingleImage(
        _ image:UIImage,
        success:@escaping (_ imageModel: UploadImageModel) ->Void,
        failure:@escaping (Void) ->Void)
    {
        let parameters = [
            "access_token": UserInstance.accessToken
        ]
        
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        /*
        这里需要填写上传图片的 API
        */
        let uploadIImageURLString = ""
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if imageData != nil {
                    multipartFormData.append(imageData!, withName: "attach", fileName: "file", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: uploadIImageURLString,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseFileUploadSwiftyJSON(completionHandler: { response in
                        switch response.result {
                        case .Success(let data):
                            /*
                             根据 JSON 返回格式，做好 UploadImageModel 的 key->value 映射, 这里只是个例子
                             */
                            let model: UploadImageModel = TSMapper<UploadImageModel>().map(data.dictionaryObject)!
                            success(imageModel: model)
                        case .Failure( _):
                            failure()
                        }
                    })
                case .failure(let encodingError):
                    debugPrint(encodingError)
                }
        })
    }
    
    /**
    上传多张图片
    
    - parameter imagesArray: 图片数组
    - parameter success:     返回图片数组 model,和图片逗号分割的字符串 "123123,23344,590202"
    - parameter failure:     失败
    */
    class func uploadMultipleImages(
        _ imagesArray:[UIImage],
        success:@escaping (_ imageModel: [UploadImageModel], _ imagesId: String) ->Void,
        failure:@escaping (Void) ->Void)
    {
        guard imagesArray.count != 0 else {
            assert(imagesArray.count == 0, "Invalid images array") // here
            failure()
            return
        }
        
        for image in imagesArray {
            guard image.isKind(of: UIImage.self) else {
                failure()
                return
            }
        }

        
        let resultImageIdArray = NSMutableArray()
        let resultImageModelArray = NSMutableArray()

        let emtpyId = ""
        for _ in 0..<imagesArray.count {
            resultImageIdArray.add(emtpyId)
        }
        
        let group = DispatchGroup()
        var index = 0
        for (image) in imagesArray {
            group.enter();
            self.uploadSingleImage(
                image,
                success: {model in
                    let imageId = model.imageId
                    resultImageIdArray.replaceObject(at: index, with: imageId!)
                    resultImageModelArray.add(model)
                    group.leave();
                },
                failure: {
                    group.leave();
                }
            )
            index += 1
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            let checkIds = resultImageIdArray as NSArray as! [String]
            for imageId: String in checkIds {
                if imageId == emtpyId {
                    failure()
                    return
                }
            }
            
            let ids = resultImageIdArray.componentsJoined(by: ",")
            let images = resultImageModelArray as NSArray as! [UploadImageModel]
            success(images, ids)
        })
    }
}




