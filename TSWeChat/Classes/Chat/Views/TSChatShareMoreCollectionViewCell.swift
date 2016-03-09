//
//  TSChatShareMoreCollectionViewCell.swift
//  TSWeChat
//
//  Created by Hilen on 12/30/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit

class TSChatShareMoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    override var highlighted: Bool { didSet {
        if self.highlighted {
            self.itemButton.setBackgroundImage(TSAsset.Sharemore_other_HL.image, forState: .Highlighted)
        } else {
            self.itemButton.setBackgroundImage(TSAsset.Sharemore_other.image, forState: .Normal)
        }
    }}

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = UIColor.redColor()
        // Initialization code
    }

}
