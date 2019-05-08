//
//  FBBookingDataManger.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

extension UserBookingDataWith {
    
    var collectionName: FirebaseCollectionName {
        
        switch self {
        case .user:
            return .user
        case .storeManger:
            return .store
        }
    }
    
    var returnValue: String {
        
        switch self {
        case .user(let uid):
            return uid
        case .storeManger(let storeName):
            return storeName
        }
    }
}

class FBBookingDataManger {
    
    lazy var fireStoreDataBase = FirebaseManger.shared.fireStoreDatabase()
    
    let fireBase = FirebaseManger.shared
    
    func getStoreBookingData(storeName: String ,completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        let ref = fireStoreDataBase.collectionName(.store).document(storeName).collectionName(.bookingConfirm)
        fireBase.collectionGetDocuments(ref: ref) { (result) in
            
            switch result {
                
            case .success(let datas):
                
                let bookingDatas = DataTransform.dataArrayReturnWithoutOption(datas: datas.map({UserBookingData(dictionary: $0)}))
                
                completionHandler(.success(bookingDatas))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func getUserBookingDatas(type: UserBookingDataWith, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
       
        let ref = fireStoreDataBase.collectionName(type.collectionName).document(type.returnValue).collectionName(.bookingConfirm)
        fireBase.collectionGetDocuments(ref: ref) { (result) in
            
            switch result {
                
            case .success(let data):
                
                let bookingDatas = DataTransform.dataArrayReturnWithoutOption(datas: data.map({UserBookingData(dictionary: $0)}))
                
                completionHandler(.success(bookingDatas))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
}
