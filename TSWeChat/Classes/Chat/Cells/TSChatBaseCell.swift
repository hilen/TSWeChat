//
//  TSChatBaseCell.swift
//  TSWeChat
//
//  Created by Hilen on 1/11/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxBlocking

private let kChatNicknameLabelHeight: CGFloat = 20  //昵称 label 的高度
let kChatAvatarMarginLeft: CGFloat = 10             //头像的 margin left
let kChatAvatarMarginTop: CGFloat = 0               //头像的 margin top
let kChatAvatarWidth: CGFloat = 40                  //头像的宽度

class TSChatBaseCell: UITableViewCell {
    weak var delegate: TSChatCellDelegate?

    @IBOutlet weak var avatarImageView: UIImageView! {didSet{
        avatarImageView.backgroundColor = UIColor.clear
        avatarImageView.width = kChatAvatarWidth
        avatarImageView.height = kChatAvatarWidth
    }}
    @IBOutlet weak var nicknameLabel: UILabel! {didSet{
        nicknameLabel.font = UIFont.systemFont(ofSize: 11)
        nicknameLabel.textColor = UIColor.darkGray
        }}
    var model: ChatModel?
    let disposeBag = DisposeBag()

    override func prepareForReuse() {
        self.avatarImageView.image = nil
        self.nicknameLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        //头像点击
        let tap = UITapGestureRecognizer()
        self.avatarImageView.addGestureRecognizer(tap)
        self.avatarImageView.isUserInteractionEnabled = true
        tap.rx.event.subscribe{[weak self ] _ in
            if let strongSelf = self {
                guard let delegate = strongSelf.delegate else {
                    return
                }
                delegate.cellDidTapedAvatarImage(strongSelf)
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    func setCellContent(_ model: ChatModel) {
        self.model = model
        if self.model!.fromMe {
            let avatarURL = "http://ww3.sinaimg.cn/thumbnail/6a011e49jw1f1e87gcr14j20ks0ksdgr.jpg"
            self.avatarImageView.ts_setImageWithURLString(avatarURL, placeholderImage: TSAsset.Icon_avatar.image)
        } else {
            let avatarURL = "http://ww2.sinaimg.cn/large/6a011e49jw1f1j01nj8g6j204f04ft8r.jpg"
            self.avatarImageView.ts_setImageWithURLString(avatarURL, placeholderImage: TSAsset.Icon_avatar.image)
        }
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        guard let model = self.model else {
            return
        }
        if model.fromMe {
            self.nicknameLabel.height = 0
            self.avatarImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth
        } else {
            self.nicknameLabel.height = 0
            self.avatarImageView.left = kChatAvatarMarginLeft
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}




