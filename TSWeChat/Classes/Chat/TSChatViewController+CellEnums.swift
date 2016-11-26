//
//  TSChatViewControllerCellEnums.swift
//  TSWeChat
//
//  Created by Hilen on 1/11/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation


// MARK: - @extension 消息内容 cell 的扩展
extension MessageContentType {
    func chatCellHeight(_ model: ChatModel) -> CGFloat {
        switch self {
        case .Text :
            return TSChatTextCell.layoutHeight(model)
        case .Image :
            return TSChatImageCell.layoutHeight(model)
        case .Voice:
            return TSChatVoiceCell.layoutHeight(model)
        case .System:
            return TSChatSystemCell.layoutHeight(model)
        case .File:
            return 60
        case .Time :
            return TSChatTimeCell.heightForCell()
        }
    }
    
    func chatCell(_ tableView: UITableView, indexPath: IndexPath, model: ChatModel, viewController: TSChatViewController) -> UITableViewCell? {
        switch self {
        case .Text :
            let cell = tableView.dequeueReusableCell(withIdentifier: TSChatTextCell.identifier, for: indexPath) as! TSChatTextCell
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .Image :
            let cell = tableView.dequeueReusableCell(withIdentifier: TSChatImageCell.identifier, for: indexPath) as! TSChatImageCell
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .Voice:
            let cell = tableView.dequeueReusableCell(withIdentifier: TSChatVoiceCell.identifier, for: indexPath) as! TSChatVoiceCell
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .System:
            let cell = tableView.dequeueReusableCell(withIdentifier: TSChatSystemCell.identifier, for: indexPath) as! TSChatSystemCell
            cell.setCellContent(model)
            return cell

        case .File:
            let cell = tableView.dequeueReusableCell(withIdentifier: TSChatVoiceCell.identifier, for: indexPath) as! TSChatVoiceCell
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .Time :
            let cell = tableView.dequeueReusableCell(withIdentifier: TSChatTimeCell.identifier, for: indexPath) as! TSChatTimeCell
            cell.setCellContent(model)
            return cell
        }
    }
}




