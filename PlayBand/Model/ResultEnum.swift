//
//  ResultEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/16.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum Result<T> {
    
    case success(T)
    case failure(Error)
}
