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
    
    case passwordConfirm = "請再次輸入密碼"
    
    case userStatus = "使用者帳號類別"
    
    case store = "店家"
    
    case storePhone = "店家電話"
    
    case bookingTime = "預定時間"
    
    func cellForIndexPathInMain(_ indexPath: IndexPath, tableView: UITableView,
                                userData: UserData?) -> UITableViewCell {

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
        
        let userData = FirebaseManger.shared.userData
        
        switch self {

        case .name:

            cell.setupEditCell(placeholder: rawValue, text: userData?.name)

        case .email:

            cell.setupEditCell(placeholder: rawValue, text: userData?.email)

        case .band:

            cell.setupEditCell(placeholder: rawValue, text: userData?.band)

        case .phone:

            cell.setupEditCell(placeholder: rawValue, text: userData?.phone)

        case .facebook:

            cell.setupEditCell(placeholder: rawValue, text: userData?.facebook)
            
        case .userStatus:
            
            cell.setupEditPickerCell(placehoder: rawValue)
            
        case .password:
            
            cell.setupEditPasswordCell(placeholder: rawValue)
        case .passwordConfirm:
            
            cell.setupEditPasswordCell(placeholder: rawValue)
        default:
            cell.setupEditCell(placeholder: rawValue, text: "??")
        }

        return cell

    }
    
    
    
    func cellForIndexPathInMessageConfirm(_ indexPath: IndexPath, tableView: UITableView, bookingData: UserBookingData?, storeData: StoreData?, delgate: MessageConfirmCellDelgate) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageConfirmPageTableViewCell.self),
            for: indexPath) as? MessageConfirmPageTableViewCell else { return UITableViewCell()}
        
        switch self {
        case .name:
            cell.setupCellFirst(title: rawValue, description: bookingData?.userInfo.name, messageConfirmDelgate: delgate)
        case .phone:
            cell.setupCellDefault(title: rawValue, description: bookingData?.userInfo.phone)
        case .email:
            cell.setupCellDefault(title: rawValue, description: bookingData?.userInfo.email)
        case .band:
            cell.setupCellDefault(title: rawValue, description: bookingData?.userInfo.band)
        case .facebook:
            cell.setupCellDefault(title: rawValue, description: bookingData?.userInfo.band)
        case .store:
            cell.setupCellFirst(title: rawValue, description: storeData?.name, messageConfirmDelgate: delgate)
        case .storePhone:
            cell.setupCellDefault(title: rawValue, description: storeData?.phone)
        case .bookingTime:
            let title = DataTransform.dataToDate(bookingTime: bookingData?.bookingTime)
            cell.setupCellDefault(title: rawValue, description: title)
        default:
            return cell
        }
        
        return cell
    }
}
