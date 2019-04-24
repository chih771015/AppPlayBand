//
//  StoreDetailViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/7.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {

            setupTableView()
        }
    }
    
    @IBAction func backAction() {
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    private let datas: [StoreContentCategory] = [.images, .name, .phone, .address, .price, .time, .description]
    
    var storeData: StoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setupButton()
    
    }

    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: StoreDescriptionTableViewCell.self),
            bundle: nil)
        tableView.lv_registerCellWithNib(
            identifier: String(describing: StoreInformationTableViewCell.self),
            bundle: nil)
        tableView.lv_registerCellWithNib(
            identifier: String(describing: StoreTitleImageTableViewCell.self),
            bundle: nil)
    }
    
    private func setupButton() {
        
        button.setupButtonModelPlayBand()
    }
}

extension StoreDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: self.storeData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? CalendarViewController else {return}
        nextVC.storeData = self.storeData
    }
}
