//
//  MessageOrderViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/24.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class MessageOrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var bookingData: [UserBookingData] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    private var cellStatus = MessageFetchDataEnum.normal
    var delegate: MessageOrderChildDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView()
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }

    private func setupTableView() {
    
        if tableView ==  nil {
            
            let tableView = UITableView()
            view.stickSubView(tableView)
            self.tableView = tableView
            tableView.separatorStyle = .none
        }
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: MessageOrderTableViewCell.self),
            bundle: nil)
        
        tableView.addRefreshHeader { [weak self] in
            self?.refreshHandler()
        }
    }
    
    func setupBookingData(data: [UserBookingData], status: MessageFetchDataEnum) {
        tableView.endHeaderRefreshing()
        self.bookingData = data
        self.cellStatus = status
    }
}

extension MessageOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookingData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if bookingData.count == 0 {
            
            return UIView.noDataView()
        } else {
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if bookingData.count == 0 {
            
            return UITableView.automaticDimension
            
        } else {
            
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellStatus.cellForIndexPathInOrder(
            tableView: tableView,
            at: indexPath,
            bookingData: bookingData[indexPath.row]
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(
            withIdentifier: String(
                describing: MessageOrderDetailViewController.self)) as? MessageOrderDetailViewController else {return}
        nextVC.setupBookingData(data: bookingData[indexPath.row], status: cellStatus)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 130
    }
    
    func refreshHandler() {
        
        self.delegate?.upRefresh(self)
    }
}

protocol MessageOrderChildDelegate: class {
    
    func upRefresh(_ viewController: MessageOrderViewController)
}
