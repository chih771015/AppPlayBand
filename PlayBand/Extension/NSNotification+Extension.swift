//
//  NSNotification+Extension.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

extension NSNotification {
    
    static let storeDatas = Notification.Name("StoreDatas")
    
    static let userData = NSNotification.Name(rawValue: NotificationCenterName.userData.rawValue)
    
    static let bookingData = NSNotification.Name(
        rawValue: NotificationCenterName.bookingData.rawValue)
}
