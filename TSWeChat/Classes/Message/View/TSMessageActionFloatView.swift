//
//  TSMessageActionFloatView.swift
//  TSWeChat
//
//  Created by Hilen on 3/8/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Cent

private let kActionViewWidth: CGFloat = 140   //container view width
private let kActionViewHeight: CGFloat = 190    //container view height
private let kActionButtonHeight: CGFloat = 44   //button height
private let kFirstButtonY: CGFloat = 12 //the first button Y value

class TSMessageActionFloatView: UIView {
    weak var delegate: ActionFloatViewDelegate?
    let disposeBag = DisposeBag()

    override init (frame: CGRect) {
        super.init(frame : frame)
        self.initContent()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initContent() {
        self.backgroundColor = UIColor.clear
        let actionImages = [
            TSAsset.Contacts_add_newmessage.image,
            TSAsset.Barbuttonicon_add_cube.image,
            TSAsset.Contacts_add_scan.image,
            TSAsset.Receipt_payment_icon.image,
        ]
        
        let actionTitles = [
            "发起群聊",
            "添加朋友",
            "扫一扫",
            "收付款",
        ]
        
        //Init containerView
        let containerView : UIView = UIView()
        containerView.backgroundColor = UIColor.clear
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(3)
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.equalTo(kActionViewWidth)
            make.height.equalTo(kActionViewHeight)
        }
        
        //Init bgImageView
        let stretchInsets = UIEdgeInsets.init(top: 14, left: 6, bottom: 6, right: 34)
        let bubbleMaskImage = TSAsset.MessageRightTopBg.image.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        let bgImageView: UIImageView = UIImageView(image: bubbleMaskImage)
        containerView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(containerView)
        }
        
        //init custom buttons
        var yValue = kFirstButtonY
        for index in 0 ..< actionImages.count {
            let itemButton: UIButton = UIButton(type: .custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 17)
            itemButton.setTitleColor(UIColor.white, for: UIControl.State())
            itemButton.setTitleColor(UIColor.white, for: .highlighted)
            itemButton.setTitle(actionTitles.get(index: index), for: .normal)
            itemButton.setTitle(actionTitles.get(index: index), for: .highlighted)
            itemButton.setImage(actionImages.get(index: index), for: .normal)
            itemButton.setImage(actionImages.get(index: index), for: .highlighted)
            itemButton.addTarget(self, action: #selector(TSMessageActionFloatView.buttonTaped(_:)), for: UIControl.Event.touchUpInside)
            itemButton.contentHorizontalAlignment = .left
            itemButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0)
            itemButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
            itemButton.tag = index
            containerView.addSubview(itemButton)
            
            itemButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(containerView.snp.top).offset(yValue)
                make.right.equalTo(containerView.snp.right)
                make.width.equalTo(containerView.snp.width)
                make.height.equalTo(kActionButtonHeight)
            }
            yValue += kActionButtonHeight
        }
        
        //add tap to view
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx.event.subscribe { _ in
            self.hide(true)
        }.addDisposableTo(self.disposeBag)
        
        self.isHidden = true
    }
    
    @objc func buttonTaped(_ sender: UIButton!) {
        guard let delegate = self.delegate else {
            self.hide(true)
            return
        }
        
        let type = ActionFloatViewItemType(rawValue:sender.tag)!
        delegate.floatViewTapItemIndex(type)
        self.hide(true)
    }
    
    /**
     Hide the float view
     
     - parameter hide: is hide
     */
    func hide(_ hide: Bool) {
        if hide {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.2 ,
                animations: {
                    self.alpha = 0.0
                },
                completion: { finish in
                    self.isHidden = true
                    self.alpha = 1.0
            })
        } else {
            self.alpha = 1.0
            self.isHidden = false
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}



/**
 *  TSMessageViewController Float view delegate methods
 */
protocol ActionFloatViewDelegate: class {
    /**
     Tap the item with index
     */
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType)
}

enum ActionFloatViewItemType: Int {
    case groupChat = 0, addFriend, scan, payment
}


