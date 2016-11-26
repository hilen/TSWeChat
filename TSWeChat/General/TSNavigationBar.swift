//
//  TSNavigationBar.swift
//  TSWeChat
//
//  Created by Hilen on 3/9/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

class TSNavigationBar: UINavigationBar {
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
        
        //Init containerView
        let containerView : UIView = UIView()
        containerView.backgroundColor = UIColor.clear
        self.addSubview(containerView)
        containerView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(-20)
            make.left.equalTo(self.snp_left).offset(0)
            make.width.equalTo(44)
            make.height.equalTo(64)
        }
    
        
    }
}
