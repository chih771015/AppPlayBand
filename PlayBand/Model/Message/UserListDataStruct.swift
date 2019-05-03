//
//  UserListDataStruct.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/18.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct UserBookingData {
    
    let bookingTime : BookingTimeAndRoom
    let status: String
    let pathID: String
    let userInfo: UserData
    let userUID: String
    let store: String
    let userMessage: String
    let storeMessage: String
    
    init? (dictionary: [String: Any]) {
        
        guard let bookingTime = BookingTimeAndRoom(dictionary: dictionary) else {return nil}
        guard let userInfo = dictionary[FirebaseBookingKey.user.rawValue] as? [String: Any] else { return nil }
        guard let pathID = dictionary[FirebaseBookingKey.pathID.rawValue] as? String else {return nil}
        guard let userUID = userInfo[UsersKey.uid.rawValue] as? String else {return nil}
        guard let user = UserData(dictionary: userInfo) else {return nil}
        guard let status = dictionary[FirebaseBookingKey.status.rawValue] as? String else {return nil}
        guard let store = dictionary[FirebaseBookingKey.store.rawValue] as? String  else {return nil}
        if let userMessage = dictionary[FirebaseBookingKey.userMessage.rawValue] as? String {
            
            self.userMessage = userMessage
        } else {
            
            self.userMessage = ""
        }
        if let storeMessage = dictionary[FirebaseBookingKey.storeMessage.rawValue] as? String {
            
            self.storeMessage = storeMessage
        } else {
            
            self.storeMessage = ""
        }
        self.bookingTime = bookingTime
        self.status = status
        self.pathID = pathID
        self.userInfo = user
        self.userUID = userUID
        self.store = store
    }
    
    func returnStatusString() -> String {
        
        switch status {
        case BookingStatus.confirm.rawValue:
            return BookingStatus.confirm.display
        case BookingStatus.refuse.rawValue:
            return BookingStatus.refuse.display
        case BookingStatus.tobeConfirm.rawValue:
            return BookingStatus.tobeConfirm.display
        default:
            return "BUG"
        }
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
