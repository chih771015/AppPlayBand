//
//  MessageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBAction func barButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "切換模式", message: "請選擇模式", preferredStyle: .actionSheet)
        
        let actionUser = UIAlertAction(title: "一般用戶模式", style: .default) { [weak self] (_) in
            self?.messageStatus = .normal
        }
        actionUser.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        alert.addAction(actionUser)
        
        for store in FirebaseManger.shared.storeName {
            
            let actionManger = UIAlertAction(title: "管理\(store)", style: .default) { [weak self] (_) in
                self?.messageStatus = .store(store)
            }
            actionManger.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
            alert.addAction(actionManger)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.playBandColorEnd, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
    private enum SegueName: String {
        
        case tobeConfirm
        case refuse
        case confirm
    }
    
    private let firebaseManger = FirebaseManger.shared
    
    var userBookingData: [UserBookingData] = [] {
        
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
        // Do any additional setup after loading the view.
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    private func setupData() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(getBookingData(notification:)),
            name: NSNotification.Name(NotificationCenterName.bookingData.rawValue),
            object: nil)
        fetchData()
        if firebaseManger.userStatus == UsersKey.Status.user.rawValue {
            
            self.navigationItem.rightBarButtonItems = []
        }
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
                    self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
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
        
        return datas
    }
    
    @objc func getBookingData(notification: NSNotification) {
        
        if notification.name == NSNotification.Name(NotificationCenterName.bookingData.rawValue) {
            PBProgressHUD.dismissLoadingView(animated: true)
            guard let bookingDatas = notification.object as? [UserBookingData] else {return}
            self.userBookingData = bookingDatas
        }
        
    }
}

extension MessageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let nowX = scrollView.contentOffset.x
        self.underLineConstraint.constant = nowX / 3
    }
}
