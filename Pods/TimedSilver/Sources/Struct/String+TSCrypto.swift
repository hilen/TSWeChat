//
//  String+TSCrypto.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 2/19/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import CommonCrypto

public extension String {
    var ts_MD5String: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
