//
//  Firebase.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/13.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Firebase

class FirebaseManger {
    typealias AuthResult = (AuthDataResult?, Error?) -> Void
    typealias ListeningResult = (Auth, User?) -> Void
    
    static let shared = FirebaseManger()
    
    let user = { Auth.auth() }
    let dataBase = { Firestore.firestore() }
    var userData: UserData? {
        didSet {
            
            if self.userData?.status == UsersKey.Status.user.rawValue {
                
                getUserBookingData()
                self.userStatus = UsersKey.Status.user.rawValue
            }
            if self.userData?.status == UsersKey.Status.manger.rawValue {
                
                getMangerBookingData()
                self.userStatus = UsersKey.Status.manger.rawValue
            }
        }
    }
    
    var storeDatas: [StoreData] = []
    var userBookingData: [UserBookingData] = []
    var mangerStoreData: [UserBookingData] = []
    var userStatus: String = String()
    
    private init () {}
    
    func signUpAccount(email: String, password: String, completionHandler: @escaping AuthResult) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: completionHandler)
    }
    
    func signInAccount(email: String, password: String, completionHandler: @escaping AuthResult) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completionHandler)
    }
    
    func configure() {
        
        FirebaseApp.configure()
        FirebaseManger.shared.listenAccount { (_, _) in
            if self.userData == nil {
                self.getUserInfo()
            }
        }
        getStoreInfo(completionHandler: nil)
    }
    
    func listenAccount(completionHandler: @escaping ListeningResult) {
        Auth.auth().addStateDidChangeListener(completionHandler)
    }
    
    func logout(completionHandler: (String) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completionHandler(FirebaseEnum.logout.rawValue)
        } catch let signOutError as NSError {
            completionHandler(signOutError.localizedDescription)
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func editProfileInfo(userData: UserData, completionHandler: @escaping (Error?) -> Void) {
        
        guard let uid = user().currentUser?.uid else {return}
        dataBase().collection(FirebaseEnum.user.rawValue).document(uid).setData([
        UsersKey.name.rawValue: userData.name, UsersKey.band.rawValue: userData.band,
        UsersKey.email.rawValue: userData.email, UsersKey.phone.rawValue: userData.phone,
        UsersKey.facebook.rawValue: userData.facebook], merge: true) { error in
            if error == nil {
                self.getUserInfo()
            }
            completionHandler(error)
        }
    }
    
    func getStoreBookingInfo(name: String, completionHandler: @escaping (Result<[BookingTime]>) -> Void) {
        
        dataBase().collection(FirebaseEnum.store.rawValue).document(name)
        .collection(FirebaseEnum.confirm.rawValue).getDocuments { (querySnapshot, error) in
        
            guard let documents = querySnapshot?.documents else {
                return
            }
            if let error = error {
                
                completionHandler(.failure(error))
            } else {
                
                var booingTimes: [BookingTime] = []
                
                for document in documents {
                    
                    guard let bookingTime = BookingTime(dictionary: document.data()) else {
                        
                        completionHandler(.failure(FirebaseDataError.decodeFail))
                        return
                    }
                    booingTimes.append(bookingTime)
                }
                
                completionHandler(.success(booingTimes))
            }
        }
    }
    
    func bookingTimeEdit(storeName: String, bookingDatas: [BookingTime],
                         userMessage: String, completionHandler: @escaping (Result<String>) -> Void) {
        
        guard let uid = user().currentUser?.uid else { return }
        guard let user = FirebaseManger.shared.userData else { return }
        for bookingData in bookingDatas {
            
            let document = dataBase()
                .collection(FirebaseEnum.store.rawValue).document(storeName)
                .collection(FirebaseEnum.confirm.rawValue).document()
            let documentID = document.documentID
            let dictionary = DataTransform.getUserBookingDictionary(
                bookingData: bookingData, documentID: documentID, uid: uid,
                user: user, name: storeName, userMessage: userMessage)
            document.setData(
                dictionary, merge: true,
                completion: { (error) in
                            
                if let error = error {
                    
                    if bookingData == bookingDatas.last {
                        
                        completionHandler(Result.failure(error))
                    }
                } else {
                    
                    self.cloneBookingData(
                        dictionary: dictionary, uid: uid,
                        storeName: storeName, documentID: documentID)
                    if bookingData == bookingDatas.last {
                        
                        completionHandler(Result.success(FirebaseEnum.addBooking.rawValue))
                    }
                }
            })
        }
    }
    
    private func cloneBookingData(dictionary: [String: Any], uid: String, storeName: String, documentID: String) {
        
        let documemntInBooking = dataBase().collection(FirebaseEnum.booking.rawValue)
            .document(storeName).collection(uid).document(documentID)
        
        documemntInBooking.setData(dictionary, merge: true)
        
        let documentInUser = dataBase().collection(FirebaseEnum.user.rawValue)
            .document(uid).collection(FirebaseEnum.booking.rawValue).document(documentID)
        
        documentInUser.setData([UsersKey.documentID.rawValue: documentID,
                      UsersKey.store.rawValue: storeName], merge: true)
    }
    
    func getUserBookingData() {
        
        guard let uid = user().currentUser?.uid else { return }
        
        let userBookingDocument = dataBase().collection(FirebaseEnum.user.rawValue)
            .document(uid).collection(FirebaseEnum.booking.rawValue)
        
        userBookingDocument.getDocuments { (querySnapshot, _) in
            
            guard let documents = querySnapshot else { return }
            
            for document in documents.documents {
                
                guard let list = UserListData(dictionary: document.data()) else {
                    
                    return }
                self.getBookingMessage(listID: list.documentID, storeName: list.store, uid: uid)
            }
        }
    }
    
    private func getBookingMessage(listID: String, storeName: String, uid: String) {
        self.userBookingData = []
        dataBase().collection(FirebaseEnum.booking.rawValue).document(storeName)
            .collection(uid).document(listID).getDocument { (document, _) in
                guard let documentData = document?.data() else {return}
                guard let bookingMessage = UserBookingData(dictionary: documentData) else {return}
                self.userBookingData.append(bookingMessage)
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
    
    func uploadIamge(uniqueString: String, image: UIImage, completionHandler: @escaping (Result<String>) -> Void) {
        
        let storageRef = Storage.storage().reference().child("\(uniqueString).png")
        if let uploadData = UIImage.pngData(image)() {
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                
                if let error = error {
                    
                    completionHandler(.failure(error))
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        
                        completionHandler(.failure(error))
                        return
                    }
                    guard let url = url?.absoluteString else {return}
                    self.uploadUserImageURL(url: url, completionHandler: completionHandler)
                })
            }
        }
    }
    
    private func uploadUserImageURL(url: String, completionHandler: @escaping ((Result<String>) -> Void)) {
        guard let uid = user().currentUser?.uid else {return}
        dataBase().collection(FirebaseEnum.user.rawValue).document(uid)
            .setData([UsersKey.photoURL.rawValue: url], merge: true) { (error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
                return
            }
            
            completionHandler(.success(FirebaseEnum.uploadSuccess.rawValue))
        }
    }
    
    func getMangerBookingData() {
        
        guard let uid = user().currentUser?.uid else { return }
        
        let userBookingDocument = dataBase().collection(FirebaseEnum.user.rawValue)
            .document(uid).collection(FirebaseEnum.store.rawValue)
        userBookingDocument.getDocuments { (querySnapshot, _) in
            
            guard let documents = querySnapshot else { return }
            
            for document in documents.documents {
                
                guard let list = UserListData(dictionary: document.data()) else {
                    
                    return }
                self.getMangerMessage(listID: list.documentID, storeName: list.store, uid: uid)
            }
        }
    }
    
    private func getMangerMessage(listID: String, storeName: String, uid: String) {
        
        self.mangerStoreData = []
        dataBase().collection(FirebaseEnum.store.rawValue).document(storeName)
            .collection(FirebaseEnum.confirm.rawValue).getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    return
                }
                
                guard let documents = querySnapshot?.documents else {return}
                
                for document in documents {
                    
                    guard let data = UserBookingData(dictionary: document.data()) else {return}
                    
                    self.mangerStoreData.append(data)
                }
        }
    }
    
    func updataBookingConfirm(storeName: String, pathID: String, userUID: String,
                              completionHandler: @escaping (Result<String>) -> Void) {
        
        dataBase().collection(FirebaseEnum.store.rawValue).document(storeName)
            .collection(FirebaseEnum.confirm.rawValue).document(pathID)
            .updateData([FirebaseBookingKey.status.rawValue: FirebaseBookingKey.Status.confirm.rawValue]) { (error) in
                if let error = error {
                    
                    completionHandler(.failure(error))
                } else {
                    
                   self.updataBookingColloection(
                    storeName: storeName, pathID: pathID, userUID: userUID,
                    status: .confirm, completionHandler: completionHandler)
                }
        }
    }
    
    private func updataBookingColloection(storeName: String, pathID: String,
                                          userUID: String,
                                          status: FirebaseBookingKey.Status,
                                          completionHandler: @escaping (Result<String>) -> Void) {
        
        var dictionary: [String: Any] = [:]
        switch status {
        case .confirm:
            dictionary = [FirebaseBookingKey.status.rawValue: FirebaseBookingKey.Status.confirm.rawValue]
        case .refuse:
            dictionary = [FirebaseBookingKey.status.rawValue: FirebaseBookingKey.Status.refuse.rawValue]
        case .tobeConfirm:
            dictionary = [FirebaseBookingKey.status.rawValue: FirebaseBookingKey.Status.tobeConfirm.rawValue]
        }
        dataBase().collection(FirebaseEnum.booking.rawValue).document(storeName)
            .collection(userUID).document(pathID).updateData(dictionary) { (error) in
            
            if let error = error {
                
                completionHandler(.failure(error))
            } else {
                
                completionHandler(.success(FirebaseEnum.mangerConfirm.rawValue))
            }
        }
    }
    
    func refuseBooking(pathID: String, storeName: String,
                       userUID: String, completionHandler: @escaping (Result<String>) -> Void) {
        dataBase().collection(FirebaseEnum.store.rawValue).document(storeName)
            .collection(FirebaseEnum.confirm.rawValue).document(pathID).delete { (error) in
                
                if let error = error {
                    
                    completionHandler(.failure(error))
                    return
                } else {
                    
                    self.updataBookingColloection(
                        storeName: storeName, pathID: pathID, userUID: userUID,
                        status: .refuse, completionHandler: completionHandler)
                }
        }
    }
    
    private func addDeleteListInStore(storeName: String, uid: String, pathID: String) {
        
        let dictionary: [String: Any] = [FirebaseBookingKey.pathID.rawValue: pathID,
                                         UsersKey.store.rawValue: storeName,
                                         UsersKey.uid.rawValue: uid]
        dataBase().collection(FirebaseEnum.store.rawValue).document(storeName)
        .collection(FirebaseEnum.delete.rawValue).document(pathID)
        .setData(dictionary, merge: true)
    }
}
