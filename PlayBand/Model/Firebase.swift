//
//  Firebase.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/13.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import Firebase

class FirebaseSingle {
    
    typealias AuthResult = (AuthDataResult?, Error?) -> Void
    typealias ListeningResult = (Auth, User?) -> Void
    
    static let shared = FirebaseSingle()
    
    let user = { Auth.auth() }
    let dataBase = { Firestore.firestore() }
    var userData: UserData?
    private init () {}
    
    func signUpAccount(email: String, password: String, completionHandler: @escaping AuthResult) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completionHandler)
    }
    
    func signInAccount(email: String, password: String, completionHandler: @escaping AuthResult) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completionHandler)
    }
    
    func configure() {
        
        FirebaseApp.configure()
        FirebaseSingle.shared.listenAccount { (auth, user) in
            
            self.getUserInfo()
        }
        
        getUserInfo()
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
    FirebaseSingle.shared.dataBase().collection(FirebaseEnum.user.rawValue).document(uid).setData([
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
}

enum FirebaseEnum: String {
    
    case user = "Users"
    case fail = "錯誤"
    case logout = "登出成功"
}

enum UsersKey: String {
    
    case name
    case band
    case email
    case facebook
    case phone
}
