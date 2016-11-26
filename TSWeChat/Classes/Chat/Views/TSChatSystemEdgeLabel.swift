//
//  TSChatEdgeLabel.swift
//  TSWeChat
//
//  Created by Hilen on 1/21/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

final class TSChatEdgeLabel: UILabel {
    var labelEdge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, labelEdge))
    }
}
