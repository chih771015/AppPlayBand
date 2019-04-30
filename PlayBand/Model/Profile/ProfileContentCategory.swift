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
    
    case uid = "UID"
    
    case storeName
    case storeCity
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
        default:
            return "給錯了"
        }
    }
    
    var description: String {
        
        switch self {
        case .storeName:
            return "Ex:LineInStudio"
        case .storeCity:
            return "Ex:台北市"
        case .storePhone:
            return "Ex:0287654321"
        case .address:
            return "Ex:台北市復興南路52號一樓"
        case .openTime:
            return "Ex:08"
        case .closeTime:
            return "Ex:24"
        case .room:
            return "Ex:LineInStudio"
        case .price:
            return "Ex:LineInStudio"
        case .information:
            return "Ex:這裡是一個快樂溫馨的地方"
        default:
            return "給錯了"
        }
    }
    
    func cellForRoomEdit (_ indexPath: IndexPath,  tableView: UITableView, storeAddRoomCellDelegate: StoreAddRoomCellDelegate, texts: StoreData.Room?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: StoreAddRoomTableViewCell.self),
            for: indexPath) as? StoreAddRoomTableViewCell else { return UITableViewCell()}
        cell.setupCellInRoom(delegate: storeAddRoomCellDelegate, firstText: texts?.name, secondText: texts?.price)
        return cell
    }
    
    func cellForIndexPathInStore(_ indexPath: IndexPath, tableView: UITableView, textFieldDelegate: UITextFieldDelegate, text: String?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditTableViewCell.self),
            for: indexPath) as? EditTableViewCell else { return UITableViewCell()}
        cell.setupEditCell(placeholder: title, text: text, tag: indexPath.row, textFieldDelgate: textFieldDelegate, description: description)
        return cell
    }
    
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
        case .uid:
            guard let uid = FirebaseManger.shared.user().currentUser?.uid else {return cell}
            cell.settingProfilePage(title: rawValue, data: uid)
        default:
            cell.settingProfilePage(title: rawValue, data: "")
        }

        return cell

    }

    func cellForIndexPathInEdit(_ indexPath: IndexPath, tableView: UITableView, textFieldDelegate: UITextFieldDelegate) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditTableViewCell.self),
            for: indexPath) as? EditTableViewCell else { return UITableViewCell()}
        
        let userData = FirebaseManger.shared.userData
        
        switch self {
        
        case .account:
            
            cell.setupEditCell(placeholder: rawValue, text: "", tag: indexPath.row, textFieldDelgate: textFieldDelegate)
        case .name:

            cell.setupEditCell(placeholder: rawValue, text: userData?.name, tag: indexPath.row, textFieldDelgate: textFieldDelegate)

        case .email:

            cell.setupEditCell(placeholder: rawValue, text: userData?.email, tag: indexPath.row, textFieldDelgate: textFieldDelegate)

        case .band:

            cell.setupEditCell(placeholder: rawValue, text: userData?.band, tag: indexPath.row, textFieldDelgate: textFieldDelegate)

        case .phone:

            cell.setupEditCell(placeholder: rawValue, text: userData?.phone, tag: indexPath.row, textFieldDelgate: textFieldDelegate)

        case .facebook:

            cell.setupEditCell(placeholder: rawValue, text: userData?.facebook, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .userStatus:
            
            cell.setupEditPickerCell(placeholder: rawValue, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .password:
            
            cell.setupEditPasswordCell(placeholder: rawValue, tag: indexPath.row, textFieldDelgate: textFieldDelegate, text: nil)
        case .passwordConfirm:
            
            cell.setupEditPasswordCell(placeholder: rawValue, tag: indexPath.row, textFieldDelgate: textFieldDelegate, text: nil)
        default:
            cell.setupEditCell(placeholder: rawValue, text: "??", tag: indexPath.row, textFieldDelgate: textFieldDelegate)
        }

        return cell

    }
    
    func cellForIndexPathInSignUp(_ indexPath: IndexPath, tableView: UITableView, textFieldDelegate: UITextFieldDelegate, text: String?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditTableViewCell.self),
            for: indexPath) as? EditTableViewCell else { return UITableViewCell()}
        
        switch self {
            
        case .account:
            
            cell.setupEditCell(placeholder: rawValue, text: "", tag: indexPath.row, textFieldDelgate: textFieldDelegate)
        case .name:
            
            cell.setupEditCell(placeholder: rawValue, text: text, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .email:
            
            cell.setupEditCell(placeholder: "信箱帳號", text: text, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .band:
            
            cell.setupEditCell(placeholder: rawValue, text: text, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .phone:
            
            cell.setupEditCell(placeholder: rawValue, text: text, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .facebook:
            
            cell.setupEditCell(placeholder: rawValue, text: text, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .userStatus:
            
            cell.setupEditPickerCell(placeholder: rawValue, tag: indexPath.row, textFieldDelgate: textFieldDelegate)
            
        case .password:
            
            cell.setupEditPasswordCell(placeholder: rawValue, tag: indexPath.row, textFieldDelgate: textFieldDelegate, text: text)
        case .passwordConfirm:
            
            cell.setupEditPasswordCell(placeholder: rawValue, tag: indexPath.row, textFieldDelgate: textFieldDelegate, text: text)
        default:
            cell.setupEditCell(placeholder: rawValue, text: "??", tag: indexPath.row, textFieldDelgate: textFieldDelegate)
        }
        
        return cell
    }
    
}
