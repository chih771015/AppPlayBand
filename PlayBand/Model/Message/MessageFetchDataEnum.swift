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
    
    func cellForIndexPath(tableView: UITableView, at indexPath: IndexPath, bookingData: UserBookingData) -> UITableViewCell {
        
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
        let storeURL = FirebaseManger.shared.storeDatas.first(where: {$0.name == storeName})?.photourl
        
        switch self {
            
        case .normal:
            
            cell.setupCell(title: storeName, date: date, hours: hours, status: status, url: storeURL)
        case .store:
            cell.setupCell(title: title, date: date, hours: hours, status: status, url: url)
        }

        return cell
    }
}
