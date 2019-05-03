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
    
    @IBAction func confirmAction() {
        
        guard let bookingData = self.bookingData else { return }
        
        FirebaseManger.shared.updataBookingConfirm(
            storeName: bookingData.store, pathID: bookingData.pathID,
            userUID: bookingData.userUID) { [weak self] (result) in
                
                switch result {
                    
                case .success(let message):
                    
                    self?.addSucessAlertMessage(
                        title: message, message: nil, completionHanderInDismiss: { [weak self] in
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                    
                case.failure(let error):
                    
                    self?.addErrorAlertMessage(
                        title: FirebaseEnum.fail.rawValue,
                        message: error.localizedDescription,
                        completionHanderInDismiss: nil)
                    
                }
        }
    }
    
    @IBAction func refuseAction() {
        
        guard let bookingData = self.bookingData else { return }
        
        FirebaseManger.shared.refuseBooking(
            pathID: bookingData.pathID, storeName:
        bookingData.store, userUID: bookingData.userUID) { [weak self] (result) in
            switch result {
                
            case .success(let message):
                
                self?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                })

            case .failure(let error):
                
                self?.addErrorAlertMessage(
                    title: FirebaseEnum.fail.rawValue,
                    message: error.localizedDescription,
                    completionHanderInDismiss: nil)
            }
        }
    }
    
    private var bookingData: UserBookingData?
    private var status = MessageFetchDataEnum.normal
    
    private let cellDatas: [MessageCategory] = [
        .storeName, .documentID, .status, .time, .hours, .userName, .uid, .userEmail,
        .userPhone, .userFacebook, .userMessage]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButtonView()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationData(notifcation:)), name: NSNotification.storeDatas, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTableView() {
        
        tableView.lv_registerCellWithNib(
            identifier: String(describing: MessageDetailTableViewCell.self), bundle: nil)
        tableView.lv_registerCellWithNib(
            identifier: String(describing: MessageImageTableViewCell.self), bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupBookingData(data: UserBookingData, status: MessageFetchDataEnum) {
        
        self.bookingData = data
        self.status = status
    }
    
    private func setupButtonView() {
        
        switch status {
        case .store:
            
            if bookingData?.status == FirebaseBookingKey.Status.tobeConfirm.rawValue {
                
                buttonViewHeight.constant = 70
            } else {
                
                buttonViewHeight.constant = 0
            }
        case .normal:
            buttonViewHeight.constant = 0
        }
    }
    
    @objc func notificationData(notifcation: NSNotification) {
        
        if notifcation.name == NSNotification.storeDatas {
            
            tableView.reloadData()
        }
    }
}

extension MessageOrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageImageTableViewCell.self)) as? MessageImageTableViewCell else {return UIView()}
        if let store = FirebaseManger.shared.storeDatas.first(where: {$0.name == bookingData?.store}) {
            
            sectionHeader.setupCell(url: store.photourl)
        }
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellDatas[indexPath.row].cellForIndexPathInDetail(indexPath, tableView: tableView, data: bookingData)
    }
}
