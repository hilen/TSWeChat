//
//  TSChatImageCell.swift
//  TSWeChat
//
//  Created by Hilen on 12/22/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

let kChatImageMaxWidth: CGFloat = 125 //最大的图片宽度
let kChatImageMinWidth: CGFloat = 50 //最小的图片宽度
let kChatImageMaxHeight: CGFloat = 150 //最大的图片高度
let kChatImageMinHeight: CGFloat = 50 //最小的图片高度

class TSChatImageCell: TSChatBaseCell {
    
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //图片点击
        let tap = UITapGestureRecognizer()
        self.chatImageView.addGestureRecognizer(tap)
        self.chatImageView.isUserInteractionEnabled = true
        tap.rx.event.subscribe {[weak self] _ in
            if let strongSelf = self {
                guard let delegate = strongSelf.delegate else {
                    return
                }
                delegate.cellDidTapedImageView(strongSelf)
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    override func setCellContent(_ model: ChatModel) {
        super.setCellContent(model)
        if let localThumbnailImage = model.imageModel!.localThumbnailImage {
            self.chatImageView.image = localThumbnailImage
        } else {
            self.chatImageView.ts_setImageWithURLString(model.imageModel!.thumbURL)
        }
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        
        guard let imageModel = model.imageModel else {
            return
        }
        
        var imageOriginalWidth = kChatImageMinWidth  //默认临时加上最小的值
        var imageOriginalHeight = kChatImageMinHeight   //默认临时加上最小的值
        
        if (imageModel.imageWidth != nil) {
            imageOriginalWidth = imageModel.imageWidth!
        }
        
        if (imageModel.imageHeight != nil) {
            imageOriginalHeight = imageModel.imageHeight!
        }
        
        //根据原图尺寸等比获取缩略图的 size
        let originalSize = CGSize(width: imageOriginalWidth, height: imageOriginalHeight)
        self.chatImageView.size = ChatConfig.getThumbImageSize(originalSize)
        
        if model.fromMe {
            //value = 屏幕宽 - 头像的边距10 - 头像宽 - 气泡距离头像的 gap 值 - 图片宽
            self.chatImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - self.chatImageView.width
        } else {
            //value = 距离屏幕左边的距离
            self.chatImageView.left = kChatBubbleLeft
        }
        
        self.chatImageView.top = self.avatarImageView.top
        
        /**
         *  绘制 imageView 的 bubble layer
         */
        let stretchInsets = UIEdgeInsetsMake(30, 28, 23, 28)
        let stretchImage = model.fromMe ? TSAsset.SenderImageNodeMask.image : TSAsset.ReceiverImageNodeMask.image
        let bubbleMaskImage = stretchImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        
        //设置图片的 mask layer
        let layer = CALayer()
        layer.contents = bubbleMaskImage.cgImage
        layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        layer.frame = CGRect(x: 0, y: 0, width: self.chatImageView.width, height: self.chatImageView.height)
        layer.contentsScale = UIScreen.main.scale
        layer.opacity = 1
        self.chatImageView.layer.mask = layer
        self.chatImageView.layer.masksToBounds = true
        
        /**
         绘制 coverImage，盖住图片
         */
        let stretchConverImage = model.fromMe ? TSAsset.SenderImageNodeBorder.image : TSAsset.ReceiverImageNodeBorder.image
        let bubbleConverImage = stretchConverImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        self.coverImageView.image = bubbleConverImage
        self.coverImageView.frame = CGRect(
            x: self.chatImageView.left - 1,
            y: self.chatImageView.top,
            width: self.chatImageView.width + 2,
            height: self.chatImageView.height + 2
        )
    }
    
    class func layoutHeight(_ model: ChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        guard let imageModel = model.imageModel else {
            return 0
        }
        
        var height = kChatAvatarMarginTop + kChatBubblePaddingBottom
        
        let imageOriginalWidth = imageModel.imageWidth!
        let imageOriginalHeight = imageModel.imageHeight!
        
        /**
        *  1）如果图片的高度 >= 图片的宽度 , 高度就是最大的高度，宽度等比
        *  2）如果图片的高度 < 图片的宽度 , 以宽度来做等比，算出高度
        */
        if imageOriginalHeight >= imageOriginalWidth {
            height += kChatImageMaxHeight
        } else {
            let scaleHeight = imageOriginalHeight * kChatImageMaxWidth / imageOriginalWidth
            height += (scaleHeight > kChatImageMinHeight) ? scaleHeight : kChatImageMinHeight
        }
        height += 12  // 图片距离底部的距离 12
        
        model.cellHeight = height
        return model.cellHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    func CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect {
        return CGRect(
            x: image.capInsets.left / image.size.width,
            y: image.capInsets.top / image.size.height,
            width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
    
    func _maskImage(_ image: UIImage, maskImage: UIImage) -> UIImage {
        let maskRef: CGImage = maskImage.cgImage!
        let mask: CGImage = CGImage(
            maskWidth: maskRef.width,
            height: maskRef.height,
            bitsPerComponent: maskRef.bitsPerComponent,
            bitsPerPixel: maskRef.bitsPerPixel,
            bytesPerRow: maskRef.bytesPerRow,
            provider: maskRef.dataProvider!,
            decode: nil,
            shouldInterpolate: false
        )!
        let maskedImageRef: CGImage = (image.cgImage)!.masking(mask)!
        let maskedImage: UIImage = UIImage(cgImage:maskedImageRef)
        // returns new image with mask applied
        return maskedImage
    }
}


