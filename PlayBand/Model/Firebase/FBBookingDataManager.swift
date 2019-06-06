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

class FBBookingDataManager {
    
    lazy var fireStoreDataBase = FirebaseManager.shared.fireStoreDatabase()
    
    let fireBase = FirebaseManager.shared
    
    let pushNotification = FireBaseNotificationSender()
    
    func getStoreBookingData(storeName: String ,completionHandler: @escaping (Result<[BookingTimeAndRoom]>) -> Void) {
        
        let ref = fireStoreDataBase.collectionName(.store).document(storeName).collectionName(.bookingConfirm)
        fireBase.collectionGetDocuments(ref: ref) { (result) in
            
            switch result {
                
            case .success(let datas):
                do {
                    
                    let bookingDatas = try DataTransform
                        .dataArrayReturnWithoutOption(
                            datas: datas.map({BookingTimeAndRoom(dictionary: $0)})
                    )
                    
                    completionHandler(.success(bookingDatas))
                } catch {
                    
                    completionHandler(.failure(error))
                }
          
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    private func getUserBookingDatas(
        with type: UserBookingDataWith,
        completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
       
        let ref = fireStoreDataBase
            .collectionName(type.collectionName)
            .document(type.returnValue)
            .collectionName(.booking)
        fireBase.collectionGetDocuments(ref: ref) { (result) in
            
            switch result {
                
            case .success(let data):
                do {
                    let bookingDatas = try DataTransform
                        .dataArrayReturnWithoutOption(
                            datas: data.map({UserBookingData(dictionary: $0)}
                        )
                    )
                    
                    completionHandler(.success(bookingDatas))
                } catch {
                    
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func getUserBookingDatasWithUser(completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        guard let uid = FirebaseManager.shared.user().currentUser?.uid else {
            
            completionHandler(.failure(AccountError.noLogin))
            return
        }
        getUserBookingDatas(with: .user(uid: uid), completionHandler: completionHandler)
    }
    
    func getUserBookingDatasWithStore(storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        
        getUserBookingDatas(with: .storeManger(storeName: storeName), completionHandler: completionHandler)
    }
    
    func addUserBookingDatas(storeName: String, bookingDatas: [BookingTimeAndRoom],
                             userMessage: String, completionHandler: @escaping (Result<String>) -> Void) {
        fireBase.bookingTimeCreat(storeName: storeName, bookingDatas: bookingDatas, userMessage: userMessage) {[weak self] (result) in
            
            switch result {
            
            case .success:
                if self?.fireBase.storeName.contains(storeName) ?? false {
                    break
                }
                guard let tokens = self?.fireBase.storeDatas.first(where: {$0.name == storeName})?.tokens else {break}
                guard let name = self?.fireBase.userData?.name else {break}
                
                for token in tokens {
                    
                    self?.pushNotification.sendPushNotification(to: token, title: "新增團室預定", body: "用戶\(name)跟您預約團室\n請您做確認的動作")
                }
            case .failure:
                break
            }
            completionHandler(result)
        }
    }
}
