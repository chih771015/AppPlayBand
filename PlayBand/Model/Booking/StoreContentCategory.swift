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

    case name = "店名"
    
    case address = "地址"
    
    case phone = "電話"

    case price = "價錢"

    case description = "資訊"

    case time = "營業時間"
    
    case images

    var identifier: String {
        
        switch self {
            
        case .images:
            return String(describing: StoreTitleImageTableViewCell.self)
        default:
            return String(describing: StoreDescriptionTableViewCell.self)
        }

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
            
            var price = ""
            
            var roomCount = 0
            for room in storeData.rooms {
                
                if roomCount != 0 {
                    
                    price += "\n\(room.name) ：$\(room.price)"
                } else {
                    
                    price += "\(room.name) ：$\(room.price)"
                }
                roomCount += 1
            }
            desCell.setupCell(title: rawValue, description: price)
            
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
        }
        return desCell
    }

}
