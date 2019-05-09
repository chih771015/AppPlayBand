//
//  AccountError.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum AccountError: Error {
    
    case noLogin
    
    var localizedDescription: String {
        switch self {
        case .noLogin:
            return "請先登入後才能操作"
        }
    }
}
