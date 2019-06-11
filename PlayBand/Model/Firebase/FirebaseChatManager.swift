//
//  FirebaseChatManager.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import Firebase

class FirebaseChatManager {
    
    let firebaseManager = FirebaseManager.shared
    lazy var fireStore = FirebaseManager.shared.fireStoreDatabase()
    let notificationSender = FireBaseNotificationSender()
    var listener: ListenerRegistration?
    weak var delegate: FirebaseChatDelegate?
    
    func getUserNewChatData(completionHandler: @escaping (Result<[ChatData]>) -> Void) {
        
        guard let uid = firebaseManager.user().currentUser?.uid else {
            completionHandler(.failure(FireBaseError.unknow))
            return
        }
        fireStore.collectionName(.user).document(uid)
            .collectionName(.newChatData).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
                return
            } else {
                
                guard let documents = querySnapshot?.documents else {
                    
                    completionHandler(.failure(FireBaseError.unknow))
                    return
                }
                
                let data = documents.compactMap({ChatData(dictionary: $0.data())})
                completionHandler(.success(data))
            }
        }
    }
    
    func getStoreNewChatData(storeName: String, completionHandler: @escaping (Result<[ChatData]>) -> Void) {
        
        fireStore.collectionName(.store).document(storeName)
            .collectionName(.newChatData).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
            }
            
            guard let documents = querySnapshot?.documents else {
                
                completionHandler(.failure(FireBaseError.unknow))
                return
            }
            
            var datas: [ChatData] = []
            for document in documents {
                
                guard let data = ChatData(dictionary: document.data()) else {continue}
                datas.append(data)
            }
            
            completionHandler(.success(datas))
        }
    }
    
    func sendNewMeesageToUser(userName: String, storeName: String, message: String, uid: String, userURL: String) {
        
        let document = fireStore.collectionName(.user).document(uid)
            .collectionName(.newChatData).document(storeName)
        let image = firebaseManager.storeDatas.first(where: {$0.name == storeName})?.photourl
        let data = setupMessageDataForFirebase(message: message, name: storeName, uid: storeName, imageURL: image)
        document.setData(data, merge: true) { [weak self] (error) in
            if let error = error {
                
            } else {
                
                self?.fireStore.collectionName(.user).document(uid).getDocument(completion: { (document, _) in
                    
                    guard let userTokens = UserData(dictionary: document?.data() ?? Dictionary())?.tokens else {return}
                    
                    for token in userTokens {
                        
                       self?.notificationSender.sendPushNotification(to: token, title: storeName, body: message)
                    }
                })
            }
        }
        
        let chatData = [ChatKey.message.rawValue: message,
                        ChatKey.time.rawValue: Date(),
                        ChatKey.uid.rawValue: storeName] as [String: Any]
        document.collectionName(.chatData).addDocument(data: chatData)
        cloneStoreChatData(userName: userName, storeName: storeName, userUID: uid, chatData: chatData, message: message, userURL: userURL)
    }
    
    private func cloneStoreChatData(userName: String, storeName: String, userUID: String, chatData: [String: Any], message: String, userURL: String) {
        
        let document = fireStore.collectionName(.store).document(storeName)
            .collectionName(.newChatData).document(userUID)
        document.collectionName(.chatData).addDocument(data: chatData)
        
        let data = setupMessageDataForFirebase(message: message, name: userName, uid: userUID, imageURL: userURL)
        document.setData(data, merge: true)
    }
    func sendNewMessageToStore(message: String, storeName: String) {
        
        guard let userData = firebaseManager.userData else {
            return
        }
        guard let uid = firebaseManager.user().currentUser?.uid else {return}
        let data = setupMessageDataForFirebase(
            message: message, name: userData.name, uid: uid, imageURL: userData.photoURL)
        let document = fireStore.collectionName(.store)
            .document(storeName).collectionName(.newChatData).document(uid)
        document.setData(data, merge: true) { [weak self] error in
            
            if error == nil, !userData.storeRejectUser.contains(storeName) {
                
                self?.sendNotificationToStore(storeName: storeName, message: message, userName: userData.name)
            }
        }
        
        let chatData = [ChatKey.message.rawValue: message, ChatKey.time.rawValue: Date(), ChatKey.uid.rawValue: uid] as [String: Any]
        document.collectionName(.chatData).addDocument(data: chatData)
        let storeURL = firebaseManager.storeDatas.first(where: {$0.name == storeName})?.photourl
        cloneUserChatData(storeName: storeName, uid: uid, chatData: chatData, storeURL: storeURL ?? "", message: message)
    }
    
    private func cloneUserChatData(storeName: String, uid: String, chatData: [String: Any], storeURL: String, message: String) {
        
        fireStore.collectionName(.user).document(uid)
            .collectionName(.newChatData).document(storeName)
            .collectionName(.chatData).addDocument(data: chatData)
        
        let data = setupMessageDataForFirebase(message: message, name: storeName, uid: storeName, imageURL: storeURL)
        fireStore.collectionName(.user).document(uid).collectionName(.newChatData).document(storeName)
            .setData(data, merge: true)
    }
    
    private func sendNotificationToStore(storeName: String, message: String, userName: String) {
        
        guard let storeData = firebaseManager.storeDatas.first(where: {$0.name == storeName}) else {return}
        for token in storeData.tokens {
            
            self.notificationSender.sendPushNotification(to: token, title: userName, body: message)
        }
    }
    
    private func setupMessageDataForFirebase(message: String, name: String, uid: String, imageURL: String?) -> [String: Any] {
        
        let data = [ChatKey.name.rawValue: name, ChatKey.imageURL.rawValue: imageURL,
                    ChatKey.uid.rawValue: uid, ChatKey.description.rawValue: message,
                    ChatKey.time.rawValue: Date()] as [String : Any]
        return data
        
    }
    
    func getStoreMessageAll(storeName: String, userUID: String, completionHandler: @escaping (Result<[Message]>) -> Void) {
        
        let collection = fireStore.collectionName(.store).document(storeName)
            .collectionName(.newChatData).document(userUID).collectionName(.chatData)
//            collection.getDocuments { [weak self] (querySnapshot, error) in
//
//                if let error = error {
//
//                    completionHandler(.failure(error))
//                    return
//                } else {
//
//                    guard let documents = querySnapshot?.documents else {
//
//                        completionHandler(.failure(FireBaseError.unknow))
//                        return
//                    }
//
//                    let datas = documents.compactMap({Message(dictionary: $0.data())})
//
//                    completionHandler(.success(datas))
            self.listener = collection.addSnapshotListener(includeMetadataChanges: true, listener: { [weak self] (querySnapshot, _) in
                
                guard let changes = querySnapshot?.documentChanges else {return}
                let data = changes.compactMap({Message(dictionary: $0.document.data())})
                self?.delegate?.chatDataNew(self ?? FirebaseChatManager(), messages: data)
            })
//                }
//        }
        
    }
    
    func getUserMessageAll(storeName: String, completionHandler: @escaping (Result<[Message]>) -> Void) {
        
        guard let uid = firebaseManager.user().currentUser?.uid else {
            
            completionHandler(.failure(FireBaseError.unknow))
            return
        }
        let collection = fireStore.collectionName(.user).document(uid)
            .collectionName(.newChatData).document(storeName).collectionName(.chatData)
//            collection.getDocuments { [weak self] (querySnapshot, error) in
//
//                if let error = error {
//
//                    completionHandler(.failure(error))
//                    return
//                } else {
//
//                    guard let documents = querySnapshot?.documents else {
//                        completionHandler(.failure(FireBaseError.unknow))
//                        return
//                    }
//
//                    let data = documents.compactMap({Message(dictionary: $0.data())})
//
//                    completionHandler(.success(data))
        
            self.listener = collection.addSnapshotListener(includeMetadataChanges: true, listener: { [weak self] (querySnapshot, _) in
                
                guard let changes = querySnapshot?.documentChanges else {return}
                let data = changes.compactMap({Message(dictionary: $0.document.data())})
                self?.delegate?.chatDataNew(self ?? FirebaseChatManager(), messages: data)
            })
//                }
        
//        }
    }
}

protocol FirebaseChatDelegate: AnyObject {
    func chatDataNew(_ firebaseChatManager: FirebaseChatManager, messages: [Message])
}
