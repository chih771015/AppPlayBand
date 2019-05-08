//
//  FBStoreMessage.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum FBStoreMessage {
    
    case updata
    case success
    
    var message: String {
        
        switch self {
            
        case .updata:
            return "修改店家資料成功"
        case .success:
            return "是不是沒改到什麼"
        }
    }
}
