//
//  SettingContentCategory.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import UIKit

enum SettingContentCategory: String {

    case notification = "推播通知"
    case passwordChange = "更改密碼"
    case logout = "登出"
    case storeApply = "店家申請"
    case superManger = "管理店家申請"

    var imageTitle: String {

        switch self {

        case .logout: return "logout"
        case .notification: return "notification"
        case .passwordChange: return "key"
        case .storeApply: return ""
        case .superManger:
            return ""
        }
    }
    
    var identifier: String {
        
        switch self {
        case .passwordChange:
            return String(describing: PasswordChangeViewController.self)
        case .storeApply:
            return String(describing: StoreMangerViewController.self)
        case .superManger:
            return String(describing: SuperMangerCheckStoreViewController.self)
        default:
            return ""
        }
    }

    func cellForIndexPathInSetting(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SettingTableViewCell.self),
            for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }

        switch self {

        case .notification:

            cell.setupWithSwitch(title: rawValue, image: imageTitle)
        default :
            cell.setupWithoutSwitch(title: rawValue, image: imageTitle)
        }
        return cell
    }

    func setCellForIndexPath(viewController: UIViewController) {

        switch self {

        case .passwordChange, .storeApply, .superManger:
            
            let nextVC = UIStoryboard.profile.instantiateViewController(
                withIdentifier: identifier)
            viewController.navigationController?.pushViewController(nextVC, animated: true)

        case .logout:
            
            FirebaseManger.shared.logout(completionHandler: { [weak viewController] result in
                
                switch result {
                    
                case .success(let message):
                    
                    viewController?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: {
                        
                        guard let appdelgate = UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        guard let nextVC = UIStoryboard.signIn.instantiateInitialViewController() else {
                            return
                        }
                        appdelgate.window?.rootViewController = nextVC
                    })
                case .failure(let error):
                    
                    viewController?.addErrorAlertMessage(
                        title: FirebaseEnum.fail.rawValue,
                        message: error.localizedDescription,
                        completionHanderInDismiss: nil)
                }
            })
        default:
            return
        }

    }
}
