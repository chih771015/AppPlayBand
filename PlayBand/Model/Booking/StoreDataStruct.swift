//
//  StoreDataStruct.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/16.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct StoreData {
    
    let name: String
    let openTime: String
    let closeTime: String
    let phone: String
    let address: String
    let photourl: String
    let information: String
    var rooms: [Room] = []
    let city: String
    var images: [String] = []
    
    struct Room {
        
        var name: String
        var price: String
        init (name: String, price: String) {
            
            self.name = name
            self.price = price
        }
        
        init() {
            
            self.name = ""
            self.price = ""
        }
    }
    
    init? (dictionary: [String: Any]) {
        guard let name = dictionary[StoreDataKey.name.rawValue] as? String else {return nil}
        guard let openTime = dictionary[StoreDataKey.opentime.rawValue] as? String else {return nil}
        guard let closeTime = dictionary[StoreDataKey.closetime.rawValue] as? String else {return nil}
        guard let phone = dictionary[StoreDataKey.phone.rawValue] as? String else {return nil}
        guard let address = dictionary[StoreDataKey.address.rawValue] as? String else {return nil}
        guard let photourl = dictionary[StoreDataKey.photourl.rawValue] as? String else {return nil}
        guard let information = dictionary[StoreDataKey.information.rawValue] as? String else {return nil}
        guard let rooms = dictionary[StoreDataKey.rooms.rawValue] as? [[String: Any]] else {return nil}
        guard let city = dictionary[StoreDataKey.city.rawValue] as? String else {return nil}
        for room in rooms {
            
            guard let name = room[StoreDataKey.name.rawValue] as? String else {return nil}
            guard let price = room[StoreDataKey.price.rawValue] as? String else {return nil}
            let roomData = Room(name: name, price: price)
            self.rooms.append(roomData)
        }
        
        if let images = dictionary[StoreDataKey.images.rawValue] as? [String] {
            
            self.images = images
        }
        self.name = name
        self.openTime = openTime
        self.closeTime = closeTime
        self.phone = phone
        self.address = address
        self.photourl = photourl
        self.information = information
        self.city = city
    }
    
    enum StoreDataKey: String {
        
        case name
        case opentime
        case closetime
        case phone
        case address
        case photourl
        case rooms
        case price
        case information
        case city
        case images
    }
    
    func getStoreOpenHours() -> Int {
        
        guard let close = Int(closeTime) else {return 0}
        guard let open = Int(openTime) else {return 0}
        return close - open
    }
}
