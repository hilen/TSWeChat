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

private let leftAndRightGap: CGFloat = 12.0
private let topAndBottomGap: CGFloat = 10.0
private let itemWidth: CGFloat = 65.0
private let itemHeight: CGFloat = 93.0
private let itemCount: CGFloat = 4

class TSChatShareMoreView: UIView {
    @IBOutlet weak var listCollectionView: UICollectionView! {didSet {
        listCollectionView.scrollsToTop = false
        }}
    weak var delegate: ChatShareMoreViewDelegate?
    internal let disposeBag = DisposeBag()

    private let itemDataSouce: [(name: String, iconImage: UIImage)] = [
        ("照片", TSAsset.Sharemore_pic.image),
        ("相机", TSAsset.Sharemore_camera.image),
        ("小视频", TSAsset.Sharemore_sight.image),
        ("视频聊天", TSAsset.Sharemore_videovoip.image),
        ("转账", TSAsset.Sharemore_pay.image),
        ("位置", TSAsset.Sharemore_location.image),
        ("收藏", TSAsset.Sharemore_myfav.image),
    ]
    
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let width = (UIScreen.width - leftAndRightGap*2) / itemCount
        layout.itemSize = CGSizeMake(width, itemHeight)
        layout.sectionInset = UIEdgeInsetsMake(topAndBottomGap, leftAndRightGap, topAndBottomGap, leftAndRightGap)
        
        self.listCollectionView.collectionViewLayout = layout
        self.listCollectionView.registerNib(TSChatShareMoreCollectionViewCell.NibObject(), forCellWithReuseIdentifier: TSChatShareMoreCollectionViewCell.identifier)
        self.listCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //fix the width
        self.listCollectionView.frame.sizeWidth = UIScreen.width
    }

}

// MARK: - @protocol UICollectionViewDataSource
extension TSChatShareMoreView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TSChatShareMoreCollectionViewCell.identifier, forIndexPath: indexPath) as! TSChatShareMoreCollectionViewCell
        let item = self.itemDataSouce[indexPath.row]
        cell.itemButton.setImage(item.iconImage, forState: .Normal)
        cell.itemLabel.text = item.name
        self.buttonAction(cell.itemButton, row: indexPath.row)
        return cell
    }
    
    //实现 Button 的点击回调
    private func buttonAction(button: UIButton, row: Int) {
        button.rx_tap.subscribeNext{[weak self] _ in
            guard let strongSelf = self, delegate = strongSelf.delegate else {
                return
            }
            if row == 0 {
                delegate.chatShareMoreViewPhotoTaped()
            } else if row == 1 {
                delegate.chatShareMoreViewCameraTaped()
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan start")
        
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





