//
//  TSChatTimeCell.swift
//  TSWeChat
//
//  Created by Hilen on 1/11/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

private let kChatTimeLabelMaxWdith : CGFloat = UIScreen.ts_width - 30*2
private let kChatTimeLabelPaddingLeft: CGFloat = 6   //左右分别留出 6 像素的留白
private let kChatTimeLabelPaddingTop: CGFloat = 3   //上下分别留出 3 像素的留白
private let kChatTimeLabelMarginTop: CGFloat = 10   //顶部 10 px

class TSChatTimeCell: UITableViewCell {    
    @IBOutlet weak var timeLabel: UILabel! {didSet {
        timeLabel.layer.cornerRadius = 4
        timeLabel.layer.masksToBounds = true
        timeLabel.textColor = UIColor.white
        timeLabel.backgroundColor = UIColor (red: 190/255, green: 190/255, blue: 190/255, alpha: 0.6 )
        }}
    var model: ChatModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func setCellContent(_ model: ChatModel) {
        self.model = model
        self.timeLabel.text = String(format: "%@", model.messageContent!)
    }
    
    override func layoutSubviews() {
        guard let message = self.model?.messageContent else {
            return
        }
        self.timeLabel.ts_setFrameWithString(message, width: kChatTimeLabelMaxWdith)
        self.timeLabel.width = self.timeLabel.width + kChatTimeLabelPaddingLeft*2  //左右的留白
        self.timeLabel.left =  (UIScreen.ts_width - self.timeLabel.width) / 2
        self.timeLabel.height = self.timeLabel.height + kChatTimeLabelPaddingTop*2
        self.timeLabel.top = kChatTimeLabelMarginTop
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func heightForCell() -> CGFloat {
        return 40
    }
}


// MARK: - 聊天时间的 格式化字符串
extension Date {
    /**
     1、如果是列表的第一项，则显示时间；
     2、如果这一条与前面一条间隔两分钟以上，则显示时间
     3、如果这一条是列表的第一项，但是下拉刷新后与前面一条间隔在两分钟之内，仍显示这一条的时间
     4、时间显示格式：
         a) 如果是今天的聊天，显示具体时间。如：11:05
         b) 如果是昨天，或者前天，显示相对日期和具体时间，如：昨天 19:34，前天 20:22
         c) 如果在七天之内，则显示 星期加时间，如：周二 12:23
         d) 如果在一年之内，则显示月份日期 和时间，如：7月18日 12:34
         e) 一年以上的，显示年月日 加时间，如： 2014年6月29日 8:20
     */
    fileprivate var chatTimeString: String? {
        get {
            let calendar = Calendar.current
            let now = Date()
            let earliest = (now as NSDate).earlierDate(self)
            let latest = (earliest == now) ? self : now
            let components:DateComponents = (calendar as NSCalendar).components([
                NSCalendar.Unit.minute,
                NSCalendar.Unit.hour,
                NSCalendar.Unit.day,
                NSCalendar.Unit.weekOfYear,
                NSCalendar.Unit.month,
                NSCalendar.Unit.year,
                NSCalendar.Unit.second
                ], from: earliest, to: latest, options: NSCalendar.Options())
            
            let nowComponents:DateComponents = (calendar as NSCalendar).components([
                NSCalendar.Unit.minute,
                NSCalendar.Unit.hour,
                NSCalendar.Unit.day,
                NSCalendar.Unit.month,
                NSCalendar.Unit.year,
                ], from: now)
            
            let selfComponents:DateComponents = (calendar as NSCalendar).components([
                NSCalendar.Unit.minute,
                NSCalendar.Unit.hour,
                NSCalendar.Unit.day,
                NSCalendar.Unit.month,
                NSCalendar.Unit.year,
                ], from: earliest)
            
            if nowComponents.year != selfComponents.year {
                return String(format: "%zd年%zd月%zd日 %zd:%zd", selfComponents.year!, selfComponents.month!, selfComponents.day!, selfComponents.hour!, selfComponents.minute!)
            } else if nowComponents.year == selfComponents.year {
                if (components.month! > 0 || components.day! > 7) {
                    return String(format: "%zd月%zd日 %zd:%zd", selfComponents.month!, selfComponents.day!, selfComponents.hour!, selfComponents.minute!)
                } else if (components.day! > 2) {
                    return String(format: "%@ %zd:%zd",self.week(), selfComponents.hour!, selfComponents.minute!)
                } else if (components.day == 2) {
                    return String(format: "前天 %zd:%zd",selfComponents.hour!, selfComponents.minute!)
                } else if (components.day == 1) {
                    return String(format: "昨天 %zd:%zd",selfComponents.hour!, selfComponents.minute!)
                } else {
                    return String(format: "%zd:%zd",selfComponents.hour!, selfComponents.minute!)
                }
            }
            
            return ""
        }
    }
}
