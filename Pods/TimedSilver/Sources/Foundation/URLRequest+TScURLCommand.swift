//
//  URLRequest+TScURLCommand.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/10/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

extension URLRequest {
    fileprivate func escapeQuotesInString(_ string: String) -> String {
        assert(string.count > 0 , "Error: String is not valid")
        return string.replacingOccurrences(of: "\"", with:"\\\"", options: NSString.CompareOptions.literal, range: nil)
    }

    /**
    Sample :
     
    let URLString = "https://httpbin.org/get"
    let parameters = [
        "foo":"bar"
    ]
    let request = Alamofire.request(.GET, URLString, parameters: parameters, encoding:.JSON).responseJSON { response in
        switch response.result {
        case .Success(let JSON):
            print("Success with JSON: \(JSON)")
            success!(JSON as! NSDictionary)
        case .Failure(let error):
            print("Request failed with error: \(error)")
            failure!(error)
        }
    }
    print("\n Request cURL command:\(request!.cURLCommandString()) \n")
 
    Step1：curl -k -X POST --dump-header - -H "Accept: application/json" -H "Content-Type: application/json" -d "{ \"password\" : \"pass\", \"username\" : \"test\"}" "http://httpbin.org/post"
     
    Step2: copy the the command and paste it into Terminal.
     
     - returns: cURL command string
     */
    public func cURLCommandString() -> String! {
        let curlString: NSMutableString = NSMutableString(string:"curl -k -X \(self.httpMethod!) --dump-header -")
        
        if let allHTTPHeaderFields: [String : String] = self.allHTTPHeaderFields {
            for key: String in allHTTPHeaderFields.keys {
                let headerKey: String = self.escapeQuotesInString(key)
                let headerValue: String = self.escapeQuotesInString(allHTTPHeaderFields[key]!)
                curlString.appendFormat(" -H \"%@: %@\"", headerKey, headerValue)
            }
        }
        
        if let body: Data = self.httpBody , self.httpBody != nil {
            if var bodyDataString = String(data: body, encoding: String.Encoding.utf8) {
                if bodyDataString.count > 0 {
                    bodyDataString = self.escapeQuotesInString(bodyDataString)
                    curlString.appendFormat(" -d \"%@\"", bodyDataString)
                }
            }
        }
        curlString.appendFormat(" \"%@\"", self.url!.absoluteString)
        
        let trimmed = curlString.replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: CharacterSet.newlines)
        return trimmed as String
    }
}
