//
//  BookingData.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct BookingData: Equatable {
    
    static func == (lhs: BookingData, rhs: BookingData) -> Bool {
        return lhs.hour == rhs.hour && lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
}

