//
//  TSMeAvatarTableViewCell.swift
//  TSWeChat
//
//  Created by Hilen on 2/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

class TSMeAvatarTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var wechatIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2 / 180 * 30
        self.avatarImageView.layer.borderWidth = 0.5
        self.avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
