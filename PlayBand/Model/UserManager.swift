//
//  UserProvider.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class UserManager {
    
    let bookingDataProvider = BookingDataManager()
    
    var userManagerStore: [String] {
        
        return FirebaseManager.shared.storeName
    }
    
    func getUserBookingDatasWithUserType(completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        bookingDataProvider.getUserBookingDatasWithUserType(completionHandler: completionHandler)
    }
    
    func getUserBookingDatasWithStoreType(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        bookingDataProvider.getUserBookingDatasWithStoreType(storeName: storeName, completionHandler: completionHandler)
    }
    
    func addBookingDatas(storeName: String, bookingDatas: [BookingTimeAndRoom],
                         userMessage: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        bookingDataProvider.addBookingDatas(storeName: storeName, bookingDatas: bookingDatas,
                                            userMessage: userMessage, completionHandler: completionHandler)
    }
}
