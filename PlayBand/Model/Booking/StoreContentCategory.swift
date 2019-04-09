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

    func cellForIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let desCell = cell as? StoreDescriptionTableViewCell else {return cell}
        switch self {

        case .information:
            return cell
        case .price:
            desCell.setupCell(title: rawValue, description: "20000")
        case .time:
            desCell.setupCell(title: rawValue, description: "10:00")
        case .description:
            desCell.setupCell(
                title: rawValue,
                description: "很多描述很多描述很多描述很多描述\n很多描述很多描述很多描述很多描述很多描述很多描述很多描述很多描述很多描述很多描述很多描述很多描述\n很多描述很多描述很多描述很多描述很多"
            )
        }
        return desCell
    }

}
