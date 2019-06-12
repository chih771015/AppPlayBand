//
//  ChatManager.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import Foundation

class ChatManager {
    
    var chatModel = ChatCategoryEnum.user
    
    var newChatData: [ChatData] = []
    
    var chatData: [String: [Message]] = [:]
    
    var selectChatData: [Message] = []
    
    var selectUID = String()
    
    var selectImage = String()
    
    var selectName = String()
    
    var mainName = String()
    
    var mainUID = String()
    
    var mainImage = String()
    
    var cellCount: Int {
        
        if selectChatData.count < cellCountValue {
            
            return selectChatData.count
        } else {
            
            return cellCountValue
        }
    }
    
    private var cellCountValue = 15
    
    weak var delegate: ChatManagerDelegate?
    
    let firebaseChatManager = FirebaseChatManager()
    
    private func sendMessageToStore(message: String, storeName: String) {
        
        firebaseChatManager.sendNewMessageToStore(message: message, storeName: storeName)
    }
    
    func setupDetailData() {
        
        switch chatModel {
        case .user:
            guard let userData = FirebaseManager.shared.userData else {return}
            guard let uid = FirebaseManager.shared.user().currentUser?.uid else {return}
            mainImage = userData.photoURL ?? ""
            mainUID = uid
            mainName = userData.name
        case .store(let storeName):
            guard let storeData = FirebaseManager.shared.storeDatas.first(where: {$0.name == storeName}) else {
                return
            }
            self.mainName = storeData.name
            self.mainImage = storeData.photourl
            self.mainUID = storeData.name
        }
    }
    
    func sendMessage(message: String) {
        
        switch chatModel {
            
        case .store(let store):
            
            sendMessageToUser(storeName: store, message: message)
        case .user:
            sendMessageToStore(message: message, storeName: selectUID)
        }
    }
    
    private func sendMessageToUser(storeName: String, message: String) {
        
        firebaseChatManager.sendNewMeesageToUser(userName: selectName, storeName: storeName, message: message, uid: selectUID, userURL: selectImage)
    }
    
    func fetchNewChatStoreData(completionHandler: @escaping (Result<Bool>) -> Void) {
        
        let storeName = chatModel.title
        
        firebaseChatManager.getStoreNewChatData(storeName: storeName) { [weak self] (result) in
            switch result {
                
            case .success(let data):
                self?.filterBlackList(datas: data)
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchNewChatUserData(completionHandler: @escaping (Result<Bool>) -> Void) {
        
        firebaseChatManager.getUserNewChatData { [weak self] (result) in
            
            switch result {
                
            case .success(let data):
                self?.filterBlackList(datas: data)
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func filterBlackList(datas: [ChatData]) {
        
        var filterDatas = datas
        if let userData = FirebaseManager.shared.userData {
            
            for store in userData.storeBlackList {
                
                filterDatas = filterDatas.filter({$0.uid != store})
            }
            
            for user in userData.userBlackLists {
                
                filterDatas = filterDatas.filter({$0.uid != user.uid})
            }
        }
        newChatData = filterDatas
    }
    
    func getDetailMessage(completionHandler: @escaping (Result<Bool>) -> Void) {
        firebaseChatManager.delegate = self
        switch chatModel {
        case .user:
            self.getUserDetail(completionHandler: completionHandler)
        case .store(let storeName):
            
            getStoreDetail(storeName: storeName, completionHandler: completionHandler)
        }
    }
    
    func getUserDetail(completionHandler: @escaping (Result<Bool>) -> Void) {
        
        firebaseChatManager.getUserMessageAll(storeName: selectUID) { [weak self] (result) in
            
            switch result {
                
            case .success(let data):
                
                self?.sortMessage(data: data)
                completionHandler(.success(true))
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    func getStoreDetail(storeName: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        
        firebaseChatManager.getStoreMessageAll(storeName: storeName, userUID: selectUID) { [weak self] (result) in
            
            switch result {
                
            case .success(let data):
                self?.sortMessage(data: data)
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func sortMessage(data: [Message]) {
        
        var messageData = data
        messageData.sort(by: <)
        self.selectChatData = messageData
    }
    
    private func newData() {
        
        delegate?.newData(self)
    }
    
    func removeListen() {
        
        firebaseChatManager.listener?.remove()
    }
    
    func addCellCount() {
        
        if cellCountValue < selectChatData.count {
            
            cellCountValue += 10
            delegate?.reloadTableView(self)
        }
    }
    
    func resetCellCount() {
        
        cellCountValue = 15
    }
}

extension ChatManager: FirebaseChatDelegate {
    
    func chatDataNew(_ firebaseChatManager: FirebaseChatManager, messages: [Message]) {
        
        for message in messages {
            
            if selectChatData.first?.time.timeIntervalSinceReferenceDate.exponent == message.time.timeIntervalSinceReferenceDate.exponent
                && selectChatData.first?.message == message.message
                && selectChatData.first?.uid == message.uid {
                
                continue
            } else {
                
                selectChatData.append(message)
            }
        }
        selectChatData.sort(by: <)
        newData()
    }
}

protocol ChatManagerDelegate: AnyObject {
    
    func newData(_ chatManager: ChatManager)
    
    func reloadTableView(_ chatManager: ChatManager)
}
