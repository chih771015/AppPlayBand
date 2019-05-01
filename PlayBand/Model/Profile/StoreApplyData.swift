//
//  StoreApplyData.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct StoreApplyData {
    
    let storeData: StoreData
    let user: UserData
    let status: String
    let storeMessage: String
    
    init?(dictionary: [String: Any]) {
        
        guard let storeData = StoreData(dictionary: dictionary) else { return nil }
        guard let user = UserData(dictionary: dictionary[FirebaseBookingKey.user.rawValue] as? [String: Any] ?? ["hi": "Yo"]) else { return nil }
        guard let storeMessage = dictionary[FirebaseBookingKey.storeMessage.rawValue] as? String else { return nil }
        guard let status = dictionary[FirebaseBookingKey.status.rawValue] as? String else { return nil }
        self.storeData = storeData
        self.user = user
        self.status = status
        self.storeMessage = storeMessage
    }
}
