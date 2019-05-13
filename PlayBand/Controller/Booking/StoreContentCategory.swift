//
//  StoreContentCategory.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import UIKit

enum StoreContentCategory: String {
    
    case storeSearch

    case name = "店名"
    
    case address = "地址"
    
    case phone = "電話"

    case price = "價錢"

    case description = "資訊"

    case time = "營業時間"
    
    case images
    
    case userName = "申請人"
    
    case userPhone = "申請人電話"
    
    case userEmail = "申請人信箱"
    
    var identifier: String {
        
        switch self {
            
        case .images:
            return String(describing: StoreTitleImageTableViewCell.self)
        case .storeSearch:
            return String(describing: SearchStoreTableViewCell.self)
        default:
            return String(describing: StoreDescriptionTableViewCell.self)
        }

    }
    
    func cellForeSearch(_ indexPath: IndexPath, tableView: UITableView, storeData: StoreData) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath
            ) as? SearchStoreTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(title: storeData.name, imageURL: storeData.photourl,
                       city: storeData.city, price: storeData.returnStorePriceLowToHigh())
        
        return cell
    }
    
    func cellForSuperManger(_ indexPath: IndexPath,
                            tableView: UITableView, data: StoreData?, userData: UserData?) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let desCell = cell as? StoreDescriptionTableViewCell else {
            
            return cellForIndexPath(indexPath, tableView: tableView, data: data)
        }
        switch self {
        case .userName:
            desCell.setupCell(title: rawValue, description: userData?.name)
        case .userPhone:
            desCell.setupCell(title: rawValue, description: userData?.phone)
        case .userEmail:
            desCell.setupCell(title: rawValue, description: userData?.email)
        default:
            return cellForIndexPath(indexPath, tableView: tableView, data: data)
        }
        return desCell
    }

    func cellForIndexPath(
        _ indexPath: IndexPath, tableView: UITableView, data: StoreData?,
        images: [UIImage] = []) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let storeData = data else {return cell}
        guard let desCell = cell as? StoreDescriptionTableViewCell else {
        
            guard let imageCell = cell as? StoreTitleImageTableViewCell else {return cell}
            if storeData.photourl.isEmpty {
                
                imageCell.uiImages = images
                return imageCell
            }
            
            var images = [storeData.photourl]
            for image in storeData.images {
                images.append(image)
            }
            imageCell.images = images
            return imageCell
        }
        switch self {
        case .images:
            return desCell
        case .price:
        
            desCell.setupCell(title: rawValue, description: storeData.returnRoomAndPrices())
        case .time:
            
            desCell.setupCell(title: rawValue, description: "\(storeData.openTime):00 - \(storeData.closeTime):00")
            
        case .description:
            
            desCell.setupCell(title: rawValue, description: storeData.information)
        case .name:
            desCell.setupCell(title: rawValue, description: storeData.name)
        case .phone:
            desCell.setupCell(title: rawValue, description: storeData.phone)
        case .address:
            desCell.setupCell(title: rawValue, description: storeData.address)
        default:
            return cell
        }
        return desCell
    
    }

}
