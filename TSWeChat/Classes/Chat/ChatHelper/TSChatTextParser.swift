//
//  TSChatTextParser.swift
//  TSWeChat
//
//  Created by Hilen on 1/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import YYText

public let kChatTextKeyPhone = "phone"
public let kChatTextKeyURL = "URL"

class TSChatTextParser: NSObject {
    class func parseText(text: String, font: UIFont) -> NSMutableAttributedString? {
        if text.characters.count == 0 {
            return nil
        }
        
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributedText.yy_font = font
        attributedText.yy_color = UIColor.blackColor()
        
        //匹配电话
        self.enumeratePhoneParser(attributedText)
        //匹配 URL
        self.enumerateURLParser(attributedText)
        //匹配 [表情]
        self.enumerateEmotionParser(attributedText, fontSize: font.pointSize)
        
        return attributedText
    }
    
    /**
     匹配电话
     
     - parameter attributedText: 富文本
     */
    private class func enumeratePhoneParser(attributedText: NSMutableAttributedString) {
        let phonesResults = TSChatTextParseHelper.regexPhoneNumber.matchesInString(
            attributedText.string,
            options: [.ReportProgress],
            range: attributedText.yy_rangeOfAll()
        )
        for phone: NSTextCheckingResult in phonesResults {
            if phone.range.location == NSNotFound && phone.range.length <= 1 {
                continue
            }
            
            let highlightBorder = TSChatTextParseHelper.highlightBorder
            if (attributedText.yy_attribute(YYTextHighlightAttributeName, atIndex: UInt(phone.range.location)) == nil) {
                attributedText.yy_setColor(UIColor(rgba: "#1F79FD"), range: phone.range)
                let highlight = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                
                let stringRange = attributedText.string.RangeFromNSRange(phone.range)!
                highlight.userInfo = [kChatTextKeyPhone : attributedText.string.substringWithRange(stringRange)]
                attributedText.yy_setTextHighlight(highlight, range: phone.range)
            }
        }
    }

    /**
     匹配 URL
     
     - parameter attributedText: 富文本
     */
    private class func enumerateURLParser(attributedText: NSMutableAttributedString) {
        let URLsResults = TSChatTextParseHelper.regexURLs.matchesInString(
            attributedText.string,
            options: [.ReportProgress],
            range: attributedText.yy_rangeOfAll()
        )
        for URL: NSTextCheckingResult in URLsResults {
            if URL.range.location == NSNotFound && URL.range.length <= 1 {
                continue
            }
            
            let highlightBorder = TSChatTextParseHelper.highlightBorder
            if (attributedText.yy_attribute(YYTextHighlightAttributeName, atIndex: UInt(URL.range.location)) == nil) {
                attributedText.yy_setColor(UIColor(rgba: "#1F79FD"), range: URL.range)
                let highlight = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)

                let stringRange = attributedText.string.RangeFromNSRange(URL.range)!
                highlight.userInfo = [kChatTextKeyURL : attributedText.string.substringWithRange(stringRange)]
                attributedText.yy_setTextHighlight(highlight, range: URL.range)
            }
        }
    }
    
    /**
     /匹配 [表情]
     
     - parameter attributedText: 富文本
     - parameter fontSize:       字体大小
     */
    private class func enumerateEmotionParser(attributedText: NSMutableAttributedString, fontSize: CGFloat) {
        let emoticonResults = TSChatTextParseHelper.regexEmotions.matchesInString(
            attributedText.string,
            options: [.ReportProgress],
            range: attributedText.yy_rangeOfAll()
        )
        var emoClipLength: Int = 0
        for emotion: NSTextCheckingResult in emoticonResults {
            if emotion.range.location == NSNotFound && emotion.range.length <= 1 {
                continue
            }
            var range: NSRange  = emotion.range
            range.location -= emoClipLength
            if (attributedText.yy_attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location)) != nil) {
                continue
            }
            if (attributedText.yy_attribute(YYTextAttachmentAttributeName, atIndex: UInt(range.location)) != nil) {
                continue
            }
            
            let imageName = attributedText.string.substringWithRange(attributedText.string.RangeFromNSRange(range)!)
            guard let theImageName = TSEmojiDictionary[imageName] else {
                continue
            }
            
            //QQ 表情的文件名称
            let imageString =  "\(TSConfig.ExpressionBundleName)/\(theImageName)"
            let emojiText = NSMutableAttributedString.yy_attachmentStringWithEmojiImage(UIImage(named: imageString), fontSize: fontSize + 1)
            attributedText.replaceCharactersInRange(range, withAttributedString: emojiText)
            
            emoClipLength += range.length - 1
        }
    }
}


class TSChatTextParseHelper {
    /// 高亮的文字背景色
    class var highlightBorder: YYTextBorder {
        get {
            let highlightBorder = YYTextBorder()
            highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
            highlightBorder.fillColor = UIColor(rgba: "#D4D1D1")
            return highlightBorder
        }
    }
    
    
    /**
     正则：匹配 [哈哈] [笑哭。。] 表情
     */
    class var regexEmotions: NSRegularExpression {
        get {
            let regularExpression = try! NSRegularExpression(pattern: "\\[[^\\[\\]]+?\\]", options: [.CaseInsensitive])
            return regularExpression
        }
    }
    
    /**
     正则：匹配 www.a.com 或者 http://www.a.com 的类型
     
     ref: http://stackoverflow.com/questions/3809401/what-is-a-good-regular-expression-to-match-a-url
     */
    class var regexURLs: NSRegularExpression {
        get {
            let regex: String = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|^[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\\$\\.\\+!\\*\\(\\)/,:;@&=\\?~#%]*)*"
            let regularExpression = try! NSRegularExpression(pattern: regex, options: [.CaseInsensitive])
            return regularExpression
        }
    }
    
    /**
     正则：匹配 7-25 位的数字, 010-62104321, 0373-5957800, 010-62104321-230
     */
    class var regexPhoneNumber: NSRegularExpression {
        get {
            let regex = "([\\d]{7,25}(?!\\d))|((\\d{3,4})-(\\d{7,8}))|((\\d{3,4})-(\\d{7,8})-(\\d{1,4}))"
            let regularExpression = try! NSRegularExpression(pattern: regex, options: [.CaseInsensitive])
            return regularExpression
        }
    }
}


private extension String {
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }
    
    func RangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
}





