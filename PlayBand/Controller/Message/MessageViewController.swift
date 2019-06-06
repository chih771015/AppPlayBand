//
//  MessageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

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
    
    @objc func barButtonAction(_ sender: Any) {
        
        changeViewModel()
    }
    
    private let userManager = UserManager()
    private var userBookingData: [UserBookingData] = [] {
        
        didSet {
            
            setupChildDatas()
        }
    }
    
    private var tobeConfirmVC: MessageOrderViewController = MessageOrderViewController()
    private var confirmVC: MessageOrderViewController = MessageOrderViewController()
    private var refuseVC: MessageOrderViewController = MessageOrderViewController()
    private var messageStatus = MessageFetchDataEnum.normal {
        
        didSet {
         
            self.userBookingData = []
            self.fetchData()
        }
    }
    
    let messageSubView = ScrollViewWithThreeActionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ParentDidLoadBegin")
        setupTestView()
        setupChildVC()
        setupChildView()
        setupData()
        setupNavigationItem()
        view.layoutIfNeeded()
        print("ParentDidLoadEnd")
    }
    
    override func loadView() {
        super.loadView()
        print("ParentLoadView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ParentWillAppear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ParentWillLayout")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ParentDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ParentWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ParentViewDidDisappear")
    }
    
    private func setupNavigationItem() {
        
        let barButton = UIBarButtonItem(
            title: "選擇模式", style: .done, target: self, action: #selector(barButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.title = messageStatus.title
    }
    
    private func setupTestView() {
        
        self.view.stickSubView(messageSubView)
        messageSubView.setupTitle(first: "等待回覆", second: "已預定", third: "已拒絕")
        messageSubView.delegate = self
        messageSubView.scrollView.delegate = self
    }
    
    private func setupChildVC() {
        
        addChild(tobeConfirmVC)
        tobeConfirmVC.delegate = self
        addChild(confirmVC)
        confirmVC.delegate = self
        addChild(refuseVC)
        refuseVC.delegate = self
        print("setupChildVC")
    }
    
    private func setupChildView() {
        print("ChildViewSubBegin")
        messageSubView.setupScrollViewSubViewFullSize(at: self.children.count)
 //       messageSubView.setupScrollViewSubViewFullSize(at: 3)

        let viewCount = messageSubView.scrollView.subviews.count
        for index in 0..<viewCount {
//            print("setupChildViewWillSub")
            messageSubView.scrollView.subviews[index].stickSubView(self.children[index].view)
//            print("setupChildViewDidSub")
        }

        print("setupChildViewDidSub")
        
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getBookingData(notification:)),
                                               name: nsNotifcationName,
                                               object: nil)
        
    }
    
    private func fetchData() {
        
        PBProgressHUD.addLoadingView(animated: true)
        
        switch messageStatus {
            
        case .normal:
            
            userManager.getUserBookingDatasWithUserType
                { [weak self] result in self?.bookingDataResultCheck(result: result)}
        case .store(let storeName):
    
            userManager.getUserBookingDatasWithStoreType(
            storeName: storeName) {[weak self] result in self?.bookingDataResultCheck(result: result)}
        }
    }
    
    private func bookingDataResultCheck(result: Result<[UserBookingData]>) {
        
        PBProgressHUD.dismissLoadingView(animated: true)
        switch result {
        case .success(let data):
            self.userBookingData = data
        case .failure(let error):
            self.addErrorTypeAlertMessage(error: error)
        }
        
    }

    private func setupChildDatas() {
        
        tobeConfirmVC.setupBookingData(data: filterData(status: .tobeConfirm), status: self.messageStatus)
        confirmVC.setupBookingData(data: filterData(status: .confirm), status: self.messageStatus)
        refuseVC.setupBookingData(data: filterData(status: .refuse), status: self.messageStatus)
    }
    
    private func filterData(status: FirebaseBookingKey.Status) -> [UserBookingData] {
        
        let datas = userBookingData.filter({$0.status == status.rawValue})
        
        guard let userData = FirebaseManager.shared.userData else {
            
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
    
    private func setupModel(with type: MessageFetchDataEnum) {
        
        self.messageStatus = type
        self.navigationItem.title = type.title
    }
    
    private func changeViewModel() {
        
        if FirebaseManager.shared.storeName.isEmpty {
            self.addErrorAlertMessage(message: ChangeModel.noStoreMessage.title)
            return
        }
        
        var actionAndHandlers: [ActionHandler] = [(MessageFetchDataEnum.normal.title, { [weak self] _ in
            self?.setupModel(with: .normal)
        })]
        
        for store in FirebaseManager.shared.storeName {
            
            let action: ActionHandler = (MessageFetchDataEnum.store(store).title, { [weak self] _ in
                self?.setupModel(with: .store(store))})
            actionAndHandlers.append(action)
        }
        
        self.addAlertActionSheet(
            title: ChangeModel.title.title, message: nil,
            actionTitleAndHandlers: actionAndHandlers,
            cancelTitle: ChangeModel.cancelTitle.title)
    }
}

extension MessageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let nowX = scrollView.contentOffset.x
        let width = scrollView.contentSize.width
        let scale = nowX / width

        messageSubView.setupUnderLineView(xPoint: self.view.frame.width * scale)
    }
}

extension MessageViewController: MessageOrderChildDelegate {
    
    func upRefresh(_ viewController: MessageOrderViewController) {
        
        fetchData()
    }
}

extension MessageViewController: ScrollViewWithThreeActionDelegate {
    
    func leftAction() {
        messageSubView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func rightAction() {
        messageSubView.scrollView.setContentOffset(CGPoint(x: messageSubView.scrollView.frame.width * 2, y: 0), animated: true)
    }
    
    func centerAction() {
        messageSubView.scrollView.setContentOffset(CGPoint(x: messageSubView.scrollView.frame.width * 1, y: 0), animated: true)
    }
}
