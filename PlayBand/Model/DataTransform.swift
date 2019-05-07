//
//  DataTransform.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/19.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class DataTransform {
    
    class func getUserBookingDictionary(
        
        bookingData: BookingTimeAndRoom,
        documentID: String,
        uid: String,
        user: UserData,
        name: String,
        userMessage: String) -> [String: Any] {

        let dictionary = [FirebaseBookingKey.year.rawValue: bookingData.date.year,
                              FirebaseBookingKey.month.rawValue: bookingData.date.month,
                              FirebaseBookingKey.day.rawValue: bookingData.date.day,
                              FirebaseBookingKey.hours.rawValue: bookingData.hour,
                              FirebaseBookingKey.pathID.rawValue: documentID,
                              FirebaseBookingKey.status.rawValue: FirebaseBookingKey.Status.tobeConfirm.rawValue,
                              FirebaseBookingKey.store.rawValue: name,
                              FirebaseBookingKey.room.rawValue: bookingData.room,
                              FirebaseBookingKey.userMessage.rawValue: userMessage,
                              FirebaseBookingKey.price.rawValue: bookingData.price,
                              FirebaseBookingKey.storeMessage.rawValue: "尚未回復",
                              FirebaseBookingKey.user.rawValue:
                                [UsersKey.name.rawValue: user.name,
                                 UsersKey.band.rawValue: user.band,
                                 UsersKey.email.rawValue: user.email,
                                 UsersKey.phone.rawValue: user.phone,
                                 UsersKey.facebook.rawValue: user.facebook,
                                 UsersKey.uid.rawValue: uid,
                                 UsersKey.photoURL.rawValue: user.photoURL]] as [String: Any]
        
        return dictionary
    }

    class func userData(userData: UserData) -> [String: Any] {
        
        if userData.status != nil {
            let dictionary = [UsersKey.name.rawValue: userData.name, UsersKey.band.rawValue: userData.band,
                UsersKey.email.rawValue: userData.email, UsersKey.phone.rawValue: userData.phone,
                UsersKey.facebook.rawValue: userData.facebook,
                UsersKey.status.rawValue: userData.status]
            
            return dictionary
        } else {
            
            let dictionary = [UsersKey.name.rawValue: userData.name, UsersKey.band.rawValue: userData.band,
                              UsersKey.email.rawValue: userData.email, UsersKey.phone.rawValue: userData.phone,
                               UsersKey.facebook.rawValue: userData.facebook]
            return dictionary
        }
    }
    
    class func dataArrayReturnWithoutOption<T>(datas: [T?]) -> [T] {
        
        var returnDatas: [T] = []
        
        for data in datas {
            
            if let returnData = data {
                
                returnDatas.append(returnData)
            }
        }
        
        return returnDatas
    }
}
