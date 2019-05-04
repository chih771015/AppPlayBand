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
    @IBAction func addBlackListAction(_ sender: Any) {
        
        self.addAlert(
        title: "你確定要將此店家加入黑名單嗎?", message: "黑名單可以在設定頁面取消",
        actionTitle: "確認", cancelTitle: "取消", cancelHandler: nil) { [weak self] (_) in
            
            self?.addBlackList()
        }
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
    
    private func addBlackList() {
        guard let storeName = storeData?.name else {return}
        
        PBProgressHUD.addLoadingView()
        FirebaseManger.shared.userAddStoreBlackList(storeName: storeName) { [weak self] (result) in
            
            PBProgressHUD.dismissLoadingView()
            switch result {
                
            case .success(let message):
                
                self?.addSucessAlertMessage(
                    title: message, message: nil, completionHanderInDismiss: { [weak self] in
                        
                        self?.navigationController?.popViewController(animated: true)
                })
                
            case .failure(let error):
                
                self?.addErrorTypeAlertMessage(error: error)
            }
        }
    }
}
