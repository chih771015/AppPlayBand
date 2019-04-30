//
//  MessageCategory.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/19.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

enum MessageCategory: String {
    
    private enum Message {
    
        case fail
        case priceCount(Int)
        
        func returnText() -> String {
            
            switch self {
            case .priceCount(let price):
                return "總預計金額:$\(price)"
            case .fail:
                return "出錯了請洽管理員"
            }
        }
    }
    
    case userName = "預約用戶"
    case uid = "用戶UID"
    case band = "團名"
    case userEmail = "用戶Email"
    case userFacebook = "用戶Facebook"
    case userPhone = "用戶電話"
    case documentID = "預定編號"
    case status = "預定狀態"
    case userMessage = "用戶備註"
    case storeName = "店名"
    case address = "地址"
    case storePhone = "電話"
    case price = "價錢"
    case description = "資訊"
    case storeMessageForStore = "店家回覆"
    case time = "預定日期"
    case hours = "預定時間"
    
    func cellForIndexPathInDetail(_ indexPath: IndexPath, tableView: UITableView,
        data: UserBookingData?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageDetailTableViewCell.self),
            for: indexPath) as? MessageDetailTableViewCell else {
                
            return UITableViewCell()
        }
        
        guard let bookingData = data else { return cell }
        
        switch self {
        case .userName:
            cell.setupCellHavePhoto(title: rawValue, description: bookingData.userInfo.name,
                                    imageURL: bookingData.userInfo.photoURL)
        case .storeName:
            cell.setupCell(title: rawValue, description: bookingData.store)
        case .documentID:
            cell.setupCell(title: rawValue, description: bookingData.pathID)
        case .band:
            cell.setupCell(title: rawValue, description: bookingData.userInfo.band)
        case .uid:
            cell.setupCell(title: rawValue, description: bookingData.userUID)
        case .userPhone:
            cell.setupCell(title: rawValue, description: bookingData.userInfo.phone)
        case .userEmail:
            cell.setupCell(title: rawValue, description: bookingData.userInfo.email)
        case .userFacebook:
            cell.setupCell(title: rawValue, description: bookingData.userInfo.facebook)
        case .userMessage:
            cell.setupCell(title: rawValue, description: bookingData.userMessage)
        case .storeMessageForStore:
            if bookingData.storeMessage != "" {
                cell.setupCell(title: rawValue, description: bookingData.storeMessage)
            } else {
                
            }
        case .status:
       
            cell.setupCell(title: rawValue, description: bookingData.returnStatusString())
        case .time:
            cell.setupCell(title: rawValue, description: bookingData.bookingTime.date.dateString())
        case .hours:
            cell.setupCell(title: rawValue, description: bookingData.bookingTime.hoursStringOnebyOne())
        default:
            cell.setupCell(title: rawValue, description: "錯誤")
        }
        return cell
    }
}
