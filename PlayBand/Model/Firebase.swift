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
        FirebaseManger.shared.listenAccount { (auth, user) in
            
            self.getUserInfo()
        }
    }
    
    func getStoreInfo(getStoreData: @escaping (Result<[StoreData]>) -> Void) {
        
        if self.storeDatas.count != 0 {
            
            getStoreData(.success(self.storeDatas))
            return
        }
        
        dataBase().collection(FirebaseEnum.store.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
              getStoreData(.failure(error))
            } else {
                guard let documents = querySnapshot?.documents else {
                    return
                }
                for document in documents {
                    
                    guard let storeData = StoreData(dictionary: document.data()) else { return }
                    self.storeDatas.append(storeData)
                }
                getStoreData(.success(self.storeDatas))
            }
        }
    }
    
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
        UsersKey.name.rawValue: userData.name,
        UsersKey.band.rawValue: userData.band,
        UsersKey.email.rawValue: userData.email,
        UsersKey.phone.rawValue: userData.phone,
        UsersKey.facebook.rawValue: userData.facebook
        ], merge: true) { error in
            if error == nil {
                self.getUserInfo()
            }
            completionHandler(error)
        }
    }
    
    func getStoreBookingInfo(name: String, completionHandler: @escaping (Result<[BookingTime]>) -> Void) {
        
        dataBase()
        .collection(FirebaseEnum.store.rawValue)
        .document(name)
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
    
    func bookingTimeEdit(storeName: String,
                         bookingDatas: [BookingTime],
                         completionHandler: @escaping (Result<String>) -> Void) {
        
        guard let uid = user().currentUser?.uid else { return }
        guard let user = FirebaseManger.shared.userData else { return }
        for bookingData in bookingDatas {
            
            let document = dataBase()
                .collection(FirebaseEnum.store.rawValue)
                .document(storeName)
                .collection(FirebaseEnum.confirm.rawValue)
                .document()
            let documentID = document.documentID
            let dictionary = [FirebaseBookingKey.year.rawValue: bookingData.date.year,
                              FirebaseBookingKey.month.rawValue: bookingData.date.month,
                              FirebaseBookingKey.day.rawValue: bookingData.date.day,
                              FirebaseBookingKey.hours.rawValue: bookingData.hour,
                              FirebaseBookingKey.pathID.rawValue: documentID,
                              FirebaseBookingKey.status.rawValue: BookingStatus.tobeConfirm.rawValue,
                              FirebaseBookingKey.user.rawValue:
                                [UsersKey.name.rawValue: user.name,
                                 UsersKey.band.rawValue: user.band,
                                 UsersKey.email.rawValue: user.email,
                                 UsersKey.phone.rawValue: user.phone,
                                 UsersKey.facebook.rawValue: user.facebook,
                                 UsersKey.uid.rawValue: uid]] as [String: Any]
            
            document.setData(dictionary,
                             merge: true,
                             completion: { (error) in
                            
                                if let error = error {
                                    
                                    if bookingData == bookingDatas.last {
                                        
                                        completionHandler(Result.failure(error))
                                    }
                                } else {
                                    
                                    self.cloneBookingData(
                                        dictionary: dictionary,
                                        uid: uid,
                                        storeName: storeName,
                                        documentID: documentID)
                                    if bookingData == bookingDatas.last {
                                        
                                        completionHandler(Result.success(FirebaseEnum.addBooking.rawValue))
                                    }
                                }
                            
            })
        }
    }
    
    private func cloneBookingData(dictionary: [String: Any], uid: String, storeName: String, documentID: String) {
        
        let documemntInBooking = dataBase()
                        .collection(FirebaseEnum.booking.rawValue)
                        .document(storeName)
                        .collection(uid)
                        .document(documentID)
        
        documemntInBooking.setData(dictionary, merge: true)
        
        let documentInUser = dataBase()
            .collection(FirebaseEnum.user.rawValue)
            .document(uid).collection(FirebaseEnum.booking.rawValue)
            .document(documentID)
        
        documentInUser.setData([UsersKey.documentID.rawValue: documentID,
                      UsersKey.store.rawValue: storeName],
                     merge: true)
    }
    
    func getUserBookingData() {
        
        guard let uid = user().currentUser?.uid else { return }
        
        let userBookingDocument = dataBase()
                                    .collection(FirebaseEnum.user.rawValue)
                                    .document(uid)
                                    .collection(FirebaseEnum.booking.rawValue)
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
        dataBase()
            .collection(FirebaseEnum.booking.rawValue)
            .document(storeName)
            .collection(uid)
            .document(listID)
            .getDocument { (document, _) in
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
        
        let userBookingDocument = dataBase()
            .collection(FirebaseEnum.user.rawValue)
            .document(uid)
            .collection(FirebaseEnum.store.rawValue)
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
            .collection(FirebaseEnum.confirm.rawValue)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    print(error)
                    return
                }
                
                guard let documents = querySnapshot?.documents else {return}
                
                for document in documents {
                    
                    guard let data = UserBookingData(dictionary: document.data()) else {return}
                    
                    self.mangerStoreData.append(data)
                }
        }
    }
}

enum FirebaseEnum: String {
    
    case user = "Users"
    case fail = "錯誤"
    case logout = "登出成功"
    case store = "Store"
    case booking = "Booking"
    case confirm = "BookingConfirm"
    case addBooking = "預約資料送出成功"
    case passwordChange = "更改密碼成功"
    case uploadSuccess = "檔案上傳成功"
}

enum FirebaseDataError: Error {
    
    var errorMessage: String {
        
        return "解碼錯誤"
    }

    case decodeFail
}

enum BookingStatus: String {
    
    case tobeConfirm
    case confirm
    case refuse
}

enum FirebaseBookingKey: String {
    
    case day
    case year
    case month
    case hours
    case user
    case pathID
    case status
}

enum UsersKey: String {
    
    case name
    case band
    case email
    case facebook
    case phone
    case uid
    case documentID
    case store
    case photoURL
    case status
    
    enum Status: String {
        
        case user = "一般用戶"
        case manger = "店家"
    }

}
