//
//  TSResponseSerializer.swift
//  TSWeChat
//
//  Created by Hilen on 3/2/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let kKeyMessage      = "message"
private let kKeyData         = "data"
private let kKeyCode         = "code"

// MARK: - SwiftyJSON 和 Alamofire 的自定义解析器
//文件上传的解析，图片和音频
extension Request {
    public func responseFileUploadSwiftyJSON(options options: NSJSONReadingOptions = .AllowFragments, completionHandler: Response<JSON, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.fileUploadSwiftyJSONResponseSerializer(options: options), completionHandler: completionHandler)
    }
    
    public static func fileUploadSwiftyJSONResponseSerializer(options options: NSJSONReadingOptions = .AllowFragments) -> ResponseSerializer<JSON, NSError> {
        return ResponseSerializer { _, _, data, error in
            guard error == nil else {
                log.error("error:\(error)")
                let failureReason = "网络不给力啊，请稍候再试 ：）"
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "数据错误，请稍候再试 ：）"
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            //JSON 解析错误
            let json: JSON = SwiftyJSON.JSON(data: validData)
            if let jsonError = json.error {
                return Result.Failure(jsonError)
            }
            
            //服务器返回 code 错误处理， 假设是 1993
            let code = json[kKeyCode].intValue
            if code == 1993 {
                let error = Error.errorWithCode(code, failureReason: json["message"].stringValue)
                return .Failure(error)
            }
            
            //成功返回
            return Result.Success(json)
        }
    }
}

