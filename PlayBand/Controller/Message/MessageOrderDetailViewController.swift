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
            userUID: bookingData.userUID) { (result) in
                switch result {
                case .success(let message):
                    UIAlertController.alertMessageAnimation(
                        title: message, message: nil, viewController: self,
                        completionHanderInDismiss: { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                    })
                    
                case.failure(let error):
                    UIAlertController.alertMessageAnimation(
                        title: FirebaseEnum.fail.rawValue, message: error.localizedDescription,
                        viewController: self, completionHanderInDismiss: nil)
                }
        }
    }
    
    @IBAction func refuseAction() {
        
        guard let bookingData = self.bookingData else { return }
        
        FirebaseManger.shared.refuseBooking(
            pathID: bookingData.pathID, storeName:
        bookingData.store, userUID: bookingData.userUID) { (result) in
            switch result {
            case .success(let message):
                
                UIAlertController.alertMessageAnimation(
                    title: message, message: nil, viewController: self,
                    completionHanderInDismiss: { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                })
            case .failure(let error):
                UIAlertController.alertMessageAnimation(
                    title: FirebaseEnum.fail.rawValue, message: error.localizedDescription,
                    viewController: self, completionHanderInDismiss: nil)
            }
        }
    }
    
    private var bookingData: UserBookingData?
    
    private let cellDatas: [MessageCategory] = [
        .storeName, .documentID, .status, .userName, .uid, .userEmail,
        .userPhone, .userFacebook, .userMessage]
    
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
    
    func setupBookingData(data: UserBookingData) {
        
        self.bookingData = data
    }
    
    private func setupButtonView() {
        
        if bookingData?.status == FirebaseBookingKey.Status.tobeConfirm.rawValue,
            FirebaseManger.shared.userStatus == UsersKey.Status.manger.rawValue {
            
            buttonViewHeight.constant = 70
        } else {
            
            buttonViewHeight.constant = 0
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
