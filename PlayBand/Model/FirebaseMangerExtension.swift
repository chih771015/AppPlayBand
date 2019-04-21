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
                print(error?.localizedDescription)
            }
        }
    }
    
    func getStoreInfo(completionHandler: ((Result<[StoreData]>) -> Void)?) {
        
        if self.storeDatas.count != 0 {
            
            completionHandler?(.success(self.storeDatas))
            return
        }
        
        dataBase().collection(FirebaseEnum.store.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completionHandler?(.failure(error))
            } else {
                guard let documents = querySnapshot?.documents else {
                    return
                }
                var storeDatas: [StoreData] = []
                for document in documents {
                    
                    guard let storeData = StoreData(dictionary: document.data()) else { return }
                    storeDatas.append(storeData)
                }
                self.storeDatas = storeDatas
                completionHandler?(.success(self.storeDatas))
            }
        }
    }
}
