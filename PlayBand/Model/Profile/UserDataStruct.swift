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
    
    init?(dictionary: [String: Any]) {
        
        guard let name = dictionary[UserEnum.name.rawValue] as? String else {return nil}
        guard let phone = dictionary[UserEnum.phone.rawValue] as? String else {return nil}
        guard let band = dictionary[UserEnum.band.rawValue] as? String else {return nil}
        guard let email = dictionary[UserEnum.email.rawValue] as? String else {return nil}
        guard let facebook = dictionary[UserEnum.facebook.rawValue] as? String else {return nil}
        self.name = name
        self.phone = phone
        self.band = band
        self.email = email
        self.facebook = facebook
    }
    init(name: String, phone: String, band: String, email: String, facebook: String) {
        self.name = name
        self.phone = phone
        self.band = band
        self.email = email
        self.facebook = facebook
    }
    
}

enum UserEnum: String {
    
    case name
    case phone
    case band
    case email
    case facebook
}
