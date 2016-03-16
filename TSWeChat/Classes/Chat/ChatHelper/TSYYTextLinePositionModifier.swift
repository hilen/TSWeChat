//
//  TSYYTextLinePositionModifier.swift
//  TSWeChat
//
//  Created by Hilen on 1/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import YYText

private let ascentScale: CGFloat = 0.84
private let descentScale: CGFloat = 0.16

class TSYYTextLinePositionModifier: NSObject, YYTextLinePositionModifier {
    
    internal var font: UIFont // 基准字体 (例如 Heiti SC/PingFang SC)
    private var paddingTop: CGFloat = 2 //文本顶部留白
    private var paddingBottom: CGFloat = 2 //文本底部留白
    private var lineHeightMultiple: CGFloat //行距倍数

    required init(font: UIFont) {
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 9.0 {
            self.lineHeightMultiple = 1.23 // for PingFang SC
        } else {
            self.lineHeightMultiple = 1.1925  // for Heiti SC
        }
        self.font = font
        super.init()
    }
    
    // MARK: - @delegate YYTextLinePositionModifier
    func modifyLines(lines: [YYTextLine], fromText text: NSAttributedString, inContainer container: YYTextContainer) {
        let ascent: CGFloat = self.font.pointSize * ascentScale
        let lineHeight: CGFloat = self.font.pointSize * self.lineHeightMultiple
        for line: YYTextLine in lines {
            var position: CGPoint = line.position
            position.y = self.paddingTop + ascent + CGFloat(line.row) * lineHeight
            line.position = position
        }
    }
    
    // MARK: - @delegate NSCopying
    func copyWithZone(zone: NSZone) -> AnyObject {
        let one = self.dynamicType.init(font: self.font)
        return one
    }
    
    func heightForLineCount(lineCount: Int) -> CGFloat {
        if lineCount == 0 {
            return 0
        }
        
        let ascent: CGFloat = self.font.pointSize * ascentScale;
        let descent: CGFloat = self.font.pointSize * descentScale
        let lineHeight: CGFloat = self.font.pointSize * self.lineHeightMultiple
        return self.paddingTop + self.paddingBottom + ascent + descent + CGFloat((lineCount - 1)) * lineHeight;
    }
    
}






