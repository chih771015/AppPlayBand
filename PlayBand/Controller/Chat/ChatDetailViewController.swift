//
//  ChatDetailViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/6/10.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ChatDetailViewController: BaseTableViewController {
    
    var chatManager = ChatManager()
    
    @IBAction func barButtonAction(_ sender: Any) {
        
        self.addAlert(
            title: "你要將\(chatManager.selectName)加入黑名單嗎?", message: "黑名單可以在設定頁面取消",
            actionTitle: "確認", cancelTitle: "取消", cancelHandler: nil) { [weak self] (_) in
                
              self?.addBlackList()
        }
    }
    
    func addBlackList() {
        PBProgressHUD.addLoadingView()
        switch chatManager.chatModel {
        case .user:
            addStoreBlackList()
        case .store:
            addUserBlackList()
        }
    }
    
    private func addStoreBlackList() {
        
        FirebaseManager.shared.userAddStoreBlackList(storeName: chatManager.selectUID) { [weak self] (result) in
            self?.addBlackListResult(result: result)
        }
    }
    
    private func addUserBlackList() {
        
        let storeNames = FirebaseManager.shared.storeName
        FirebaseManager.shared.storeAddUserBlackList(userUid: chatManager.selectUID, userName: chatManager.selectName, storeNames: storeNames) {[weak self] (result) in
            self?.addBlackListResult(result: result)
        }
    }
    
    private func addBlackListResult(result: Result<String>) {
        PBProgressHUD.dismissLoadingView()
        switch result {
        case .success(let message):
            self.addSucessAlertMessage(title: message, message: nil) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        case .failure(let error):
            self.addErrorTypeAlertMessage(error: error)
        }
    }
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendAction() {
        
        guard let message = textField.text, !message.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        chatManager.sendMessage(message: message)
        textField.text = nil
    }
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        PBProgressHUD.addLoadingView()
        chatManager.delegate = self
   //     self.tableView.transform = CGAffineTransform(rotationAngle: .pi)
        getChatDataAll()
        
        tableView.addRefreshHeader { [weak self] in
            self?.chatManager.addCellCount()
            self?.tableView.endHeaderRefreshing()
        }
        self.navigationItem.title = chatManager.selectName
    }
    
    func setupSendButton() {
        
        sendButton.setImage(UIImage.asset(.send), for: .normal)
        sendButton.setImage(UIImage.asset(.send), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getChatDataAll() {
        chatManager.selectChatData = []
        chatManager.getDetailMessage { [weak self] (result) in
            
            PBProgressHUD.dismissLoadingView()
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.addErrorTypeAlertMessage(error: error)
            }
            self?.tableView.reloadData()
        }
        
    }
    
    override func setupTableViewCell() {
        
        tableView.lv_registerCellWithNib(
            identifier: String(describing: ChatDetailTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChatDetailTableViewCell.self), for: indexPath
            ) as? ChatDetailTableViewCell else {
                
                return UITableViewCell()
        }
        let index = chatManager.selectChatData.count - (chatManager.selectChatData.count - tableView.numberOfRows(inSection: indexPath.section)) - 1 - indexPath.row
        let data = chatManager.selectChatData[index]
        
        if data.uid != chatManager.selectUID {
            
            cell.setupCellinMain(message: data.message,
                                 name: chatManager.mainName,
                                 imageURL: chatManager.mainImage)
        } else {
            
            cell.setupCellinOtherSide(message: data.message,
                                      name: chatManager.selectName,
                                      imageURL: chatManager.selectImage)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatManager.cellCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    deinit {
        chatManager.removeListen()
        chatManager.resetCellCount()
    }
    
    func scrollTableViewToBottom() {
        
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
        if lastRow < 0 {
            return
        }
        let indexPath = IndexPath(row: lastRow, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}

extension ChatDetailViewController: ChatManagerDelegate {
    
    func reloadTableView(_ chatManager: ChatManager) {
        
        let old = tableView.numberOfRows(inSection: 0)
        tableView.reloadData()
        let new = tableView.numberOfRows(inSection: 0)
        let row = new - old
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: false)
    
    }

    func newData(_ chatManager: ChatManager) {
        PBProgressHUD.dismissLoadingView()
        tableView.reloadData()
        scrollTableViewToBottom()
    }
}
