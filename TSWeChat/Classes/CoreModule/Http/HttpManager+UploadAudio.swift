//
//  HttpManager+UploadAudio.swift
//  TSWeChat
//
//  Created by Hilen on 1/5/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import Alamofire

//上传音频 ,multipartFormData 上传。key = audio

extension HttpManager {
    /**
     音频文件
     
     - parameter audioData: 音频 Data
     - parameter success: 成功回调 audio model
     - parameter failure: 失败
     */
    class func uploadAudio(
        _ audioData: Data,
        recordTime: String,
        success:@escaping (_ audioModel: UploadAudioModel) ->Void,
        failure:@escaping () ->Void)
    {
        let parameters = [
            "access_token": UserInstance.accessToken,
            "record_time": recordTime
        ]
        /*
        这里需要填写上传音频的 API
        */
        let uploadAudioURLString = ""
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(audioData, withName: "audio", fileName: "file", mimeType: "audio/AMR")
                for (key, value) in parameters {
                    multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: uploadAudioURLString,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        log.info("response:\(response)")
                        switch response.result {
                        case .success(let data):
                            /*
                             根据 JSON 返回格式，做好 UploadAudioModel 的 key->value 映射, 这里只是个例子
                             */
                            let model: UploadAudioModel = TSMapper<UploadAudioModel>().map(JSONObject: data)!
                            success(model)
                        case .failure( _):
                            failure()
                        }
                    }
                case .failure(let encodingError):
                    debugPrint(encodingError)
                }
        })
        
    }
}






