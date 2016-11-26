//
//  TSResponseSerializer.swift
//  TSWeChat
//
//  Created by Hilen on 3/2/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Alamofire
import SwiftyJSON

private let kKeyMessage      = "message"
private let kKeyData         = "data"
private let kKeyCode         = "code"

// MARK: - SwiftyJSON 和 Alamofire 的自定义解析器
//文件上传的解析，图片和音频
extension Alamofire.DataRequest {
    @discardableResult
//    static func responseFileUploadSwiftyJSON(completionHandler: (Alamofire.Result) -> Void) -> Self {
//        return response(responseSerializer: DataRequest.fileUploadSwiftyJSONResponseSerializer(), completionHandler)
////        return response(responseSerializer: <#T##T#>, completionHandler: <#T##(DataResponse<T.SerializedObject>) -> Void#>)
//    }
    
    static func fileUploadSwiftyJSONResponseSerializer() -> DataResponseSerializer<Any> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                log.error("error:\(error)")
                let failureReason = "网络不给力，请稍候再试 ：）"
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "", code: 1002, userInfo: userInfo)
                return .failure(error)
            }
            
            guard let validData = data, validData.count > 0 else {
                let failureReason = "数据错误，请稍候再试 ：）"
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "", code: 1003, userInfo: userInfo)
                return .failure(error)
            }
            
            //JSON 解析错误
            let json: JSON = SwiftyJSON.JSON(data: validData)
            if let jsonError = json.error {
                return Result.failure(jsonError)
            }
            
            //服务器返回 code 错误处理， 假设是 1993
            let code = json[kKeyCode].intValue
            if code == 1993 {
                let userInfo = [NSLocalizedFailureReasonErrorKey: json["message"].stringValue]
                let error = NSError(domain: "", code: 1004, userInfo: userInfo)
                return .failure(error)
            }
            
            return Result.success(json)
        }
    }
}

