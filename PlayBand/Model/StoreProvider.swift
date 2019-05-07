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
        
        FirebaseManger.shared.getOneCollectionDocuments(collectionName: .store) { (result) in
            
            switch result {
                
            case .success(let datas):
                
                var storeDatas: [StoreData] = []
                
                for data in datas {
                    
                    if let storeData = StoreData(dictionary: data) {
                        
                        storeDatas.append(storeData)
                    }
                }
                
                completionHandler(.success(storeDatas))

            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
}
