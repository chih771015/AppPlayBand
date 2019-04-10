//
//  BookingData.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct BookingData: Equatable, Comparable {
    static func < (lhs: BookingData, rhs: BookingData) -> Bool {
        if lhs.date.year == rhs.date.year {
            
            if lhs.date.month == rhs.date.month {
                
                return lhs.date.day < rhs.date.day
            }
            return lhs.date.month < rhs.date.month
        }
        return lhs.date.year < rhs.date.year
        
    }
    static func == (lhs: BookingData, rhs: BookingData) -> Bool {
        return lhs.hour == rhs.hour && lhs.date == rhs.date
    }

    let date: BookingDate
    var hour: [Int] {
        
        didSet {
            
            self.hour.sort(by: <)
        }
    }
}

struct BookingDate: Equatable {
    
    let year: Int
    let month: Int
    let day: Int
    
    static func == (lhs: BookingDate, rhs: BookingDate) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
}
