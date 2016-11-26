//
//  TSChatShareMoreView.swift
//  TSWeChat
//
//  Created by Hilen on 12/24/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxBlocking
import Dollar

private let kLeftRightPadding: CGFloat = 15.0
private let kTopBottomPadding: CGFloat = 10.0
private let kItemCountOfRow: CGFloat = 4

class TSChatShareMoreView: UIView {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var listCollectionView: UICollectionView! {didSet {
        listCollectionView.scrollsToTop = false
        }}
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: ChatShareMoreViewDelegate?
    internal let disposeBag = DisposeBag()

    fileprivate let itemDataSouce: [(name: String, iconImage: UIImage)] = [
        ("照片", TSAsset.Sharemore_pic.image),
        ("相机", TSAsset.Sharemore_video.image),
        ("小视频", TSAsset.Sharemore_sight.image),
        ("视频聊天", TSAsset.Sharemore_videovoip.image),
        ("红包", TSAsset.Sharemore_wallet.image),  //Where is the lucky money icon!  T.T
        ("转账", TSAsset.SharemorePay.image),
        ("位置", TSAsset.Sharemore_location.image),
        ("收藏", TSAsset.Sharemore_myfav.image),
        ("个人名片", TSAsset.Sharemore_friendcard.image),
        ("语音输入", TSAsset.Sharemore_voiceinput.image),
        ("卡券", TSAsset.Sharemore_wallet.image),
    ]
    fileprivate var groupDataSouce = [[(name: String, iconImage: UIImage)]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.initialize()
    }
    
    func initialize() {
        
    }
    
    override func awakeFromNib() {
        let layout = TSFullyHorizontalFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(
            kTopBottomPadding,
            kLeftRightPadding,
            kTopBottomPadding,
            kLeftRightPadding
        )
        //Calculate the UICollectionViewCell size
        let itemSizeWidth = (UIScreen.ts_width - kLeftRightPadding*2 - layout.minimumLineSpacing*(kItemCountOfRow - 1)) / kItemCountOfRow
        let itemSizeHeight = (self.collectionViewHeightConstraint.constant - kTopBottomPadding*2)/2
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeHeight)
        
        self.listCollectionView.collectionViewLayout = layout
        self.listCollectionView.register(TSChatShareMoreCollectionViewCell.ts_Nib(), forCellWithReuseIdentifier: TSChatShareMoreCollectionViewCell.identifier)
        self.listCollectionView.showsHorizontalScrollIndicator = false
        self.listCollectionView.isPagingEnabled = true
        
        /**
        The section count is come from the groupDataSource, and The pageControl.numberOfPages is equal to the groupDataSouce.count.
        So I cut the itemDataSouce into 2 arrays. And the UICollectionView will has 2 sections.
        And then set the minimumLineSpacing and sectionInset of the flowLayout. The UI will be perfect like WeChat.
        */
        self.groupDataSouce = $.chunk(self.itemDataSouce, size: Int(kItemCountOfRow)*2)
        self.pageControl.numberOfPages = self.groupDataSouce.count
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Fix the width
        self.listCollectionView.width = UIScreen.ts_width
    }

}

// MARK: - @protocol UICollectionViewDelegate
extension TSChatShareMoreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }

        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                delegate.chatShareMoreViewPhotoTaped()
            } else if row == 1 {
                delegate.chatShareMoreViewCameraTaped()
            }
        }
    }
}


// MARK: - @protocol UICollectionViewDataSource
extension TSChatShareMoreView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupDataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let subArray = self.groupDataSouce.get(index: section) else {
            return 0
        }
        return subArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TSChatShareMoreCollectionViewCell.identifier, for: indexPath) as! TSChatShareMoreCollectionViewCell
        guard let subArray = self.groupDataSouce.get(index: indexPath.section) else {
            return TSChatShareMoreCollectionViewCell()
        }
        if let item = subArray.get(index: indexPath.row) {
            cell.itemButton.setImage(item.iconImage, for: .normal)
            cell.itemLabel.text = item.name
        }
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan start")
        
    }
}

// MARK: - @protocol UIScrollViewDelegate
extension TSChatShareMoreView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.listCollectionView.ts_width
        self.pageControl.currentPage = Int(self.listCollectionView.contentOffset.x / pageWidth)
    }
}


 // MARK: - @delgate ChatShareMoreViewDelegate
protocol ChatShareMoreViewDelegate: class {
    /**
     选择相册
     */
    func chatShareMoreViewPhotoTaped()
    
    /**
     选择相机
     */
    func chatShareMoreViewCameraTaped()
}





