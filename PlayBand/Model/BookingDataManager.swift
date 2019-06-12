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
    
    func getStoreBookingDatas(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        fireBaseBookingManger.getStoreBookingData(storeName: storeName, completionHandler: completionHandler)
    }
    
    func getUserBookingDatasWithUserType(completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        fireBaseBookingManger.getUserBookingDatasWithUser(completionHandler: completionHandler)
    }
    
    func getUserBookingDatasWithStoreType(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        fireBaseBookingManger.getUserBookingDatasWithStore(storeName: storeName, completionHandler: completionHandler)
    }
    
    func addBookingDatas(storeName: String, bookingDatas: [BookingTimeAndRoom],
                         userMessage: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        fireBaseBookingManger.addUserBookingDatas(storeName: storeName, bookingDatas: bookingDatas, userMessage: userMessage, completionHandler: completionHandler)
    }
    
    func confirmBookingOrder(storeName: String, pathID: String, userUID: String,
                             storeMessage: String = FirebaseBookingKey.storeMessage.description,
                             completionHandler: @escaping (Result<String>) -> Void) {
        fireBaseBookingManger.confirmBookingOrder(storeName: storeName, pathID: pathID, userUID: userUID, completionHandler: completionHandler)
        
    }
    
    func rejectBookingOrder(pathID: String, storeName: String,
                            userUID: String, storeMessage: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        fireBaseBookingManger.rejecBookingOrder(pathID: pathID, storeName: storeName, userUID: userUID, storeMessage: storeMessage, completionHandler: completionHandler)
    }
}
