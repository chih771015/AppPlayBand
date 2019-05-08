//
//  StoreProvider.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class StoreProvider {
    
    private let firebaseStoreManger = FireBaseStoreDataManger()
    
    let bookingDataProVider = BookingDataProvider()
    
    func getStoreDatas(completionHandler: @escaping (Result<[StoreData]>) -> Void) {
        
        firebaseStoreManger.getStoresData(completionHandler: completionHandler)
    }
    
    func getStoreBookingDatas(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        bookingDataProVider.getStoreBookingDatas(storeName: storeName, completionHandler: completionHandler)
    }
    
    func updateStoreDataInfo(storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void) {
        
        firebaseStoreManger.updateStoreData(storeData: storeData, completionHandler: completionHandler)
        
    }
}
