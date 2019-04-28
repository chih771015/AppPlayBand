//
//  MessageStoreCheckViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/12.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageStoreCheckViewController: UIViewController {

    @IBOutlet weak var buttonViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction() {
        guard let bookingData = userBookingData else { return }
        
        FirebaseManger.shared.refuseBooking(
        pathID: bookingData.pathID, storeName:
        bookingData.store, userUID: bookingData.userUID) { (result) in
            
            switch result {
                
            case .success(let message):
                
                self.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    self?.dismiss(animated: true, completion: nil)
                })
                
            case .failure(let error):
                
                self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription, completionHanderInDismiss: nil)
            }
        }
    }
    
    @IBAction func confirmAction() {
        guard let bookingData = userBookingData else { return }
        
        FirebaseManger.shared.updataBookingConfirm(
        storeName: bookingData.store, pathID: bookingData.pathID,
        userUID: bookingData.userUID) { (result) in
            switch result {
            case .success(let message):
                
                self.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    self?.dismiss(animated: true, completion: nil)
                })
                
            case.failure(let error):
                
                self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription, completionHanderInDismiss: nil)

            }
        }
    }
    
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var buttonView: UIView!
    var userBookingData: UserBookingData?
    var store: StoreData?
    var category: [ProfileContentCategory] = [.name, .band, .email, .facebook, .bookingTime, .store, .storePhone]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewModel()
        if FirebaseManger.shared.userStatus == UsersKey.Status.user.rawValue {
            buttonViewConstraint.constant = -70
        }
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: MessageConfirmPageTableViewCell.self),
            bundle: nil)
    }
    
    private func setupViewModel() {
        
        let stores = FirebaseManger.shared.storeDatas
        var url = String()
        for store in (stores.filter({$0.name == userBookingData?.store})) {
            
            url = store.photourl
            self.store = store
        }
        self.titleImage.lv_setImageWithURL(url: url)
    }
}

extension MessageStoreCheckViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return category[indexPath.row].cellForIndexPathInMessageConfirm(
            indexPath, tableView: tableView, bookingData: self.userBookingData,
            storeData: self.store, delgate: self)
    }

}

extension MessageStoreCheckViewController: MessageConfirmCellDelgate {
    
    func buttonAction(title: String) {
        
        switch title {
        case ProfileContentCategory.name.rawValue:
            
            guard let nextVC = self.storyboard?.instantiateViewController(
                withIdentifier: String(
                    describing: MessageUserProfileViewController.self)) as? MessageUserProfileViewController else {
                        return
            }
            
            present(nextVC, animated: true, completion: nil)
            
        case ProfileContentCategory.store.rawValue:
            
            break
        default:
            break
        }
    }
}
