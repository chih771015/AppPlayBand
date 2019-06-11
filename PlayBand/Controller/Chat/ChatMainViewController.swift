//
//  ChatMainViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ChatMainViewController: BaseTableViewController {
    
    private enum ChangeModel {
        
        case noStoreMessage
        case title
        case cancelTitle
        
        var title: String {
            
            switch self {
            case .noStoreMessage:
                return "您沒有店家可以選擇"
            case .title:
                return "選擇聊天模式"
            case .cancelTitle:
                return "取消"
            }
        }
    }
    
    @IBAction func switchChatModel(_ sender: Any) {
        
        if userManager.userManagerStore.isEmpty {
            
            self.addErrorAlertMessage(message: ChangeModel.noStoreMessage.title)
            return
        }
        var actionAndHandlers: [ActionHandler] = [(ChatCategoryEnum.user.title, { [weak self] _ in
            self?.setupModel(with: .user)
        })]
        
        for store in FirebaseManager.shared.storeName {
            
            let action: ActionHandler = (ChatCategoryEnum.store(store).title, { [weak self] _ in
                self?.setupModel(with: .store(store))})
            actionAndHandlers.append(action)
        }
        
        self.addAlertActionSheet(
            title: ChangeModel.title.title, message: nil,
            actionTitleAndHandlers: actionAndHandlers,
            cancelTitle: ChangeModel.cancelTitle.title)
    }
    
    @IBAction func actionAddChatStore(_ sender: Any) {
        
        var actionAndHandlers: [ActionHandler] = []
        
        for store in FirebaseManager.shared.storeDatas.map({$0.name}) {
            
            let action: ActionHandler = ("與\(store)聊天", { [weak self] _ in self?.pushNextVC(storeName: store)
                })
            actionAndHandlers.append(action)
        }
        
        self.addAlertActionSheet(
            title: "選擇聊天店家", message: nil,
            actionTitleAndHandlers: actionAndHandlers,
            cancelTitle: ChangeModel.cancelTitle.title)
    }
    
    func pushNextVC(storeName: String) {
        
        guard let storeData = FirebaseManager.shared.storeDatas.first(where: {$0.name == storeName}) else {
            return
        }
        
        chatManager.selectName = storeData.name
        chatManager.selectImage = storeData.photourl
        chatManager.selectUID = storeData.name
        pushVC()
    }
    
    private func pushVC() {
        chatManager.setupDetailData()
        guard let nextVC = UIStoryboard.chat.instantiateViewController(withIdentifier: String(describing: ChatDetailViewController.self)) as? ChatDetailViewController else {return}
        nextVC.chatManager = self.chatManager
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    let userManager = UserManager()
    let storeManager = StoreManager()
    let chatManager = ChatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchData(with: chatManager.chatModel)
        self.navigationItem.title = chatManager.chatModel.title
    }
    
    private func setupModel(with type: ChatCategoryEnum) {
        
        chatManager.chatModel = type
        self.navigationItem.title = type.title
        fetchData(with: type)
    }
    
    private func fetchData(with type: ChatCategoryEnum) {
        PBProgressHUD.addLoadingView()
        switch type {
        case .user:
            
            chatManager.fetchNewChatUserData { [weak self] result in self?.checkResult(result: result)}
        case .store:
            
            chatManager.fetchNewChatStoreData { [weak self] result in self?.checkResult(result: result)}
        }
    }
    
    private func checkResult(result: Result<Bool>) {
        
        switch result {
            
        case .success:
            break
        case .failure(let error):
            self.addErrorTypeAlertMessage(error: error)
        }
        tableView.endHeaderRefreshing()
        PBProgressHUD.dismissLoadingView()
        tableView.reloadData()
    }
    
    override func setupTableViewCell() {
        
        tableView.lv_registerCellWithNib(identifier: String(describing: ChatMainTableViewCell.self), bundle: nil)
        tableView.addRefreshHeader { [weak self] in self?.fetchData(with: self?.chatManager.chatModel ?? .user)}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChatMainTableViewCell.self), for: indexPath
            ) as? ChatMainTableViewCell else {
            
            return UITableViewCell()
        }
        let data = chatManager.newChatData[indexPath.row]
        cell.setupCell(title: data.name, description: data.description, imageURL: data.imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatManager.newChatData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = chatManager.newChatData[indexPath.row]
        chatManager.selectImage = data.imageURL ?? ""
        chatManager.selectName = data.name
        chatManager.selectUID = data.uid
        pushVC()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if chatManager.newChatData.count == 0 {
            
            return UIView.noDataView()
        } else {
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if chatManager.newChatData.count == 0 {
            
            return UITableView.automaticDimension
            
        } else {
            
            return 0.1
        }
    }
}
