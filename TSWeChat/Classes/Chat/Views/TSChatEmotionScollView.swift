//
//  TSChatEmotionScollView.swift
//  TSWeChat
//
//  Created by Hilen on 1/6/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation

class TSChatEmotionScollView: UICollectionView {
    fileprivate var touchBeganTime: TimeInterval = 0
    fileprivate var touchMoved: Bool = false
    fileprivate var magnifierImageView: UIImageView!
    fileprivate var magnifierContentImageView: UIImageView!
    fileprivate var backspaceTimer: Timer!
    fileprivate weak var currentMagnifierCell: TSChatEmotionCell?
    
    var emotionScrollDelegate: ChatEmotionScollViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    func initialize() {
        self.magnifierImageView = UIImageView(image: TSAsset.Emoticon_keyboard_magnifier.image)
        self.magnifierContentImageView = UIImageView()
        self.magnifierContentImageView.size = CGSize(width: 40, height: 40)
        self.magnifierContentImageView.centerX = self.magnifierImageView.width / 2
        self.magnifierImageView.addSubview(self.magnifierContentImageView)
        self.magnifierImageView.isHidden = true
        self.addSubview(self.magnifierImageView)
    }
    
    override func awakeFromNib() {
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = false
        self.isUserInteractionEnabled = true
        self.canCancelContentTouches = false
        self.isMultipleTouchEnabled = false
        self.scrollsToTop = false
    }
    
    deinit {
        self.endBackspaceTimer()
    }
    
    /**
     按住删除不动，触发 timer
     */
    func startBackspaceTimer() {
        self.endBackspaceTimer()
        self.backspaceTimer = Timer.ts_every(0.1, {[weak self] in
            if self!.currentMagnifierCell!.isDelete {
                UIDevice.current.playInputClick()
                self!.emotionScrollDelegate?.emoticonScrollViewDidTapCell(self!.currentMagnifierCell!)
            }
        })
        RunLoop.main.add(self.backspaceTimer, forMode: RunLoopMode.commonModes)
    }
    
    /**
     停止 timmer
     */
    func endBackspaceTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TSChatEmotionScollView.startBackspaceTimer), object: nil)
        if self.backspaceTimer != nil {
            self.backspaceTimer.invalidate()
            self.backspaceTimer = nil
        }
    }
    
    /**
     根据 touch point 获取 Cell
     
     - parameter touches: touches
     
     - returns: 表情 Cell
     */
    func cellForTouches(_ touches: Set<UITouch>) -> TSChatEmotionCell? {
        let touch =  touches.first as UITouch!
        let point = touch?.location(in: self)
        let indexPath = self.indexPathForItem(at: point!)
        guard let newIndexPath = indexPath else {
            return nil
        }
        let cell: TSChatEmotionCell = self.cellForItem(at: newIndexPath) as! TSChatEmotionCell
        return cell
    }
    
    /**
     隐藏放大镜
     */
    func hideMagnifierView() {
        self.magnifierImageView.isHidden = true
    }
    
    /**
     显示放大镜
     
     - parameter cell: 将要显示的 cell
     */
    func showMagnifierForCell(_ cell: TSChatEmotionCell) {
        if cell.isDelete || cell.emotionImageView.image == nil {
            self.hideMagnifierView()
            return
        }
        let rect: CGRect = cell.convert(cell.bounds, to: self)
        self.magnifierImageView.center = CGPoint(x: rect.midX, y: self.magnifierImageView.center.y)
        self.magnifierImageView.bottom = rect.maxY - 6
        self.magnifierImageView.isHidden = false
        
        self.magnifierContentImageView.image = cell.emotionImageView.image
        self.magnifierContentImageView.top = 20
        self.magnifierContentImageView.layer.removeAllAnimations()
        
        let duration: TimeInterval = 0.1
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {_ in
            self.magnifierContentImageView.top = 3
            }, completion: {finished in
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {_ in
                    self.magnifierContentImageView.top = 6
                    }, completion: {finished in
                        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {_ in
                            self.magnifierContentImageView.top = 5
                            }, completion:nil)
                })
        })
    }
}

// MARK: - @extension TSChatEmotionScollView
extension TSChatEmotionScollView {
    /**
     touch 响应链 touchesBegan
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchMoved = false
        //        let cell = self.cellForTouches(touches)
        guard let cell = self.cellForTouches(touches) else {
            return
        }
        self.currentMagnifierCell = cell
        self.showMagnifierForCell(self.currentMagnifierCell!)
        if !cell.isDelete && cell.emotionImageView.image != nil {
            UIDevice.current.playInputClick()
        }
        
        if cell.isDelete {
            self.endBackspaceTimer()
            self.perform(#selector(TSChatEmotionScollView.startBackspaceTimer), with: nil, afterDelay: 0.5)
        }
    }
    
    /**
     touch 响应链 touchesMoved
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchMoved = true
        if self.currentMagnifierCell != nil && self.currentMagnifierCell!.isDelete {
            return
        }
        
        guard let cell = self.cellForTouches(touches) else {
            return
        }
        if cell != self.currentMagnifierCell {
            if !self.currentMagnifierCell!.isDelete && !cell.isDelete {
                self.currentMagnifierCell = cell
            }
            self.showMagnifierForCell(cell)
        }
    }
    
    /**
     touch 响应链 touchesEnded
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cell = self.cellForTouches(touches) else {
            self.endBackspaceTimer()
            return
        }
        let checkCell = !self.currentMagnifierCell!.isDelete && cell.emotionImageView.image != nil
        let checkMove = !self.touchMoved && cell.isDelete
        if checkCell || checkMove {
            self.emotionScrollDelegate?.emoticonScrollViewDidTapCell(self.currentMagnifierCell!)
        }
        self.endBackspaceTimer()
        self.hideMagnifierView()
    }
    
    /**
     touch 响应链 touchesCancelled
     */
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        self.hideMagnifierView()
        self.endBackspaceTimer()
    }
}

/**
 *  仅供 TSChatEmotionInputView  使用
 */
// MARK: - @delgate ChatEmotionScollViewDelegate
protocol ChatEmotionScollViewDelegate {
    /**
     点击表情 Cell 或者 delete Cell
     
     - parameter cell: 表情 cell
     */
    func emoticonScrollViewDidTapCell(_ cell: TSChatEmotionCell)
}





