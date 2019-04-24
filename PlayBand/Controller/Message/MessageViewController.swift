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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    private func setupData() {
        
        let status = firebaseManger.userStatus
        
        if status == UsersKey.Status.user.rawValue {
            
            firebaseManger.getUserBookingData()
            self.userBookingData = firebaseManger.userBookingData
        }
        if status == UsersKey.Status.manger.rawValue {
            
            firebaseManger.getMangerBookingData()
            self.userBookingData = firebaseManger.mangerStoreData
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let childVC = segue.destination as? MessageOrderViewController else {return}
        
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
        
        tobeConfirmVC?.setupBookingData(data: filterData(status: .tobeConfirm))
        confirmVC?.setupBookingData(data: filterData(status: .confirm))
        refuseVC?.setupBookingData(data: filterData(status: .refuse))
    }
    
    private func filterData(status: FirebaseBookingKey.Status) -> [UserBookingData] {
        let datas = userBookingData.filter({$0.status == status.rawValue})
        
        return datas
    }
}

extension MessageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let nowX = scrollView.contentOffset.x
        self.underLineConstraint.constant = nowX / 3
    }
}
