//
//  BookingDataProvider.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum UserBookingDataWith {
    
    case user(uid: String)
    case storeManger(storeName: String)
}

class BookingDataManger {
    
    let fireBaseBookingManger = FBBookingDataManger()
    
    func getStoreBookingDatas(storeName: String, completionHandler: @escaping (Result<[BookingTimeAndRoom]>) -> Void) {
        
        fireBaseBookingManger.getStoreBookingData(storeName: storeName, completionHandler: completionHandler)
    }
    
    func getUserBookingData(with type: UserBookingDataWith,
                            completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        fireBaseBookingManger.getUserBookingDatas(with: type, completionHandler: completionHandler)
    }
}
