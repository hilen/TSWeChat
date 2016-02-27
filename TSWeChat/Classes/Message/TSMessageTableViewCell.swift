//
//  TSMessageTableViewCell.swift
//  TSWeChat
//
//  Created by Hilen on 12/9/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit

class TSMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var unreadNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2 / 180 * 30
        
        self.unreadNumberLabel.layer.masksToBounds = true
        self.unreadNumberLabel.layer.cornerRadius = self.unreadNumberLabel.height / 2.0
    }

    func setCellContnet(model: MessageModel) {
        self.avatarImageView.ts_setImageWithURLString(model.middleImageURL, placeholderImage: model.messageFromType.placeHolderImage)
        self.unreadNumberLabel.text = model.unreadNumber > 99 ? "99+" : String(model.unreadNumber!)
        self.unreadNumberLabel.hidden = (model.unreadNumber == 0)
        self.lastMessageLabel.text = model.lastMessage!
        self.dateLabel.text = model.dateString!
        self.nameLabel.text = model.nickname!
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


