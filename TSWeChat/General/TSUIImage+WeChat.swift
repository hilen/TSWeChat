//
//  UIImage+Asset.swift
//  TSWeChat
//
//  Created by Hilen on 11/9/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

/*
https://github.com/AliSoftware/SwiftGen 在电脑上安装这个工具，自动生成 Asset 的 image enum 的 Extension

CLI 切换到：./TSWeChat/Resources
命令：swiftgen images Media.xcassets
*/


typealias TSAsset = UIImage.Asset

import Foundation
import UIKit

extension UIImage {
    enum Asset : String {
        case Add_friend_icon_addgroup = "add_friend_icon_addgroup"
        case Add_friend_icon_contacts = "add_friend_icon_contacts"
        case Add_friend_icon_invite = "add_friend_icon_invite"
        case Add_friend_icon_offical = "add_friend_icon_offical"
        case Add_friend_icon_reda = "add_friend_icon_reda"
        case Add_friend_icon_scanqr = "add_friend_icon_scanqr"
        case Back_icon = "back_icon"
        case C2cReceiverMsgNodeBG = "c2cReceiverMsgNodeBG"
        case C2cReceiverMsgNodeBG_HL = "c2cReceiverMsgNodeBG_HL"
        case C2cSenderMsgNodeBG = "c2cSenderMsgNodeBG"
        case C2cSenderMsgNodeBG_HL = "c2cSenderMsgNodeBG_HL"
        case Chat_image_mask_left = "chat_image_mask_left"
        case Chat_image_mask_right = "chat_image_mask_right"
        case Emoticon_keyboard_magnifier = "emoticon_keyboard_magnifier"
        case Emotion_delete = "emotion_delete"
        case Icon_avatar = "icon_avatar"
        case ReceiverImageNodeBorder = "ReceiverImageNodeBorder"
        case ReceiverImageNodeMask = "ReceiverImageNodeMask"
        case ReceiverTextNodeBkg = "ReceiverTextNodeBkg"
        case ReceiverTextNodeBkgHL = "ReceiverTextNodeBkgHL"
        case ReceiverVoiceNodePlaying = "ReceiverVoiceNodePlaying"
        case ReceiverVoiceNodePlaying001 = "ReceiverVoiceNodePlaying001"
        case ReceiverVoiceNodePlaying002 = "ReceiverVoiceNodePlaying002"
        case ReceiverVoiceNodePlaying003 = "ReceiverVoiceNodePlaying003"
        case MessageTooShort = "MessageTooShort"
        case RecordCancel = "RecordCancel"
        case RecordingBkg = "RecordingBkg"
        case RecordingSignal001 = "RecordingSignal001"
        case RecordingSignal002 = "RecordingSignal002"
        case RecordingSignal003 = "RecordingSignal003"
        case RecordingSignal004 = "RecordingSignal004"
        case RecordingSignal005 = "RecordingSignal005"
        case RecordingSignal006 = "RecordingSignal006"
        case RecordingSignal007 = "RecordingSignal007"
        case RecordingSignal008 = "RecordingSignal008"
        case SenderImageNodeBorder = "SenderImageNodeBorder"
        case SenderImageNodeMask = "SenderImageNodeMask"
        case SenderTextNodeBkg = "SenderTextNodeBkg"
        case SenderTextNodeBkgHL = "SenderTextNodeBkgHL"
        case SenderVoiceNodePlaying = "SenderVoiceNodePlaying"
        case SenderVoiceNodePlaying001 = "SenderVoiceNodePlaying001"
        case SenderVoiceNodePlaying002 = "SenderVoiceNodePlaying002"
        case SenderVoiceNodePlaying003 = "SenderVoiceNodePlaying003"
        case Tool_emotion_1 = "tool_emotion_1"
        case Tool_emotion_2 = "tool_emotion_2"
        case Tool_keyboard_1 = "tool_keyboard_1"
        case Tool_keyboard_2 = "tool_keyboard_2"
        case Tool_share_1 = "tool_share_1"
        case Tool_share_2 = "tool_share_2"
        case Tool_voice_1 = "tool_voice_1"
        case Tool_voice_2 = "tool_voice_2"
        case Contact_icon_ContactTag = "Contact_icon_ContactTag"
        case Dice_Action_0 = "dice_Action_0"
        case Dice_Action_1 = "dice_Action_1"
        case Dice_Action_2 = "dice_Action_2"
        case Dice_Action_3 = "dice_Action_3"
        case Ff_IconBottle = "ff_IconBottle"
        case Ff_IconGroup = "ff_IconGroup"
        case Ff_IconLocationService = "ff_IconLocationService"
        case Ff_IconQRCode = "ff_IconQRCode"
        case Ff_IconShake = "ff_IconShake"
        case Ff_IconShowAlbum = "ff_IconShowAlbum"
        case Setting_myQR = "setting_myQR"
        case MoreExpressionShops = "MoreExpressionShops"
        case MoreGame = "MoreGame"
        case MoreMyAlbum = "MoreMyAlbum"
        case MoreMyBankCard = "MoreMyBankCard"
        case MoreMyFavorites = "MoreMyFavorites"
        case MoreSetting = "MoreSetting"
        case Plugins_FriendNotify = "plugins_FriendNotify"
        case Sharemore_bg_1 = "sharemore_bg_1"
        case Sharemore_bg_2 = "sharemore_bg_2"
        case Sharemore_camera = "sharemore_camera"
        case Sharemore_friendcard = "sharemore_friendcard"
        case Sharemore_location = "sharemore_location"
        case Sharemore_myfav = "sharemore_myfav"
        case Sharemore_pay = "sharemore_pay"
        case Sharemore_pic = "sharemore_pic"
        case Sharemore_sight = "sharemore_sight"
        case Sharemore_videovoip = "sharemore_videovoip"
        case Sharemore_wxtalk = "sharemore_wxtalk"
        case Tabbar_badge = "tabbar_badge"
        case Tabbar_contacts = "tabbar_contacts"
        case Tabbar_contactsHL = "tabbar_contactsHL"
        case Tabbar_discover = "tabbar_discover"
        case Tabbar_discoverHL = "tabbar_discoverHL"
        case Tabbar_mainframe = "tabbar_mainframe"
        case Tabbar_mainframeHL = "tabbar_mainframeHL"
        case Tabbar_me = "tabbar_me"
        case Tabbar_meHL = "tabbar_meHL"
        case TabbarBkg = "tabbarBkg"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}





