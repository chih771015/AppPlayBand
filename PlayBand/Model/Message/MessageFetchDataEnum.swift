//
//  MessageFetchDataEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

enum MessageFetchDataEnum {
    
    case normal
    case store(String)
    
    var title: String {
        
        switch self {
        case .normal:
            return "用戶訂單模式"
        case .store(let store):
            return "管理\(store)"
        }
    }
    
    var orderDetailCellType: [MessageCategory] {
        
        switch self {
            
        case .normal:
            return [ .storeName, .documentID, .status, .room, .time, .hours, .price,
                     .userName, .userEmail, .userPhone, .userMessage, .storeMessageForStore]
        case .store:
            return [.userName, .uid, .userEmail, .userPhone, .userFacebook, .storeName, .documentID, .status,
                    .room, .price, .time, .hours, .userMessage]
        }
    }
    
    func headerForIndexPathInDetail(tableView: UITableView, at section: Int, bookingData: UserBookingData?) -> UIView? {
        
        guard let sectionHeader = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: MessageImageTableViewCell.self)
            ) as? MessageImageTableViewCell else {return UIView()}
        if let store = FirebaseManager.shared.storeDatas.first(where: {$0.name == bookingData?.store}) {
            
            sectionHeader.setupCell(url: store.photourl)
        }
        return sectionHeader
    }
    
    func cellForIndexPathInOrder(
        tableView: UITableView,
        at indexPath: IndexPath,
        bookingData: UserBookingData) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageOrderTableViewCell.self),
            for: indexPath) as? MessageOrderTableViewCell else {
                return UITableViewCell()
        }
        
        let data = bookingData
        let title = data.userInfo.name
        let date = data.bookingTime.returnDateText()
        let hours = data.bookingTime.hoursCount()
        var status = data.status
        switch status {
        case BookingStatus.confirm.rawValue:
            status = BookingStatus.confirm.display
        case BookingStatus.refuse.rawValue:
            status = BookingStatus.refuse.display
        case BookingStatus.tobeConfirm.rawValue:
            status = BookingStatus.tobeConfirm.display
        default:
            status = "BUG"
        }
        let url = data.userInfo.photoURL
        let storeName = data.store
        let storeURL = FirebaseManager.shared.storeDatas.first(where: {$0.name == storeName})?.photourl
        
        switch self {
            
        case .normal:
            
            cell.setupCell(title: storeName, date: date, hours: hours, status: status, url: storeURL)
        case .store:
            cell.setupCell(title: title, date: date, hours: hours, status: status, url: url)
        }

        return cell
    }
}
