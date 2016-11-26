//
//  PHAsset+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 2/25/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    func getUIImage() -> UIImage? {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact

        var image: UIImage?
        manager.requestImage(
            for: self,
            targetSize: CGSize(width: CGFloat(self.pixelWidth), height: CGFloat(self.pixelHeight)),
            contentMode: .aspectFill,
            options: options,
            resultHandler: {(result, info)->Void in
                if let theResult = result {
                    image = theResult
                } else {
                    image = nil
                }
        })
        return image
    }
    
}
