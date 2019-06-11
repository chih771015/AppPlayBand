//
//  ChatData.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import Firebase

struct ChatData {
    
    let name: String
    let description: String
    let time: Date
    let uid: String
    let imageURL: String?
    
    init? (dictionary: [String: Any]) {
        
        guard let name = dictionary[ChatKey.name.rawValue] as? String else {
            
            return nil
        }
        guard let description = dictionary[ChatKey.description.rawValue] as? String else {
            
            return nil
        }
        guard let time = dictionary[ChatKey.time.rawValue] as? Timestamp else {
            
            return nil
        }
        guard let uid = dictionary[ChatKey.uid.rawValue] as? String else {
            
            return nil
        }
        
        if let imageURL = dictionary[ChatKey.imageURL.rawValue] as? String {
            
            self.imageURL = imageURL
        } else {
            
            self.imageURL = nil
        }
        self.name = name
        self.description = description
        self.time = time.dateValue()
        self.uid = uid
    }
}

struct Message: Comparable {
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.time > rhs.time
    }
    
    let uid: String
    let message: String
    let time: Date
    
    init? (dictionary: [String: Any]) {
        
        guard let message = dictionary[ChatKey.message.rawValue] as? String else {
            
            return nil
        }
        guard let time = dictionary[ChatKey.time.rawValue] as? Timestamp else {
            
            return nil
        }
        guard let uid = dictionary[ChatKey.uid.rawValue] as? String else {
            
            return nil
        }
        
        self.uid = uid
        self.message = message
        self.time = time.dateValue()
    }
}
