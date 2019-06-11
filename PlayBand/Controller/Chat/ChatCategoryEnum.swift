//
//  ChatCategoryEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum ChatCategoryEnum {
    
    case user
    case store(String)
    
    var title: String {
        
        switch self {
        case .user:
            return "用戶模式"
        case .store(let name):
            return name
        }
    }
}
