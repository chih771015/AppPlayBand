//
//  BaseStoresViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class BaseStoresViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableViewSetup()
        }
    }
    
    var storeDatas: [StoreData] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    let storeManager: StoreManager = StoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint: disable line_length
        
        tableView.beginHeaderRefreshing()
    }
    
    func getStoreData() {
        
        self.storeDatas = []
        
        PBProgressHUD.addLoadingView(animated: true)

        storeManager.getStoreDatas(completionHandler: { [weak self] (result) in
            PBProgressHUD.dismissLoadingView()
            self?.tableView.endHeaderRefreshing()
            switch result {
                
            case .success(let data):
                
                guard let filterData = self?.setupFilterStoreData(storeData: data) else {
                    
                    self?.storeDatas = data
                    return
                }
                
                self?.storeDatas = filterData
            case .failure(let error):
                
                self?.addErrorTypeAlertMessage(error: error)
            }
            
        })
    }
    
    private func setupFilterStoreData(storeData: [StoreData]) -> [StoreData] {
        
        if let name = FirebaseManager.shared.userData?.storeBlackList {
            
            return storeData.filter({!name.contains($0.name)})
        } else {
            
            return storeData
        }
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: SearchStoreTableViewCell.self),
            bundle: nil)
        
        tableView.addRefreshHeader { [weak self] in
            
            self?.getStoreData()
        }
    }
}

extension BaseStoresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return storeDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: SearchStoreTableViewCell.self),
            for: indexPath) as? SearchStoreTableViewCell else {
                return UITableViewCell()
                
        }
        var price = ""
        let storeData = storeDatas[indexPath.row]
        for room in storeData.rooms {
            
            price += "$\(room.price)   "
        }
        cell.setupCell(title: storeData.name, imageURL: storeData.photourl,
                       city: storeData.city, price: price)
        return cell
    }

}
