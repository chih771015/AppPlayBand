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

    case information

    case price = "價錢"

    case description = "資訊"

    case time = "營業時間"

    var identifier: String {
        switch self {
        case .information : return String(describing: StoreInformationTableViewCell.self)
        case .price, .description, .time: return String(describing: StoreDescriptionTableViewCell.self)
        }

    }

    func cellForIndexPath(_ indexPath: IndexPath, tableView: UITableView, data: StoreData?) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let storeData = data else {return cell}
        guard let desCell = cell as? StoreDescriptionTableViewCell else {
        
            guard let informationcell = cell as? StoreInformationTableViewCell else {return cell}
            informationcell.setupCell(name: storeData.name, phone: storeData.phone, address: storeData.address)
            return informationcell
        }
        switch self {

        case .information:
            
            guard let informationcell = cell as? StoreInformationTableViewCell else {return cell}
            informationcell.setupCell(name: data?.name, phone: data?.phone, address: data?.address)
            return informationcell
            
        case .price:
            
            var price = ""
            
            for room in storeData.rooms {
                
                price += "\(room.price)\n"
            }
            desCell.setupCell(title: rawValue, description: price)
            
        case .time:
            
            desCell.setupCell(title: rawValue, description: "\(storeData.openTime):00 - \(storeData.closeTime):00")
            
        case .description:
            
            desCell.setupCell(
                title: rawValue,
                description: storeData.information
            )
        }
        return desCell
    }

}
