 

import UIKit
 
 
 @objc protocol RCActionSheetDelegate {
    optional func actionSheet(actionSheet: RCActionSheet, didClickedWithButtonIndex: Int)
 }
 
 

class RCActionSheet: UIView {
    
    let button_height: CGFloat = 49.0
    let screenSize = UIScreen.mainScreen().bounds.size
    
    private func colorFrom(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: (red)/255.0, green: (green)/255.0, blue: (blue)/255.0, alpha: 1.0)
    }
    
    
    var delegate: RCActionSheetDelegate?
    private var buttonTitles = [String]()
    private var maskBackView = UIView()
    private var bottomView = UIView()
    private var backWindow: UIWindow?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // public methods
    static func actionSheet(title title: String? = nil, buttonTitles: [String], redButtonIndex: Int, delegate: RCActionSheetDelegate? = nil) -> RCActionSheet {
         return RCActionSheet(actionTitle: title, buttonTitles: buttonTitles, redButtonIndex: redButtonIndex, delegate: delegate)
    }
    
    convenience init(actionTitle: String? = nil, buttonTitles: [String], redButtonIndex: Int, delegate: RCActionSheetDelegate? = nil) {
        self.init()
        
        self.delegate = delegate
        
        let  backView = UIView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        backView.alpha = 0
        backView.userInteractionEnabled = false
        backView.backgroundColor = self.colorFrom(46.0, green: 49.0, blue: 50.0)
        self.addSubview(backView)
        self.maskBackView = backView
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismiss:"))
        backView.addGestureRecognizer(tap)
        
        let bView = UIView()
        bView.backgroundColor = self.colorFrom(233, green: 233, blue: 238)
        self.addSubview(bView)
        self.bottomView = bView
        
        
        if let titleString = actionTitle {
            let titleLabel = UILabel(frame: CGRectMake(0, 0, screenSize.width, button_height))
            titleLabel.text = titleString as String
            titleLabel.textColor = self.colorFrom(111, green: 111, blue: 111)
            titleLabel.textAlignment = .Center
            titleLabel.font = UIFont.systemFontOfSize(13.0)
            titleLabel.backgroundColor = UIColor.whiteColor()
            bottomView.addSubview(titleLabel)
        }
        
        if buttonTitles.count > 0 {
            self.buttonTitles = buttonTitles
            
            for (index, title) in buttonTitles.enumerate() {
                let button = UIButton()
                button.tag = index
                button.backgroundColor = UIColor.whiteColor()
                button.setTitle(title, forState: .Normal)
                button.titleLabel?.font = UIFont.systemFontOfSize(16.0)
                
                var titleColor: UIColor
                if index == redButtonIndex {
                    titleColor = self.colorFrom(255, green: 10, blue: 10)
                }else{
                    titleColor = UIColor.blackColor()
                }
                button.setTitleColor(titleColor, forState: .Normal)
                
                
                let backImage = UIImage(named: "bgImage_HL")
                button.setBackgroundImage(backImage, forState: .Highlighted)
                button.addTarget(self, action: Selector("didClickBtn:"), forControlEvents: .TouchUpInside)
                
                let a = (actionTitle != nil ? 1 : 0)
                let b = a + index
                let buttonY = button_height * CGFloat(b)
                
                button.frame = CGRectMake(0, buttonY, screenSize.width, button_height)
                bottomView.addSubview(button)
            }
            
            for (index, _) in buttonTitles.enumerate() {
                let lineView = UIImageView(image: UIImage(named: "cellLine"))
                lineView.contentMode = .Center
                
                let a = (actionTitle != nil ? 1 : 0)
                let b = a + index
                let lineY = button_height * CGFloat(b)
                
                lineView.frame = CGRectMake(0, lineY, screenSize.width, 1.0)
                bottomView.addSubview(lineView)
            }
        }
        
        let cancelButton = UIButton()
        cancelButton.tag = buttonTitles.count
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.setBackgroundImage(UIImage(named: "bgImage_HL"), forState: .Highlighted)
        cancelButton.addTarget(self, action: Selector("didClickCancelBtn:"), forControlEvents: .TouchUpInside)
        
        
        let a = (actionTitle != nil ? 1 : 0)
        let b = a + self.buttonTitles.count
        let cancelY = button_height * CGFloat(b) + 5.0
        cancelButton.frame = CGRectMake(0, cancelY, screenSize.width, button_height)
        bottomView.addSubview(cancelButton)
        
        let x = (actionTitle != nil ? button_height : 0)
        let bottomH = x + button_height * CGFloat(buttonTitles.count) + button_height + 5
        bottomView.frame = CGRectMake(0, screenSize.height, screenSize.width, bottomH)
        
        
        self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        getBackWindow().addSubview(self)
    }
    
    
    private func getBackWindow() -> UIWindow{
        if self.backWindow == nil {
            let window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            window.windowLevel = UIWindowLevelStatusBar
            window.backgroundColor = UIColor.clearColor()
            window.hidden = false
            self.backWindow = window
        }
        
        return self.backWindow!
    }
    
    func didClickBtn(button: UIButton) {
        dismiss(nil)
        
        if let rDelegate = self.delegate {
            rDelegate.actionSheet!(self, didClickedWithButtonIndex: button.tag)
        }
    }
    
    func didClickCancelBtn(button: UIButton){
        UIView.animateWithDuration(0.23, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.maskBackView.alpha = 0
            self.maskBackView.userInteractionEnabled = false
            
            var frame = self.bottomView.frame
            frame.origin.y += frame.size.height
            self.bottomView.frame = frame
            
            }) { (finished) -> Void in
                self.getBackWindow().hidden = true
                self.removeFromSuperview()
                
                if let rDelegate = self.delegate {
                    rDelegate.actionSheet!(self, didClickedWithButtonIndex: self.buttonTitles.count)
                }
        }

    }
    
    func dismiss(tap: UITapGestureRecognizer?){
        UIView.animateWithDuration(0.23, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.maskBackView.alpha = 0
            self.maskBackView.userInteractionEnabled = false
            
            var frame = self.bottomView.frame
            frame.origin.y += frame.size.height
            self.bottomView.frame = frame
            
            }) { (finished) -> Void in
                self.getBackWindow().hidden = true
                self.removeFromSuperview()
        }
    }
    
   
    
    func show(){
        getBackWindow().hidden = false
        UIView.animateWithDuration(0.23, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.maskBackView.alpha = 0.4
            self.maskBackView.userInteractionEnabled = true
            
            var frame = self.bottomView.frame
            frame.origin.y -= frame.size.height
            self.bottomView.frame = frame
            
            }) { (finished) -> Void in
                 print("finished: \(finished)")
        }
    }
}
