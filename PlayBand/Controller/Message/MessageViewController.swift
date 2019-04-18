//
//  MessageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/11.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    private let firebaseManger = FirebaseManger.shared
    
    var userBookingData: [UserBookingData] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    private func setupTableView() {
        
        tableView.lv_registerCellWithNib(identifier: String(describing: MessageTableViewCell.self), bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupData() {
        
        let status = firebaseManger.userStatus
        
        if status == UsersKey.Status.user.rawValue {
            
            self.userBookingData = firebaseManger.userBookingData
        }
        if status == UsersKey.Status.manger.rawValue {
            
            self.userBookingData = firebaseManger.mangerStoreData
        }
    }
}

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewCell()
        header.textLabel?.text = "測試"
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userBookingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageTableViewCell.self),
            for: indexPath
            ) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let data = userBookingData[indexPath.row]
        cell.setupCell(count: data.bookingTime.hour.count, status: data.status, title: data.userInfo.name)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: String(describing: MessageStoreCheckViewController.self)) else {
            return
            
        }
        self.present(nextVC, animated: true, completion: nil)
    }
}
