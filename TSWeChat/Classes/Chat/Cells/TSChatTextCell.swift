//
//  TSChatTextView.swift
//  TSWeChat
//
//  Created by Hilen on 12/22/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import YYText

let kChatTextLeft: CGFloat = 72                                         //消息在左边的时候， 文字距离屏幕左边的距离
let kChatTextMaxWidth: CGFloat = UIScreen.ts_width - kChatTextLeft - 82    //消息在右边， 70：文本离屏幕左的距离，  82：文本离屏幕右的距离
let kChatTextMarginTop: CGFloat = 12                                    //文字的顶部和气泡顶部相差 12 像素
let kChatTextMarginBottom: CGFloat = 11                                 //文字的底部和气泡底部相差 11 像素
let kChatTextMarginLeft: CGFloat = 17                                   //文字的左边 和气泡的左边相差 17 ,包括剪头部门
let kChatBubbleWidthBuffer: CGFloat = kChatTextMarginLeft*2             //气泡比文字的宽度多出的值
let kChatBubbleBottomTransparentHeight: CGFloat = 11                    //气泡底部的透明高度 11
let kChatBubbleHeightBuffer: CGFloat = kChatTextMarginTop + kChatTextMarginBottom  //文字的顶部 + 文字底部距离
let kChatBubbleImageViewHeight: CGFloat = 54                            //气泡最小高 54 ，防止拉伸图片变形
let kChatBubbleImageViewWidth: CGFloat = 50                             //气泡最小宽 50 ，防止拉伸图片变形
let kChatBubblePaddingTop: CGFloat = 3                                  //气泡顶端有大约 3 像素的透明部分，需要和头像持平
let kChatBubbleMaginLeft: CGFloat = 5                                   //气泡和头像的 gap 值：5
let kChatBubblePaddingBottom: CGFloat = 8                               //气泡距离底部分割线 gap 值：8
let kChatBubbleLeft: CGFloat = kChatAvatarMarginLeft + kChatAvatarWidth + kChatBubbleMaginLeft  //气泡距离屏幕左的距
private let kChatTextFont: UIFont = UIFont.systemFont(ofSize: 16)

class TSChatTextCell: TSChatBaseCell {
    @IBOutlet weak var contentLabel: YYLabel! {didSet{
        contentLabel.font = kChatTextFont
//        contentLabel.debugOption = self.debugYYLabel()
        contentLabel.numberOfLines = 0
        contentLabel.backgroundColor = UIColor.clear
        contentLabel.textVerticalAlignment = YYTextVerticalAlignment.top
        contentLabel.displaysAsynchronously = false
        contentLabel.ignoreCommonProperties = true
        contentLabel.highlightTapAction = ({[weak self] containerView, text, range, rect in
            self!.didTapRichLabelText(self!.contentLabel, textRange: range)
        })
    }}
    @IBOutlet weak var bubbleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func debugYYLabel() -> YYTextDebugOption {
        let debugOptions = YYTextDebugOption()
        debugOptions.baselineColor = UIColor.red;
        debugOptions.ctFrameBorderColor = UIColor.red;
        debugOptions.ctLineFillColor = UIColor ( red: 0.0, green: 0.463, blue: 1.0, alpha: 0.18 )
        debugOptions.cgGlyphBorderColor = UIColor ( red: 0.9971, green: 0.6738, blue: 1.0, alpha: 0.360964912280702 )
        return debugOptions
    }
    
