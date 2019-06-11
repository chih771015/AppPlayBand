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
        getChatDataAll()
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
        
        tableView.lv_registerCellWithNib(identifier: String(describing: ChatDetailTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChatDetailTableViewCell.self), for: indexPath
            ) as? ChatDetailTableViewCell else {
                
                return UITableViewCell()
        }
        let index = chatManager.selectChatData.count - 1 - indexPath.row
        let data = chatManager.selectChatData[index]
        if data.uid != chatManager.selectUID {
            
            cell.setupCellinMain(message: data.message, name: chatManager.mainName, imageURL: chatManager.mainImage)
        } else {
            
            cell.setupCellinOtherSide(message: data.message, name: chatManager.selectName, imageURL: chatManager.selectImage)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row < 2 {
            
            chatManager.addCellCount()
        }
    }
    
    func scrollTableViewToBottom() {
        
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
        if lastRow < 0 {
            return
        }
        let indexPath = IndexPath(row: lastRow, section: 0);
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}

extension ChatDetailViewController: ChatManagerDelegate {
    
    func newData(_ chatManager: ChatManager) {
        PBProgressHUD.dismissLoadingView()
        tableView.reloadData()
        scrollTableViewToBottom()
    }
}
