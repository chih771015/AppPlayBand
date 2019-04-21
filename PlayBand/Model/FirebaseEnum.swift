//
//  FirebaseEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/19.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

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
    case mangerConfirm = "預約回覆成功"
    case delete = "Delete"
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
    case store
    case userMessage
    case storeMessage
    
    enum Store: String {
        
        case uid
        case storeName
    }
    
    enum Status: String {
        
        case tobeConfirm
        case confirm
        case refuse
    }
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
