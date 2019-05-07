//
//  FirebaseMangerExtension++.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseManger {
    
    func getFirstCollectionDocuments(collectionName: String, completionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        let ref = dataBase().collection(collectionName)
        collectionGetDocuments(ref: ref, completionHandler: completionHandler)
        
    }
    
    func getSecondCollectionDocuments(firstCollection: String, firstDocumentID : String, secondCollection: String, compeletionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        let collectionRef = dataBase().collection(firstCollection)
            .document(firstDocumentID).collection(secondCollection)
        collectionGetDocuments(ref: collectionRef, completionHandler: compeletionHandler)
    }
    
    private func collectionGetDocuments(ref: CollectionReference, completionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        ref.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else if let datas = querySnapshot?.documents.map({$0.data()}) {
                
                completionHandler(.success(datas))
            } else {
                
                completionHandler(.failure(FireBaseError.unknow))
            }
        }
    }
    
    private func documentGetData(ref: DocumentReference, completionHandler: @escaping (Result<FireBaseData>) -> Void) {
        
        ref.getDocument { (documentSnapshot, error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else if let datas = documentSnapshot?.data() {
                
                completionHandler(.success(datas))
            } else {
                
                completionHandler(.failure(FireBaseError.unknow))
            }
        }
    }
    
    private func documentSetData(ref: DocumentReference, firebaseData: FireBaseData, merge: Bool = true, completionHandler: @escaping (Result<Bool>) -> Void) {
        
        ref.setData(firebaseData, merge: merge) { (error) in
            
            self.checkError(error: error, completionHandler: completionHandler)
        }
    }
    
    private func documentDelete(ref: DocumentReference, completionHandler: @escaping (Result<Bool>) -> Void) {
        
        ref.delete { (error) in
            
            self.checkError(error: error, completionHandler: completionHandler)
        }
    }
    
    private func documentUpdata(ref: DocumentReference, data: [AnyHashable : Any], completionHandler: @escaping (Result<Bool>) -> Void) {
        
        ref.updateData(data) { (error) in
            
            self.checkError(error: error, completionHandler: completionHandler)
        }
    }

    
    private func checkError(error: Error?, completionHandler: (Result<Bool>) -> Void) {
        
        
        if let error = error {
            
            completionHandler(.failure(error))
        } else {
            
            completionHandler(.success(true))
        }
    }
}
