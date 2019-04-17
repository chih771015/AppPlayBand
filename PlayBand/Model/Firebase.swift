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
    var userData: UserData?
    var storeDatas: [StoreData] = []
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
        
        getUserInfo()
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
//            print(document?.data()!["test"])
//            guard let data = document?.data()!["test"] as? DocumentReference else {return}
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
            
            let document = dataBase().collection(FirebaseEnum.store.rawValue).document(storeName).collection(FirebaseEnum.confirm.rawValue).document()
            let dictionary = [FirebaseBookingKey.year.rawValue: bookingData.date.year,
                              FirebaseBookingKey.month.rawValue: bookingData.date.month,
                              FirebaseBookingKey.day.rawValue: bookingData.date.day,
                              FirebaseBookingKey.hours.rawValue: bookingData.hour,
                              FirebaseBookingKey.pathID.rawValue: document.documentID,
                              FirebaseBookingKey.user.rawValue:
                                [UsersKey.name.rawValue: user.name,
                                 UsersKey.band.rawValue: user.band,
                                 UsersKey.email.rawValue: user.email,
                                 UsersKey.phone.rawValue: user.phone,
                                 UsersKey.facebook.rawValue: user.facebook,
                                 UsersKey.uid.rawValue: uid]] as [String : Any]
            
            document.setData(dictionary,
                             merge: true,
                             completion: { (error) in
                                
                            if bookingData == bookingDatas.last {
                                
                                if let error = error {
                                    
                                    completionHandler(Result.failure(error))
                                } else {
                                    
                                    completionHandler(Result.success(FirebaseEnum.addBooking.rawValue))
                                }
                            }
            })
//            dataBase()
//                .collection(FirebaseEnum.store.rawValue)
//                .document(storeName)
//                .collection(FirebaseEnum.confirm.rawValue).addDocument(
//            data: [FirebaseBookingKey.year.rawValue: bookingData.date.year,
//                   FirebaseBookingKey.month.rawValue: bookingData.date.month,
//                   FirebaseBookingKey.day.rawValue: bookingData.date.day,
//                   FirebaseBookingKey.hours.rawValue: bookingData.hour,
//                   FirebaseBookingKey.user.rawValue:
//                    [UsersKey.name.rawValue: user.name,
//                      UsersKey.band.rawValue: user.band,
//                      UsersKey.email.rawValue: user.email,
//                      UsersKey.phone.rawValue: user.phone,
//                      UsersKey.facebook.rawValue: user.facebook,
//                      UsersKey.uid.rawValue: uid]]) { (error) in
//
//                            if bookingData == bookingDatas.last {
//
//                                if let error = error {
//
//                                    completionHandler(Result.failure(error))
//                                } else {
//
//                                    completionHandler(Result.success(FirebaseEnum.addBooking.rawValue))
//                                }
//                            }
//                    }
        }
    }
    
    private func cloneBookingData(dictionary: [String: Any], uid: String, storeName: String, documentID: String) {
        
        let documemnt = dataBase().collection(FirebaseEnum.booking.rawValue).document(storeName).collection(uid).document(documentID)
        documemnt.setData(dictionary, merge: true)
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
}

enum FirebaseDataError: Error {
    
    var errorMessage: String {
        
        return "解碼錯誤"
    }

    case decodeFail
}

enum FirebaseBookingKey: String {
    
    case day
    case year
    case month
    case hours
    case user
    case pathID
}

enum UsersKey: String {
    
    case name
    case band
    case email
    case facebook
    case phone
    case uid
}

