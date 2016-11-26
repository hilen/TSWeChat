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
            let cell: TSChatTextCell = tableView.ts_dequeueReusableCell(TSChatTextCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .Image :
            let cell: TSChatImageCell = tableView.ts_dequeueReusableCell(TSChatImageCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .Voice:
            let cell: TSChatVoiceCell = tableView.ts_dequeueReusableCell(TSChatVoiceCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .System:
            let cell: TSChatSystemCell = tableView.ts_dequeueReusableCell(TSChatSystemCell.self)
            cell.setCellContent(model)
            return cell
            
        case .File:
            let cell: TSChatVoiceCell = tableView.ts_dequeueReusableCell(TSChatVoiceCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
            
        case .Time :
            let cell: TSChatTimeCell = tableView.ts_dequeueReusableCell(TSChatTimeCell.self)
            cell.setCellContent(model)
            return cell
        }
    }
}




