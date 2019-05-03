//
//  ErrorMessageEnum.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/1.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

enum InputError: Error {
    
    case unknow
    case storeName
    case storeCity
    case phoneIsEmpty
    case phoneIsLessThanSeven
    case phoneIsNotNumber
    case address
    case openTimeIsEmpty
    case openTimeIsNotNumber
    case openTimeIsNotTwoCount
    case closeTimeIsEmpty
    case closeTimeIsNotNumber
    case closeTimeIsNotTwoCount
    case information
    case openTimeThanCloseTime
    case roomName(Int)
    case priceIsEmpty(Int)
    case priceIsNotNumber(Int)
    case imageURLDidNotGet
    case bookingCreat
    case whitespaces
    
    var localizedDescription: String {
        
        switch self {
        case .storeName:
            
            return "輸入名字不能為空"
        case .storeCity:
            
            return "輸入城市不能為空"
            
        case .phoneIsEmpty:
            
            return "輸入電話不能為空"
        case .phoneIsLessThanSeven:
            
            return "輸入電話小於七個號碼"
        case .phoneIsNotNumber:
            
            return "你輸入的電話不是數字"
        case .address:
            return "輸入地址不能為空"
            
        case .openTimeIsEmpty:
            
            return "開店時間不能為空"
        case .openTimeIsNotNumber:
            
            return "開店時間輸入不是數字"
        case .openTimeIsNotTwoCount:
            
            return "開店時間請輸入24小時制的兩位數"
        case .closeTimeIsEmpty:
            
            return "關店時間不能為空"
        case .closeTimeIsNotNumber:
            return "關店時間輸入不是數字"
        case .closeTimeIsNotTwoCount:
            return "關店時間請輸入24小時制的兩位數"
        case .information:
            return "店家資訊不能為空"
        case .openTimeThanCloseTime:
            return "關店時間比開店還早或一樣"
        case .roomName(let index):
            return "第\(index)個團室名字是空的"
        case .priceIsEmpty(let index):
            return "第\(index)個團室價錢是空的"
        case .priceIsNotNumber(let index):
            return "第\(index)個團室價錢不是數字"
        case .imageURLDidNotGet:
            return "圖片上傳中有錯誤\n請重新嘗試"
        case .bookingCreat:
            return "預定時網路發生問題\n請重新確認您的訂單是否完成"
        case .unknow:
            return "未知的錯誤\n趕快找Bug囉"
        case .whitespaces:
            return "請不要只輸入空格"
        }
    }
}
