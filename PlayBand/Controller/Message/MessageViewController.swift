//
//  MessageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    private enum SegueName: String {
        
        case tobeConfirm
        case refuse
        case confirm
    }
    
    private enum ChangeModel {
        
        case noStoreMessage
        case title
        case cancelTitle
        
        var title: String {
            
            switch self {
            case .noStoreMessage:
                return "你沒有店家可以管理"
            case .title:
                return "選擇訂單模式"
            case .cancelTitle:
                return "取消"
            }
        }
    }
    
    @IBAction func barButtonAction(_ sender: Any) {
        
        changeViewModel()
    }
    
    @IBAction func tobeConfirmAction() {
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func confirmAction() {
        
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
    }
    @IBAction func refuseAction() {
        
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 2, y: 0), animated: true)
    }
    @IBOutlet weak var underLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tobeConfirmButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            
            scrollView.delegate = self
        }
    }
    
    private let firebaseManger = FirebaseManger.shared
    
    private var userBookingData: [UserBookingData] = [] {
        
        didSet {
            
            setupChildDatas()
        }
    }
    
    private var tobeConfirmVC: MessageOrderViewController?
    private var confirmVC: MessageOrderViewController?
    private var refuseVC: MessageOrderViewController?
    private var messageStatus = MessageFetchDataEnum.normal {
        
        didSet {
         
            self.userBookingData = []
            self.fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        setupData()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupData() {
        
        setupNotifaication(nsNotifcationName: NSNotification.storeDatas)
        setupNotifaication(nsNotifcationName: NSNotification.bookingData)
        setupNotifaication(nsNotifcationName: NSNotification.userData)

        fetchData()
    }
    
    private func setupNotifaication(nsNotifcationName: NSNotification.Name) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getBookingData(notification:)), name: nsNotifcationName, object: nil)
        
    }
    
    private func fetchData() {
        
        PBProgressHUD.addLoadingView(animated: true)
        switch messageStatus {
        case .normal:
            firebaseManger.getUserBookingData()
        case .store(let storeName):
            
            firebaseManger.getStoreBookingDataWithManger(storeName: storeName) { [weak self] (result) in
                PBProgressHUD.dismissLoadingView(animated: true)
                switch result {
                case .success(let data):
                    self?.userBookingData = data
                case .failure(let error):
                    self?.addErrorTypeAlertMessage(error: error)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let childVC = segue.destination as? MessageOrderViewController else { return }
        
        childVC.setupRefreshHandler { [weak self] in
            
            self?.userBookingData = []
            self?.fetchData()
        }
        childVC.loadViewIfNeeded()
        let identifier = segue.identifier
        if identifier == SegueName.confirm.rawValue {
            
            self.confirmVC = childVC
        } else if identifier == SegueName.tobeConfirm.rawValue {
            
            self.tobeConfirmVC = childVC
        } else if identifier == SegueName.refuse.rawValue {
            
            self.refuseVC = childVC
        }
    }
    
    private func setupChildDatas() {
        
        tobeConfirmVC?.setupBookingData(data: filterData(status: .tobeConfirm), status: self.messageStatus)
        confirmVC?.setupBookingData(data: filterData(status: .confirm), status: self.messageStatus)
        refuseVC?.setupBookingData(data: filterData(status: .refuse), status: self.messageStatus)
    }
    
    private func filterData(status: FirebaseBookingKey.Status) -> [UserBookingData] {
        
        let datas = userBookingData.filter({$0.status == status.rawValue})
        
        guard let userData = FirebaseManger.shared.userData else {
            
            return datas
        }
        let userBookingDataFilterStore = datas.filter({!userData.storeBlackList.contains($0.store)})
        let usersUID = userData.userBlackLists.map({$0.uid})
        let userBookingDataFilterUser = userBookingDataFilterStore.filter({!usersUID.contains($0.userUID)})
        
        return userBookingDataFilterUser
        
    }
    
    @objc func getBookingData(notification: NSNotification) {
        
        if notification.name == NSNotification.bookingData {
            PBProgressHUD.dismissLoadingView(animated: true)
            guard let bookingDatas = notification.object as? [UserBookingData] else {return}
            self.userBookingData = bookingDatas
        }
        if notification.name == NSNotification.storeDatas {
            
            fetchData()
        }
        if notification.name == NSNotification.userData {
            
            setupChildDatas()
        }
    }
    
    func setupModel(with type: MessageFetchDataEnum) {
        
        self.messageStatus = type
        self.navigationItem.title = type.title
    }
    
    func changeViewModel() {
        
        if FirebaseManger.shared.storeName.isEmpty {
            self.addErrorAlertMessage(message: ChangeModel.noStoreMessage.title)
            return
        }
        
        var actionAndHandlers: [ActionHandler] = [(MessageFetchDataEnum.normal.title, { [weak self] _ in
            self?.setupModel(with: .normal)
        })]
        
        for store in FirebaseManger.shared.storeName {
            
            let action: ActionHandler = (MessageFetchDataEnum.store(store).title, { [weak self] _ in self?.setupModel(with: .store(store))})
            actionAndHandlers.append(action)
        }
        
        self.addAlertActionSheet(title: ChangeModel.title.title, message: nil, actionTitleAndHandlers: actionAndHandlers, cancelTitle: ChangeModel.cancelTitle.title)
    }
}

extension MessageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let nowX = scrollView.contentOffset.x
        self.underLineConstraint.constant = nowX / 3
    }
}
