//
//  StoreProvider.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class StoreProvider {
    
    func getStoreDatas(completionHandler: @escaping (Result<[StoreData]>) -> Void) {
        
        FirebaseManger.shared.getFirstCollectionDocuments(
        collectionName: FirebaseCollectionName.store.name) { (result) in
            
            switch result {
                
            case .success(let datas):
                
                let storeDatas = DataTransform.dataArrayReturnWithoutOption(datas: datas.map({StoreData(dictionary: $0)}))
                
                completionHandler(.success(storeDatas))

            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func getStoreBookingDatas(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        FirebaseManger.shared
            .getSecondCollectionDocuments(
            firstCollection: FirebaseCollectionName.store.name,
            firstDocumentID: storeName,
            secondCollection: FirebaseCollectionName.bookingConfirm.name) { (result) in
            
            switch result {
                
            case .success(let datas):
                
                let bookingDatas = DataTransform.dataArrayReturnWithoutOption(datas: datas.map({UserBookingData(dictionary: $0)}))
                
                completionHandler(.success(bookingDatas))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
}
