//
//  UserListDataStruct.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/18.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct UserBookingData {
    
    let bookingTime : BookingTime
    let status: String
    let pathID: String
    let userInfo: UserData
    let userUID: String
    
    init? (dictionary: [String: Any]) {
        
        guard let bookingTime = BookingTime(dictionary: dictionary) else {return nil}
        guard let userInfo = dictionary[FirebaseBookingKey.user.rawValue] as? [String: String] else { return nil }
        guard let pathID = dictionary[FirebaseBookingKey.pathID.rawValue] as? String else {return nil}
        guard let userUID = userInfo[UsersKey.uid.rawValue] else {return nil}
        guard let user = UserData(dictionary: userInfo) else {return nil}
        guard let status = dictionary[FirebaseBookingKey.status.rawValue] as? String else {return nil}
        self.bookingTime = bookingTime
        self.status = status
        self.pathID = pathID
        self.userInfo = user
        self.userUID = userUID
    }
    
}

struct UserListData {
    
    let documentID: String
    let store: String
    
    init?(dictionary: [String: Any]) {
        
        guard let listID = dictionary[UsersKey.documentID.rawValue] as? String else { return nil }
        guard let storeName = dictionary[UsersKey.store.rawValue] as? String else { return nil }
        self.documentID = listID
        self.store = storeName
    }
}
