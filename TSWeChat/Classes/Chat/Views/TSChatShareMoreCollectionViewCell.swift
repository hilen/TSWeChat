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
    override var isHighlighted: Bool { didSet {
        if self.isHighlighted {
            self.itemButton.setBackgroundImage(TSAsset.Sharemore_other_HL.image, for: .highlighted)
        } else {
            self.itemButton.setBackgroundImage(TSAsset.Sharemore_other.image, for: UIControlState())
        }
    }}

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = UIColor.redColor()
        // Initialization code
    }

}
