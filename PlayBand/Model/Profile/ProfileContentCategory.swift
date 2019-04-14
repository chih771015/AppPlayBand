//
//  ProfileContentCategory.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import UIKit

enum ProfileContentCategory: String {

    case name = "姓名"

    case email = "Email"

    case phone = "電話"

    case band = "團名"

    case facebook = "粉絲專頁"
    
    case account = "帳號"
    
    case password = "密碼"
    
    func cellForIndexPathInMain(_ indexPath: IndexPath, tableView: UITableView, userData: UserData?) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProfileInformationTableViewCell.self),
            for: indexPath
            ) as? ProfileInformationTableViewCell
            else {
                
                return UITableViewCell()
            }
        guard let user = userData else {return UITableViewCell()}

        switch self {

        case .name:

            cell.settingProfilePage(title: rawValue, data: user.name)

        case .email:

            cell.settingProfilePage(title: rawValue, data: user.email)

        case .band:

            cell.settingProfilePage(title: rawValue, data: user.band)

        case .phone:

            cell.settingProfilePage(title: rawValue, data: user.phone)

        case .facebook:

            cell.settingProfilePage(title: rawValue, data: user.facebook)
            
        default:
            cell.settingProfilePage(title: rawValue, data: "")
        }

        return cell

    }

    func cellForIndexPathInEdit(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditTableViewCell.self),
            for: indexPath) as? EditTableViewCell else { return UITableViewCell()}

        switch self {

        case .name:

           cell.setupEditCell(placeholder: rawValue)

        case .email:

            cell.setupEditCell(placeholder: rawValue)

        case .band:

            cell.setupEditCell(placeholder: rawValue)

        case .phone:

            cell.setupEditCell(placeholder: rawValue)

        case .facebook:

            cell.setupEditCell(placeholder: rawValue)
            
        default:
            cell.setupEditCell(placeholder: rawValue)
        }

        return cell

    }
}
