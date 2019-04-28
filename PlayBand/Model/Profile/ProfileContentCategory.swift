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
            
            cell.setupEditCell(placeholder: rawValue, text: "", textFieldDelgate: textFieldDelegate)
        case .name:

            cell.setupEditCell(placeholder: rawValue, text: userData?.name, textFieldDelgate: textFieldDelegate)

        case .email:

            cell.setupEditCell(placeholder: rawValue, text: userData?.email, textFieldDelgate: textFieldDelegate)

        case .band:

            cell.setupEditCell(placeholder: rawValue, text: userData?.band, textFieldDelgate: textFieldDelegate)

        case .phone:

            cell.setupEditCell(placeholder: rawValue, text: userData?.phone, textFieldDelgate: textFieldDelegate)

        case .facebook:

            cell.setupEditCell(placeholder: rawValue, text: userData?.facebook, textFieldDelgate: textFieldDelegate)
            
        case .userStatus:
            
            cell.setupEditPickerCell(placehoder: rawValue)
            
        case .password:
            
            cell.setupEditPasswordCell(placeholder: rawValue, textFieldDelgate: textFieldDelegate, text: nil)
        case .passwordConfirm:
            
            cell.setupEditPasswordCell(placeholder: rawValue, textFieldDelgate: textFieldDelegate, text: nil)
        default:
            cell.setupEditCell(placeholder: rawValue, text: "??", textFieldDelgate: textFieldDelegate)
        }

        return cell

    }
    
    func cellForIndexPathInSignUp(_ indexPath: IndexPath, tableView: UITableView, textFieldDelegate: UITextFieldDelegate, text: String?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditTableViewCell.self),
            for: indexPath) as? EditTableViewCell else { return UITableViewCell()}
        
        let userData = FirebaseManger.shared.userData
        
        switch self {
            
        case .account:
            
            cell.setupEditCell(placeholder: rawValue, text: "", textFieldDelgate: textFieldDelegate)
        case .name:
            
            cell.setupEditCell(placeholder: rawValue, text: text, textFieldDelgate: textFieldDelegate)
            
        case .email:
            
            cell.setupEditCell(placeholder: "信箱帳號", text: text, textFieldDelgate: textFieldDelegate)
            
        case .band:
            
            cell.setupEditCell(placeholder: rawValue, text: text, textFieldDelgate: textFieldDelegate)
            
        case .phone:
            
            cell.setupEditCell(placeholder: rawValue, text: text, textFieldDelgate: textFieldDelegate)
            
        case .facebook:
            
            cell.setupEditCell(placeholder: rawValue, text: text, textFieldDelgate: textFieldDelegate)
            
        case .userStatus:
            
            cell.setupEditPickerCell(placehoder: rawValue)
            
        case .password:
            
            cell.setupEditPasswordCell(placeholder: rawValue, textFieldDelgate: textFieldDelegate, text: text)
        case .passwordConfirm:
            
            cell.setupEditPasswordCell(placeholder: rawValue, textFieldDelgate: textFieldDelegate, text: text)
        default:
            cell.setupEditCell(placeholder: rawValue, text: "??", textFieldDelgate: textFieldDelegate)
        }
        
        return cell
    }
    
}
