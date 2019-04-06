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
    
    func cellForIndexPathInMain(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileInformationTableViewCell.self), for: indexPath) as? ProfileInformationTableViewCell else { return UITableViewCell()}
        
        switch self {
            
        case .name:
            
            cell.settingProfilePage(title: rawValue, data: "安安")
            
        case .email:
            
            cell.settingProfilePage(title: rawValue, data: "123@gmail.com")
            
        case .band:
            
            cell.settingProfilePage(title: rawValue, data: "嘿嘿嘿嘿")
            
        case .phone:
            
            cell.settingProfilePage(title: rawValue, data: "0987654321")
            
        case .facebook:
            
            cell.settingProfilePage(title: rawValue, data: "Facebook")
        }
        
        return cell
        
    }
    
    func cellForIndexPathInEdit(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditTableViewCell.self), for: indexPath) as? EditTableViewCell else { return UITableViewCell()}
        
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
        }
        
        return cell
        
    }
}