    override func setCellContent(_ model: ChatModel) {
        super.setCellContent(model)
        if let richTextLinePositionModifier = model.richTextLinePositionModifier {
            self.contentLabel.linePositionModifier = richTextLinePositionModifier
        }
        
        if let richTextLayout = model.richTextLayout {
            self.contentLabel.textLayout = richTextLayout
        }
        
        if let richTextAttributedString = model.richTextAttributedString {
            self.contentLabel.attributedText = richTextAttributedString
        }

        //拉伸图片区域
        let stretchImage = model.fromMe ? TSAsset.SenderTextNodeBkg.image : TSAsset.ReceiverTextNodeBkg.image
        let bubbleImage = stretchImage.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        self.bubbleImageView.image = bubbleImage;
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        
        self.contentLabel.size = model.richTextLayout!.textBoundingSize
        
        if model.fromMe {
            //value = 屏幕宽 - 头像的边距10 - 头像宽 - 气泡距离头像的 gap 值 - (文字宽 - 2倍的文字和气泡的左右距离 , 或者是最小的气泡图片距离)
            self.bubbleImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - max(self.contentLabel.width + kChatBubbleWidthBuffer, kChatBubbleImageViewWidth)
        } else {
            //value = 距离屏幕左边的距离
            self.bubbleImageView.left = kChatBubbleLeft
        }
        //设置气泡的宽
        self.bubbleImageView.width = max(self.contentLabel.width + kChatBubbleWidthBuffer, kChatBubbleImageViewWidth)
        //设置气泡的高度
        self.bubbleImageView.height = max(self.contentLabel.height + kChatBubbleHeightBuffer + kChatBubbleBottomTransparentHeight, kChatBubbleImageViewHeight)
        //value = 头像的底部 - 气泡透明间隔值
        self.bubbleImageView.top = self.nicknameLabel.bottom - kChatBubblePaddingTop
        //valeu = 气泡顶部 + 文字和气泡的差值
        self.contentLabel.top = self.bubbleImageView.top + kChatTextMarginTop
        //valeu = 气泡左边 + 文字和气泡的差值
        self.contentLabel.left = self.bubbleImageView.left + kChatTextMarginLeft
    }
    
    class func layoutHeight(_ model: ChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        //解析富文本
        let attributedString = TSChatTextParser.parseText(model.messageContent!, font: kChatTextFont)!
        model.richTextAttributedString = attributedString

        //初始化排版布局对象
        let modifier = TSYYTextLinePositionModifier(font: kChatTextFont)
        model.richTextLinePositionModifier = modifier
        
        //初始化 YYTextContainer
        let textContainer: YYTextContainer = YYTextContainer()
        textContainer.size = CGSize(width: kChatTextMaxWidth, height: CGFloat.greatestFiniteMagnitude)
        textContainer.linePositionModifier = modifier
        textContainer.maximumNumberOfRows = 0

        //设置 layout
        let textLayout = YYTextLayout(container: textContainer, text: attributedString)
        model.richTextLayout = textLayout
        
        //计算高度
        var height: CGFloat = kChatAvatarMarginTop + kChatBubblePaddingBottom
        let stringHeight = modifier.heightForLineCount(Int(textLayout!.rowCount))

        height += max(stringHeight + kChatBubbleHeightBuffer + kChatBubbleBottomTransparentHeight, kChatBubbleImageViewHeight)
        model.cellHeight = height
        return model.cellHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    /**
     解析点击文字
     
     - parameter label:     YYLabel
     - parameter textRange: 高亮文字的 NSRange，不是 range
     */
    fileprivate func didTapRichLabelText(_ label: YYLabel, textRange: NSRange) {
        //解析 userinfo 的文字
        let attributedString = label.textLayout!.text
        if textRange.location >= attributedString.length {
            return
        }
        guard let hightlight: YYTextHighlight = attributedString.yy_attribute(YYTextHighlightAttributeName, at: UInt(textRange.location)) as? YYTextHighlight else {
            return
        }
        guard let info = hightlight.userInfo, info.count > 0 else {
            return
        }
        
        guard let delegate = self.delegate else {
            return
        }
        
        if let phone: String = info[kChatTextKeyPhone] as? String {
            delegate.cellDidTapedPhone(self, phoneString: phone)
        }
        
        if let URL: String = info[kChatTextKeyURL] as? String {
            delegate.cellDidTapedLink(self, linkString: URL)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
