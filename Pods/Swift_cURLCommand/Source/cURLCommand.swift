//
//  NSURLRequest+cURL.swift
//  NSURLRequest_cURL
//
//  Created by Hilen on 12/11/15.
//  Copyright © 2015 Hilen. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation

extension NSURLRequest {
    private func escapeQuotesInString(string: String) -> String {
        assert(string.characters.count > 0 , "Error: String is not valid")
        return string.stringByReplacingOccurrencesOfString("\"", withString:"\\\"", options: NSStringCompareOptions.LiteralSearch, range: nil)

    }

    public func cURLCommandString() -> String! {
        let curlString: NSMutableString = NSMutableString(string:"curl -k -X \(self.HTTPMethod!) --dump-header -")

        if let allHTTPHeaderFields: [String : String] = self.allHTTPHeaderFields {
            for key: String in allHTTPHeaderFields.keys {
                let headerKey: String = self.escapeQuotesInString(key)
                let headerValue: String = self.escapeQuotesInString(allHTTPHeaderFields[key]!)
                curlString.appendFormat(" -H \"%@: %@\"", headerKey, headerValue)
            }
        }

        if let body: NSData = self.HTTPBody where self.HTTPBody != nil {
            if var bodyDataString = String(data: body, encoding: NSUTF8StringEncoding) {
                if bodyDataString.characters.count > 0 {
                    bodyDataString = self.escapeQuotesInString(bodyDataString)
                    curlString.appendFormat(" -d \"%@\"", bodyDataString)
                }
            }
        }
        curlString.appendFormat(" \"%@\"", self.URL!.absoluteString)

        let trimmed = curlString.stringByReplacingOccurrencesOfString("\n", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return trimmed as String
    }
}


