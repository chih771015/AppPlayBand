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
    
    func getFirstCollectionDocuments(collectionName: FirebaseCollectionName, completionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        let ref = fireStoreDatabase().collection(collectionName.name)
        collectionGetDocuments(ref: ref, completionHandler: completionHandler)
        
    }
    
    func getSecondCollectionDocuments(
        firstCollection: FirebaseCollectionName, firstDocumentID : String, secondCollection: FirebaseCollectionName, compeletionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
        let collectionRef = fireStoreDatabase().collection(firstCollection.name)
            .document(firstDocumentID).collection(secondCollection.name)
        collectionGetDocuments(ref: collectionRef, completionHandler: compeletionHandler)
    }
    
    func upDataFirstCollectionDocument(collectionName: FirebaseCollectionName, documentID: String, data: FireBaseData, completionHandler: @escaping (Result<Bool>) -> Void) {
        
        let documentRef = fireStoreDatabase().collection(collectionName.name).document(documentID)
        documentUpdata(ref: documentRef, data: data, completionHandler: completionHandler)
    }
    
    func setDataFirstCollection() {
        
        
    }
    
    func collectionGetDocuments(ref: CollectionReference, completionHandler: @escaping (Result<[FireBaseData]>) -> Void) {
        
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
    
    func documentGetData(ref: DocumentReference, completionHandler: @escaping (Result<FireBaseData>) -> Void) {
        
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
    
    func documentSetData(ref: DocumentReference, firebaseData: FireBaseData, merge: Bool = true, completionHandler: @escaping (Result<Bool>) -> Void) {
        
        ref.setData(firebaseData, merge: merge) { (error) in
            
            self.checkError(error: error, completionHandler: completionHandler)
        }
    }
    
    func documentDelete(ref: DocumentReference, completionHandler: @escaping (Result<Bool>) -> Void) {
        
        ref.delete { (error) in
            
            self.checkError(error: error, completionHandler: completionHandler)
        }
    }
    
    func documentUpdata(ref: DocumentReference, data: [AnyHashable : Any], completionHandler: @escaping (Result<Bool>) -> Void) {
        
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



extension Firestore {
    
    func collectionName(_ name: FirebaseCollectionName) -> CollectionReference {
        
        return self.collection(name.name)
    }
}

extension DocumentReference {
    
    func collectionName(_ name: FirebaseCollectionName) -> CollectionReference {
        
        return self.collection(name.name)
    }
}
