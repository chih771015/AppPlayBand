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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setupTableView()
        tableView.layoutIfNeeded()
        
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
        tableView.lv_registerCellWithNib(identifier: String(describing: MessageOrderTableViewCell.self), bundle: nil)
    }
    
    func setupBookingData(data: [UserBookingData]) {
        
        self.bookingData = data
    }
}

extension MessageOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageOrderTableViewCell.self),
            for: indexPath) as? MessageOrderTableViewCell else {
            return UITableViewCell()
        }
        
        let data = bookingData[indexPath.row]
        let title = data.userInfo.name
        let year = data.bookingTime.date.year
        let month = data.bookingTime.date.month
        let day = data.bookingTime.date.day
        let date = "\(year)/\(month)/\(day)"
        let hours = data.bookingTime.hoursCount()
        let status = data.status
        let url = data.userInfo.photoURL
        cell.setupCell(title: title, date: date, hours: hours, status: status, url: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: MessageOrderDetailViewController.self)) as? MessageOrderDetailViewController else {return}
        nextVC.setupBookingData(data: bookingData[indexPath.row])
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
