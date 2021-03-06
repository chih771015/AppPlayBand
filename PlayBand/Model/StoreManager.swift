//
//  StoreProvider.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class StoreManager {
    
    private let firebaseStoreManger = FireBaseStoreDataManger()
    
    let bookingDataProVider = BookingDataManager()

    func getStoreDatas(completionHandler: @escaping (Result<[StoreData]>) -> Void) {
        
        firebaseStoreManger.getStoresData(completionHandler: completionHandler)
    }
    
    func getStoreBookingDatas(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        bookingDataProVider.getStoreBookingDatas(storeName: storeName, completionHandler: completionHandler)
    }
    
    func updateStoreDataInfo(storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void) {
        
        firebaseStoreManger.updateStoreData(storeData: storeData, completionHandler: completionHandler)
        
    }
    
    func confirmBookingOrder(storeName: String, pathID: String, userUID: String,
                             storeMessage: String = FirebaseBookingKey.storeMessage.description,
                             completionHandler: @escaping (Result<String>) -> Void) {
        bookingDataProVider.confirmBookingOrder(
            storeName: storeName, pathID: pathID, userUID: userUID, completionHandler: completionHandler)
        
    }
    
    func rejectOrder(pathID: String, storeName: String,
                     userUID: String, storeMessage: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        bookingDataProVider.rejectBookingOrder(pathID: pathID, storeName: storeName, userUID: userUID, storeMessage: storeMessage, completionHandler: completionHandler)
    }
    
}

protocol FirebaseGetStoreProtocol: class {
    
    func getStoresData(completionHandler: @escaping (Result<[StoreData]>) -> Void)
    
    func updateStoreData(storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void)
    
}
