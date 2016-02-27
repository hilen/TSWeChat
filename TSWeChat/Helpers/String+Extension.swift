//
//  String+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 1/19/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

extension String {
    func stringHeightWithMaxWidth(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [String : AnyObject] = [
            NSFontAttributeName: font,
        ]
        let size: CGSize = self.boundingRectWithSize(
            CGSize(width: maxWidth, height: CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        return size.height
    }
}


