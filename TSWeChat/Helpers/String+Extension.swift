//
//  String+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 1/19/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

extension String {
    func stringHeightWithMaxWidth(_ maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [String : AnyObject] = [
            NSFontAttributeName: font,
        ]
        let size: CGSize = self.boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        return size.height
    }
}


