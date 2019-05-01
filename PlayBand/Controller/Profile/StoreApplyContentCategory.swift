//
//  StoreApplyContentCategory.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/30.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

enum StoreApplyContentCategory {
    
    case storeName
    case storeCity
    case storePhone
    case address
    case openTime
    case closeTime
    case room
    case price
    case information
    
    var title: String {
        switch self {
        case .storeName:
            return "店家名稱"
        case .storeCity:
            return "店家城市"
        case .storePhone:
            return "店家電話"
        case .address:
            return "店家地址"
        case .openTime:
            return "開店時間"
        case .closeTime:
            return "結束時間"
        case .room:
            return "團室稱號"
        case .price:
            return "團室價錢"
        case .information:
            return "團室簡介"
        }
    }
    
    func cellForIndexPathInEdit(
        _ indexPath: IndexPath, tableView: UITableView, textFieldDelegate: UITextFieldDelegate) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditTableViewCell.self),
            for: indexPath) as? EditTableViewCell else { return UITableViewCell()}
        cell.setupEditCell(placeholder: title, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
        return cell
    }
}
