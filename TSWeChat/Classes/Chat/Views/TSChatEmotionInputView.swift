//
//  TSChatEmotionInputView.swift
//  TSWeChat
//
//  Created by Hilen on 12/16/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
import Dollar
import RxSwift

private let itemHeight: CGFloat = 50
private let kOneGroupCount = 23
private let kNumberOfOneRow: CGFloat = 8

class TSChatEmotionInputView: UIView {
    @IBOutlet fileprivate weak var emotionPageControl: UIPageControl!
    @IBOutlet fileprivate weak var sendButton: UIButton!{ didSet{
        sendButton.layer.borderColor = UIColor.lightGray.cgColor
        sendButton.layer.borderWidth = 0.5
        sendButton.layer.cornerRadius = 3.0
        sendButton.layer.masksToBounds = true
        }}

    @IBOutlet fileprivate weak var listCollectionView: TSChatEmotionScollView!
    fileprivate var groupDataSouce = [[EmotionModel]]()  //大数组包含小数组
    fileprivate var emotionsDataSouce = [EmotionModel]()  //Model 数组
    weak internal var delegate: ChatEmotionInputViewDelegate?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
        
    func initialize() {

    }
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        
        //calculate width and height
        let itemWidth = (UIScreen.ts_width - 10 * 2) / kNumberOfOneRow
        let padding = (UIScreen.ts_width - kNumberOfOneRow * itemWidth) / 2.0
        let paddingLeft = padding
        let paddingRight = UIScreen.ts_width - paddingLeft - itemWidth * kNumberOfOneRow
        
        //init FlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        
        //init listCollectionView
        self.listCollectionView.collectionViewLayout = layout
        self.listCollectionView.register(TSChatEmotionCell.ts_Nib(), forCellWithReuseIdentifier: TSChatEmotionCell.identifier)
        self.listCollectionView.isPagingEnabled = true
        self.listCollectionView.emotionScrollDelegate = self

        //init dataSource
        guard let emojiArray = NSArray(contentsOfFile: TSConfig.ExpressionPlist!) else {
            return
        }
        
        for data in emojiArray {
            let model = EmotionModel.init(fromDictionary: data as! NSDictionary)
            self.emotionsDataSouce.append(model)
        }
        self.groupDataSouce = Dollar.chunk(self.emotionsDataSouce, size: kOneGroupCount)  //将数组切割成 每23个 一组
        self.listCollectionView.reloadData()
        self.emotionPageControl.numberOfPages = self.groupDataSouce.count
    }
    
    @IBAction func sendTaped(_ sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.chatEmoticonInputViewDidTapSend()
        }
    }
    
    //transpose line/row
    fileprivate func emoticonForIndexPath(_ indexPath: IndexPath) -> EmotionModel? {
        let page = indexPath.section
        var index = page * kOneGroupCount + indexPath.row
        
        let ip = index / kOneGroupCount  //重新计算的所在 page
        let ii = index % kOneGroupCount  //重新计算的所在 index
        let reIndex = (ii % 3) * Int(kNumberOfOneRow) + (ii / 3)  //最终在数据源里的 Index
        
        index = reIndex + ip * kOneGroupCount
        if index < self.emotionsDataSouce.count {
            return self.emotionsDataSouce[index]
        } else {
            return nil
        }
    }
}

// MARK: - @protocol UICollectionViewDelegate
extension TSChatEmotionInputView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - @protocol UICollectionViewDataSource
extension TSChatEmotionInputView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupDataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kOneGroupCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TSChatEmotionCell.identifier, for: indexPath) as! TSChatEmotionCell
        if indexPath.row == kOneGroupCount {
            cell.setDeleteCellContnet()
        } else {
            cell.setCellContnet(self.emoticonForIndexPath(indexPath))
        }
        return cell
    }
}

// MARK: - @protocol UIScrollViewDelegate
extension TSChatEmotionInputView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.listCollectionView.ts_width
        self.emotionPageControl.currentPage = Int(self.listCollectionView.contentOffset.x / pageWidth)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listCollectionView.hideMagnifierView()
        self.listCollectionView.endBackspaceTimer()
    }
}

// MARK: - @protocol UIInputViewAudioFeedback
extension TSChatEmotionInputView: UIInputViewAudioFeedback {
    internal var enableInputClicksWhenVisible: Bool {
        get { return true }
    }
}


// MARK: - @protocol ChatEmotionScollViewDelegate
extension TSChatEmotionInputView: ChatEmotionScollViewDelegate {
    func emoticonScrollViewDidTapCell(_ cell: TSChatEmotionCell) {
        guard let delegate = self.delegate else {
            return
        }
        if cell.isDelete {
            delegate.chatEmoticonInputViewDidTapBackspace(cell)
        } else {
            delegate.chatEmoticonInputViewDidTapCell(cell)
        }
    }
}


/**
 *  表情键盘的代理方法
 */
 // MARK: - @delegate ChatEmotionInputViewDelegate
protocol ChatEmotionInputViewDelegate: class {
    /**
     点击表情 Cell
     
     - parameter cell: 表情 cell
     */
    func chatEmoticonInputViewDidTapCell(_ cell: TSChatEmotionCell)
    
    /**
     点击表情退后键
     
     - parameter cell: 退后的 cell
     */
    func chatEmoticonInputViewDidTapBackspace(_ cell: TSChatEmotionCell)
    
    /**
     点击发送键
     */
    func chatEmoticonInputViewDidTapSend()

}









