//
//  FirebaseError.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum FireBaseError: Error {
    
    case unknow
    
}
extension FireBaseError: LocalizedError {
    
    var errorDescription: String? {
        
        return NSLocalizedString("未知的錯誤", comment: "")
    }
}
