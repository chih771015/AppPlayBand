//
//  MessageFetchDataEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum MessageFetchDataEnum {
    
    case normal
    case store(String)
    
    var title: String {
        
        switch self {
        case .normal:
            return "用戶訂單模式"
        case .store(let store):
            return "管理\(store)"
        }
    }
}
