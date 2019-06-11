//
//  FirebaseCollectionNameEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum FirebaseCollectionName {
    
    case user
    case store
    case bookingConfirm
    case booking
    case inputString(String)
    case chatData
    case newChatData
    
    var name: String {
        
        switch self {
        case .user:
            return "Users"
        case .store:
            return "Store"
        case .bookingConfirm:
            return "BookingConfirm"
        case .booking:
            return "Booking"
        case .inputString(let string):
            return string
        case .newChatData:
            return "NewChatData"
        case .chatData:
            return "ChatData"
        }
    }
}
