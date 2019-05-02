//
//  CheckTextFieldText.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class CheckTextFieldText {
    
    class func checkText(dataString: [ProfileContentCategory: String]) throws {
        
        for data in dataString {
            
            let value = data.value
            do {
                
                switch data.key {
                
                case .storeName:
                    
                    try CheckTextFieldText.storeNameCheck(value: value)
                case .storeCity:
                    
                    try CheckTextFieldText.storeCityCheck(value: value)
                case .storePhone:
                    
                    try CheckTextFieldText.phoneCheck(value: value)
                case .information:
              
                    try CheckTextFieldText.informationCheck(value: value)
                case .openTime:
                    
                    try CheckTextFieldText.openTimeCheck(value: value)
                case .closeTime:
                    
                    try CheckTextFieldText.closeTimeCheck(value: value)
                case .address:
                    
                    try CheckTextFieldText.addressCheck(value: value)
                default:
                    
                    throw InputError.unknow
                }
            } catch {
                
                throw error
            }
        }
    }
    
    class func storeNameCheck(value: String) throws {
        
        if value.isEmpty {
            
            throw InputError.storeName
        }
    }
    
    class func storeCityCheck(value: String) throws {
        
        if value.isEmpty {
            
            throw InputError.storeCity
        }
    }
    
    class func phoneCheck(value: String) throws {
    
        if value.isEmpty {
        
        throw InputError.phoneIsEmpty
        }
        if value.count <= 6 {
        
        throw InputError.phoneIsLessThanSeven
        }
        
        if Int(value) == nil {
        
        throw InputError.phoneIsNotNumber
        }
    }
    
    class func informationCheck(value: String) throws {
        
        if value.isEmpty {
            
            throw InputError.information
        }
    }
    
    class func openTimeCheck(value: String) throws {
        
        if value.isEmpty {
            
            throw InputError.openTimeIsEmpty
        }
        if Int(value) == nil {
            
            throw InputError.openTimeIsNotNumber
        }
        
        if value.count != 2 {
            
            throw InputError.openTimeIsNotTwoCount
        }
    }
    
    class func closeTimeCheck(value: String) throws {
        
        if value.isEmpty {
            
            throw InputError.closeTimeIsEmpty
        }
        if Int(value) == nil {
            
            throw InputError.closeTimeIsNotNumber
        }
        
        if value.count != 2 {
            
            throw InputError.closeTimeIsNotTwoCount
        }
    }
    
    class func addressCheck(value: String) throws {
        
        if value.isEmpty {
            
            throw InputError.address
        }
    }
    
    class func openTimeAndCloseTime(openTime: String, closeTime: String) throws {
        
        do {
            guard let open = Int(openTime) else {
                try CheckTextFieldText.openTimeCheck(value: openTime)
                return
            }
            
            guard let close = Int(closeTime) else {
                try CheckTextFieldText.closeTimeCheck(value: closeTime)
                return
            }
            
            if open >= close {
                
                throw InputError.openTimeThanCloseTime
            }
        } catch {
            
            throw error
        }
    }
}
