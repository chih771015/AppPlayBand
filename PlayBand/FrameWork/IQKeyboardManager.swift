//
//  IQKeyboardManager.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/15.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

class IQKeyboard {
    
    static let shared = IQKeyboard()
    
    private init() {}
    
    func frameworkAction() {
        
        IQKeyboardManager.shared.enable = true
    }
}
