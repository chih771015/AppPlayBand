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

class BookingDataManager {
    
    let fireBaseBookingManger = FBBookingDataManager()
    
    func getStoreBookingDatas(storeName: String, completionHandler: @escaping (Result<[BookingTimeAndRoom]>) -> Void) {
        
        fireBaseBookingManger.getStoreBookingData(storeName: storeName, completionHandler: completionHandler)
    }
    
    func getUserBookingDatasWithUserType(completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        fireBaseBookingManger.getUserBookingDatasWithUser(completionHandler: completionHandler)
    }
    
    func getUserBookingDatasWithStoreType(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        fireBaseBookingManger.getUserBookingDatasWithStore(storeName: storeName, completionHandler: completionHandler)
    }
}
