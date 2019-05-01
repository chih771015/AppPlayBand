//
//  BaseStoreViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/1.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class BaseStoreViewController: UIViewController {

    @IBOutlet weak var button: UIButton! {
        
        didSet {
            
            setupButton()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }
    
    @IBAction func buttonAction() {
        
   
    }
    
    private let datas: [StoreContentCategory] = [.images, .name, .phone, .address, .price, .time, .description]
    
    var storeData: StoreData? {
        
        didSet {
            
            self.navigationItem.title = storeData?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
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

extension BaseStoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: self.storeData)
    }
}
