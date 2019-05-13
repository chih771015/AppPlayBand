//
//  StoreDataWithFirebaseLogic.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import Firebase

enum StoreDataKey: String {
    
    case name
    case opentime
    case closetime
    case phone
    case address
    case photourl
    case rooms
    case price
    case information
    case city
    case images
}

class FireBaseStoreDataManger {
    
    private lazy var fireStoreDatabase = FirebaseManger.shared.fireStoreDatabase()
    
    private let firebaseManger: FirebaseReadAndWrite
    
    init(firebaseManger: FirebaseReadAndWrite = FirebaseManger.shared) {
        self.firebaseManger = firebaseManger
    }
    
    func getStoresData(refName: FirebaseCollectionName = .store ,completionHandler: @escaping (Result<[StoreData]>) -> Void) {
        
        let ref = fireStoreDatabase.collectionName(refName)
        firebaseManger.collectionGetDocuments(ref: ref) { (result) in
            
            switch result {
                
            case .success(let datas):
                
                let storedatas = DataTransform.dataArrayReturnWithoutOption(datas: datas.map({StoreData(dictionary: $0)}))
                FirebaseManger.shared.storeDatas = storedatas
                completionHandler(.success(storedatas))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func updateStoreData(storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void) {
        
        let fireBaseData = storeDataToFirebaseData(storeData: storeData)
        let ref = fireStoreDatabase.collectionName(.store).document(storeData.name)
        firebaseManger.documentUpdata(ref: ref, data: fireBaseData) { (result) in
            switch result {
            case .success(_):
                
                completionHandler(.success(FBStoreMessage.updata.message))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    private func storeDataToFirebaseData(storeData: StoreData) -> FireBaseData {
        
        var imagesArray: [String] = []
        for image in storeData.images {
            
            imagesArray.append(image)
        }
        var roomsArray: [[String: Any]] = []
        for room in storeData.rooms {
            
            let roomDictionary = [StoreDataKey.name.rawValue: room.name,
                                  StoreDataKey.price.rawValue: room.price]
            roomsArray.append(roomDictionary)
        }
        
        let dictionay: [String: Any] = [
            StoreDataKey.name.rawValue: storeData.name,
            StoreDataKey.opentime.rawValue: storeData.openTime,
            StoreDataKey.closetime.rawValue: storeData.closeTime,
            StoreDataKey.phone.rawValue: storeData.phone,
            StoreDataKey.address.rawValue: storeData.address,
            StoreDataKey.information.rawValue: storeData.information,
            StoreDataKey.city.rawValue: storeData.city,
            StoreDataKey.photourl.rawValue: storeData.photourl,
            StoreDataKey.images.rawValue: imagesArray,
            StoreDataKey.rooms.rawValue: roomsArray]
        
        return dictionay
    }
}

protocol FirebaseReadAndWrite {
    
    func collectionGetDocuments(ref: CollectionReference, completionHandler: @escaping (Result<[FireBaseData]>) -> Void)
    
    func documentUpdata(ref: DocumentReference, data: [AnyHashable : Any], completionHandler: @escaping (Result<Bool>) -> Void)
}
