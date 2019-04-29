//
//  MessageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
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
    private var messageStatus = UsersKey.Status.user
    
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
    }
    
    private func fetchData() {
        
        PBProgressHUD.addLoadingView(animated: true)
        let status = firebaseManger.userStatus
        
        if status == UsersKey.Status.user.rawValue {
            
            firebaseManger.getUserBookingData()
            self.messageStatus = UsersKey.Status.user
        } else if status == UsersKey.Status.manger.rawValue {
            
            firebaseManger.getMangerBookingData()
            self.messageStatus = UsersKey.Status.manger
        } else {
            
            PBProgressHUD.dismissLoadingView(animated: true)
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
        
        PBProgressHUD.dismissLoadingView(animated: true)
        
        if notification.name == NSNotification.Name(NotificationCenterName.bookingData.rawValue) {
            
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
