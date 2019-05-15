//
//  UserProvider.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class UserManger {
    
    let bookingDataProvider = BookingDataManger()
    
    func getUserBookingDatas(
        with type: UserBookingDataWith,
        completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        bookingDataProvider.getUserBookingData(with: type, completionHandler: completionHandler)
    }
}
