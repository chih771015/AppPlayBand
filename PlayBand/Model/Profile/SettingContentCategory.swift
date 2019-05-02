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
    case editStore = "修改店家資料"

    var imageTitle: String {

        switch self {

        case .logout: return "logout"
        case .notification: return "notification"
        case .passwordChange: return "key"
        case .storeApply: return ""
        case .superManger:
            return ""
        case .editStore:
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
            return String(describing: EditStoreDetailViewController.self)
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
        case .editStore:
            
            let alert = UIAlertController(title: "選擇店家", message: "請選擇要修改資訊的店家", preferredStyle: .actionSheet)
            
            for store in FirebaseManger.shared.storeName {
                
                let actionManger = UIAlertAction(title: "修改\(store)", style: .default) { [weak viewController] (_) in
                    
                    guard let nextVC = UIStoryboard.profile.instantiateViewController(
                        withIdentifier: self.identifier
                        ) as? EditStoreDetailViewController else {
                        return
                    }
                    
                    if let store = FirebaseManger.shared.storeDatas.first(where: {$0.name == store}) {
                        nextVC.storeData = store
                        viewController?.navigationController?.pushViewController(nextVC, animated: true)
                    }
                    
                }
                actionManger.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
                alert.addAction(actionManger)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
            alert.addAction(cancelAction)

            viewController.present(alert, animated: true, completion: nil)
        default:
            return
        }

    }
}
