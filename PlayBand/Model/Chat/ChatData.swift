//
//  ChatData.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

struct ChatData {
    
    let name: String
    let messages: [Message]
    let uid: String
    let imageURL: String
}

struct Message {
    
    let status: String
    let description: String
    let time: timespec
}
