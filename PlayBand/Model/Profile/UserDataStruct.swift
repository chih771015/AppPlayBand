//
//  UserDataStruct.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/15.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct UserData {
    
    let name: String
    let phone: String
    let band: String
    let email: String
    let facebook: String
    let photoURL: String?
    let status: String?
    var storeBlackList: [String]
    var userBlackLists: [UserBlackList]
    var storeRejectUser: [String]
    init?(dictionary: [String: Any]) {
        
        guard let name = dictionary[UsersKey.name.rawValue] as? String else {return nil}
        guard let phone = dictionary[UsersKey.phone.rawValue] as? String else {return nil}
        guard let band = dictionary[UsersKey.band.rawValue] as? String else {return nil}
        guard let email = dictionary[UsersKey.email.rawValue] as? String else {return nil}
        guard let facebook = dictionary[UsersKey.facebook.rawValue] as? String else {return nil}
        if let storeBlackList = dictionary[UsersKey.storeBlackList.rawValue] as? [String] {
            
            self.storeBlackList = storeBlackList
        } else {
            
            self.storeBlackList = []
        }
        if let storeRejectUser = dictionary[UsersKey.storeRejectUser.rawValue] as? [String] {
            
            self.storeRejectUser = storeRejectUser
        } else {
            
            self.storeRejectUser = []
        }
        if let userBlackLists = dictionary[UsersKey.userBlackList.rawValue] as? [[String: Any]] {
            var users: [UserBlackList] = []
            for userBlackList in userBlackLists {
                
                if let user = UserBlackList(dictionary: userBlackList) {
                    
                   users.append(user)
                }
            }
            self.userBlackLists = users
        } else {
            
            self.userBlackLists = []
        }
        let status = dictionary[UsersKey.status.rawValue] as? String
        self.status = status
        self.name = name
        self.phone = phone
        self.band = band
        self.email = email
        self.facebook = facebook
        let photoURL = dictionary[UsersKey.photoURL.rawValue] as? String
        self.photoURL = photoURL
    }
    
    init(name: String, phone: String, band: String, email: String, facebook: String, status: String? = nil) {
        
        self.name = name
        self.phone = phone
        self.band = band
        self.email = email
        self.facebook = facebook
        self.photoURL = nil
        self.status = status
        self.storeBlackList = []
        self.storeRejectUser = []
        self.userBlackLists = []
    }

    struct UserBlackList {
        
        let name: String
        let uid: String
        init?(dictionary: [String: Any]) {
            
            guard let name = dictionary[UsersKey.name.rawValue] as? String else {return nil}
            guard let uid = dictionary[UsersKey.uid.rawValue] as? String else {return nil}
            self.name = name
            self.uid = uid
        }
    }
}
