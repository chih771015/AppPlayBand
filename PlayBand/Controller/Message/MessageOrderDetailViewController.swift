//
//  MessageOrderDetailViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/25.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageOrderDetailViewController: UIViewController {

    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!

    @IBAction func addBlackListAction(_ sender: Any) {
        
        self.addAlert(
            title: "你確定要將此使用者加入黑名單嗎?", message: "黑名單可以在設定頁面取消",
            actionTitle: "確認", cancelTitle: "取消", cancelHandler: nil) { [weak self] (_) in
                
                self?.addStoreBlackList()
        }
    }
    
    @IBAction func confirmAction() {
        
        guard let bookingData = self.bookingData else { return }
        
        PBProgressHUD.addLoadingView()
        
        storeManager.confirmBookingOrder(
            storeName: bookingData.store, pathID: bookingData.pathID,
            userUID: bookingData.userUID) { [weak self] (result) in
                
                PBProgressHUD.dismissLoadingView()
                
                switch result {
                    
                case .success(let message):
                    
                    self?.addSucessAlertMessage(
                        title: message, message: nil, completionHanderInDismiss: { [weak self] in
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                    
                case.failure(let error):
                    
                    self?.addErrorTypeAlertMessage(error: error)
                }
        }
    }
    
    @IBAction func refuseAction() {
    
        self.addTextFieldAlert(
        title: "拒絕一定要給理由\n請輸入回覆", actionTitle: "確認拒絕",
        cancelTitle: "返回", placeHolder: "請輸入回覆") { [weak self] (text) in
            
            do {
                let message = try CheckTextFieldText.whiteSpacesCheck(text: text)
                
                self?.rejectBooking(storeMessage: message)
            } catch {
                
                self?.addErrorTypeAlertMessage(error: error)
            }
        }
    }
    
    private var bookingData: UserBookingData?
    private var status = MessageFetchDataEnum.normal
    private let storeManager = StoreManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButtonView()
    }
    
    private func setupTableView() {
        
        tableView.lv_registerCellWithNib(
            identifier: String(describing: MessageDetailTableViewCell.self), bundle: nil)
        tableView.lv_registerCellWithNib(
            identifier: String(describing: MessageImageTableViewCell.self), bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setupNavigationItem() {
        
        switch status {
        case .normal:
            
            self.navigationItem.rightBarButtonItems?.removeAll()
        default:
            return
        }
    }
    
    func setupBookingData(data: UserBookingData, status: MessageFetchDataEnum) {
        
        self.bookingData = data
        self.status = status
        setupNavigationItem()
    }
    
    private func setupButtonView() {
        
        switch status {
        case .store:
            
            if bookingData?.status != FirebaseBookingKey.Status.refuse.rawValue {
                
                buttonViewHeight.constant = 70
            } else {
                
                buttonViewHeight.constant = 0
            }
        case .normal:
            buttonViewHeight.constant = 0
        }
    }

}

extension MessageOrderDetailViewController {
    
    private func addStoreBlackList() {
        
        guard let bookingData = self.bookingData else {
            return
        }
        PBProgressHUD.addLoadingView()
        FirebaseManager.shared.storeAddUserBlackList(
            userUid: bookingData.userUID, userName: bookingData.userInfo.name,
            storeNames: FirebaseManager.shared.storeName) { [weak self] (result) in
                PBProgressHUD.dismissLoadingView()
                switch result {
                    
                case .success(let message):
                    
                    self?.addSucessAlertMessage(
                        title: message, message: nil, completionHanderInDismiss: { [weak self] in
                            
                            self?.navigationController?.popViewController(animated: true)
                    })
                case .failure(let error):
                    
                    self?.addErrorTypeAlertMessage(error: error)
                }
        }
    }
    
    private func rejectBooking(storeMessage: String) {
        
        guard let bookingData = self.bookingData else { return }
        
        PBProgressHUD.addLoadingView()
        storeManager.rejectOrder(
            pathID: bookingData.pathID, storeName:
        bookingData.store, userUID: bookingData.userUID, storeMessage: storeMessage) { [weak self] (result) in
            
            PBProgressHUD.dismissLoadingView()
            
            switch result {
                
            case .success(let message):
                
                self?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                })
                
            case .failure(let error):
                
                self?.addErrorTypeAlertMessage(error: error)
            }
        }
    }
}

extension MessageOrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return status.headerForIndexPathInDetail(tableView: tableView, at: section, bookingData: bookingData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return status.orderDetailCellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return status.orderDetailCellType[indexPath.row]
            .cellForIndexPathInDetail(indexPath, tableView: tableView, data: bookingData)
    }
}
