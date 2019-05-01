//
//  FirebaseMangerExtension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/20.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

extension FirebaseManger {
    
    func getUserInfo() {
        
        guard let uid = user().currentUser?.uid else {
            self.userData = nil
            return
        }
        dataBase().collection(FirebaseEnum.user.rawValue).document(uid).getDocument { (document, error) in
            
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return UserData(dictionary: data)
                })
            }) {
                self.userData = user
            } else {
                
            }
        }
    }
    
    func getStoreInfo(completionHandler: ((Result<[StoreData]>) -> Void)?) {
        
        dataBase().collection(FirebaseEnum.store.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completionHandler?(.failure(error))
            } else {
                
                guard let documents = querySnapshot?.documents else {
                    
                    completionHandler?(.failure(FirebaseDataError.document))
                    return
                }
                var storeDatas: [StoreData] = []
                for document in documents {
                    
                    guard let storeData = StoreData(dictionary: document.data()) else {
                        completionHandler?(.failure(FirebaseDataError.decodeFail))
                        return
                    }
                    storeDatas.append(storeData)
                }
                self.storeDatas = storeDatas
                completionHandler?(.success(self.storeDatas))
            }
        }
    }
    
    func getMangerStoreName() {
        
        guard let uid = user().currentUser?.uid else {return}
        dataBase().collection(FirebaseEnum.user.rawValue).document(uid)
            .collection(FirebaseEnum.store.rawValue).getDocuments { (querySnapshot, error) in
            
                if error != nil {
                    self.storeName = ["nothing"]
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.storeName = ["nothing"]
                    return
                    
                }
                
                var names: [String] = []
                for document in documents {
                    
                    guard let storeName = document[UsersKey.store.rawValue] as? String else {return}
                    names.append(storeName)
                }
                self.storeName = names
        }
    }
    
    
}
