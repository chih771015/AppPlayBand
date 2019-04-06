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
    
    func cellForIndexPathInSetting(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingTableViewCell.self), for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        switch self {
            
        case .notification:
            
            cell.setupWithSwitch(title: rawValue, image: returnImageName())
            
        case .passwordChange:
            
            cell.setupWithoutSwitch(title: rawValue, image: returnImageName())
            
        case .logout:
            
            cell.setupWithoutSwitch(title: rawValue, image: returnImageName())
            
        }
        return cell
    }
    
    func setCellForIndexPath(viewController: UIViewController) {
        
        switch self {
        case .passwordChange:
            print("passowordChange")
        case .logout:
            print("logout")
        default:
            return
        }
        
        
    }
    
    private func returnImageName() -> String {
        
        switch self {
        case .notification:
            return "notification"
        case .passwordChange:
            return "key"
        case .logout:
            return "logout"
        }
    }
}
