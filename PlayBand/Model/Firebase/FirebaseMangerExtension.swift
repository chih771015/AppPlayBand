//
//  FirebaseMangerExtension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/20.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Firebase

typealias FireBaseData = [String: Any]

extension FirebaseManger {
    
    func getUserInfo() {
        
        guard let uid = user().currentUser?.uid else {
            self.userData = nil
            return
        }
        fireStoreDatabase().collection(FirebaseEnum.user.rawValue).document(uid).getDocument { (document, _) in
            
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
        
        fireStoreDatabase().collection(FirebaseEnum.store.rawValue).getDocuments { (querySnapshot, error) in
            
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
        fireStoreDatabase().collection(FirebaseEnum.user.rawValue).document(uid)
            .collection(FirebaseEnum.store.rawValue).getDocuments { (querySnapshot, error) in
            
                if error != nil {
                    self.storeName = []
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.storeName = []
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
    
    func sendStoreApply(storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void) {
        
        var dictionary = storeData.getFirebaseDictionay()
        dictionary.updateValue(
            FirebaseBookingKey.Status.tobeConfirm.rawValue, forKey: FirebaseBookingKey.status.rawValue)
        dictionary.updateValue("等待回覆", forKey: FirebaseBookingKey.storeMessage.rawValue)
        guard let userData = self.userData else {
            completionHandler(.failure(InputError.information))
            return
        }
        let userDictionary = DataTransform.userData(userData: userData)
        dictionary.updateValue(userDictionary, forKey: FirebaseBookingKey.user.rawValue)
        
        let document = fireStoreDatabase().collection(FirebaseEnum.storeApply.rawValue).document()
        dictionary.updateValue(document.documentID, forKey: FirebaseBookingKey.pathID.rawValue)
        dictionary.updateValue(self.user().currentUser?.uid, forKey: UsersKey.uid.rawValue)
        
        document.setData(dictionary, merge: true) { error in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else {
                
                completionHandler(.success(FirebaseEnum.storeApplySuccess.rawValue))
            }
        }
    }
    
    func changePassword(password: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        user().currentUser?.updatePassword(to: password, completion: { (error) in
            
            if let error = error {
                
                completionHandler(Result.failure(error))
            } else {
                
                completionHandler(Result.success(FirebaseEnum.passwordChange.rawValue))
            }
        })
    }
    
    func uploadImagesAndGetURL(images: [UIImage], completionHandler: @escaping (Result<[String]>) -> Void) {
        var datas: [Data] = []
        var urls: [String] = []
        for image in images {
            
            guard let data = image.pngData() else {
                completionHandler(.failure(InputError.imageURLDidNotGet))
                return
            }
            datas.append(data)
            urls.append(String())
        }
        let group = DispatchGroup()
        
        for index in 0 ..< datas.count {
            
            group.enter()
            let uuid = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(uuid).png")
            storageRef.putData(datas[index], metadata: nil) { (_, _) in
                
                storageRef.downloadURL(completion: { (url, _) in
                    
                    guard let urlString = url?.absoluteString else {
                        
                        group.leave()
                        return
                    }
                    
                    urls[index] = urlString
                    group.leave()
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            if urls.filter({$0.isEmpty}).isEmpty {
                
                completionHandler(.success(urls))
                return
            } else {
                completionHandler(.failure(InputError.imageURLDidNotGet))
            }
          
        }
    }
    
    func getStoreApplyDataWithSuperManger(completionHandler: @escaping (Result<[StoreApplyData]>) -> Void) {
        
        fireStoreDatabase().collection(FirebaseEnum.storeApply.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                
                completionHandler(.failure(FirebaseDataError.document))
                return
            }
            
            var datas: [StoreApplyData] = []
            
            for document in documents {
                
                guard let data = StoreApplyData(dictionary: document.data()) else {
                    
                    completionHandler(.failure(FirebaseDataError.decodeFail))
                    return
                }
                
                datas.append(data)
            }
            completionHandler(.success(datas))
        }
    }
    
    func applyStoreInSuperManger(
        userUID: String, pathID: String,
        storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void) {
        
        fireStoreDatabase().collection(FirebaseEnum.store.rawValue)
            .document(storeData.name).setData(storeData.getFirebaseDictionay(), merge: true) { (error) in
            
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                self.fireStoreDatabase().collection(FirebaseEnum.user.rawValue).document(userUID)
                    .collection(FirebaseEnum.store.rawValue)
                    .addDocument(data: [UsersKey.store.rawValue: storeData.name])
                self.deleteApplyStore(pathID: pathID, storeName: storeData.name)
                completionHandler(.success("確認店家申請成功"))
        }
    }
    
    private func deleteApplyStore(pathID: String, storeName: String) {
        
        fireStoreDatabase().collection(FirebaseEnum.storeApply.rawValue).document(pathID).delete()
    }
    
    func getStoreBookingDataWithManger(
        storeName: String, completionHandler: @escaping (Result<[UserBookingData]>) -> Void) {
        fireStoreDatabase().collection(FirebaseEnum.store.rawValue).document(storeName)
            .collection(FirebaseEnum.booking.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let docments = querySnapshot?.documents else {
                completionHandler(.failure(FirebaseDataError.document))
                return
            }
            
            if docments.isEmpty {
                
                completionHandler(.success([]))
                return
            }
            
            var datas: [UserBookingData] = []
            for document in docments {
                
                guard let data = UserBookingData(dictionary: document.data()) else {
                    
                    completionHandler(.failure(FirebaseDataError.decodeFail))
                    return
                }
                datas.append(data)
            }
            
            completionHandler(.success(datas))
        }
    }
    
    func updataStoreData(storeData: StoreData, completionHandler: @escaping (Result<String>) -> Void) {
        let dictionary = storeData.getFirebaseDictionay()
        fireStoreDatabase()
            .collection(FirebaseEnum.store.rawValue)
            .document(storeData.name)
            .updateData(dictionary) { (error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success("修改資料成功"))
        }
    }
    
    func replaceStoreData(storeData: StoreData) {
        
        guard let index = self.storeDatas.firstIndex(where: {$0.name == storeData.name}) else {return}
        self.storeDatas[index] = storeData
        
        NotificationCenter.default.post(name: NSNotification.storeDatas, object: nil)
    }
    
    func userAddStoreBlackList(storeName: String, completionHandler: @escaping (Result<String>) -> Void) {
        guard let uid = user().currentUser?.uid else {
            
            completionHandler(.failure(AccountError.noLogin))
            return
        }
        fireStoreDatabase()
            .collection(FirebaseEnum.user.rawValue).document(uid)
            .updateData(
                [UsersKey.storeBlackList.rawValue: FieldValue.arrayUnion([storeName])]
            ) { (error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else {
                
                completionHandler(.success(FirebaseEnum.blackList.rawValue))
            }
        }
    }
    
    func storeAddUserBlackList(
        userUid: String,
        userName: String,
        storeNames: [String],
        completionHandler: @escaping (Result<String>) -> Void) {
        
        guard let uid = user().currentUser?.uid else {
            
            completionHandler(.failure(AccountError.noLogin))
            return
        }

        fireStoreDatabase().collection(FirebaseEnum.user.rawValue).document(userUid)
            .updateData([UsersKey.storeRejectUser.rawValue: FieldValue.arrayUnion(storeNames)]) { (error) in
            
            if let error = error {
                completionHandler(.failure(error))
                
            } else {
                
                let dictionary = [UsersKey.uid.rawValue: userUid, UsersKey.name.rawValue: userName]
                self.fireStoreDatabase().collection(FirebaseEnum.user.rawValue)
                    .document(uid).updateData([
                        UsersKey.userBlackList.rawValue:
                            FieldValue.arrayUnion([dictionary])], completion: { (error) in
                            
                                if let error = error {
                                    
                                    completionHandler(.failure(error))
                                } else {
                                    
                                    completionHandler(.success(FirebaseEnum.blackList.rawValue))
                                }
                })
            }
        }
    }
    
    func removeBlackList(listStyle: BlackList, name: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        switch listStyle {
        case .store:
            removeStoreBlackList(name: name, completionHandler: completionHandler)
        case .user:
            removeUserBlackList(name: name, completionHandler: completionHandler)
        }
    }
    
    private func removeStoreBlackList(name: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        guard let uid = user().currentUser?.uid else {
            
            completionHandler(.failure(AccountError.noLogin))
            return
        }
        fireStoreDatabase()
            .collection(FirebaseEnum.user.rawValue)
            .document(uid).updateData(
                [UsersKey.storeBlackList.rawValue: FieldValue.arrayRemove([name])]
            ) { (error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else {
                
                completionHandler(.success(FirebaseEnum.blackListRemove.rawValue))
            }
        }
    }
    
    private func removeUserBlackList(name: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        guard let uid = user().currentUser?.uid else {
            
            completionHandler(.failure(AccountError.noLogin))
            return
        }

        guard let userUID = userData?.userBlackLists.first(where: {$0.name == name})?.uid else {
            
            completionHandler(.failure(AccountError.noLogin))
            return
        }
        
        let dictionary = [UsersKey.name.rawValue: name, UsersKey.uid.rawValue: userUID]
        fireStoreDatabase()
            .collection(userCollection)
            .document(uid)
            .updateData(
                [UsersKey.userBlackList.rawValue: FieldValue.arrayRemove([dictionary])]
            ) { (error) in
            
            if let error = error {
                completionHandler(.failure(error))
                
            } else {
                
                self.removeStoreReject(userUID: userUID, completionHandler: completionHandler)
            }
        }
        
    }
    private func removeStoreReject(userUID: String, completionHandler: @escaping (Result<String>) -> Void){
        fireStoreDatabase().collection(userCollection)
            .document(userUID)
            .updateData([UsersKey.storeRejectUser.rawValue: FieldValue.arrayRemove(storeName)]){ error in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else {
                
                completionHandler(.success(FirebaseEnum.blackListRemove.rawValue))
            }
        }
    }
    
}
