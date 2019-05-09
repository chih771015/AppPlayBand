//
//  SearchStoreViewController
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SearchStoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {

            tableViewSetup()
        }
    }
    
    private var storeDatas: [StoreData] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    private let noDataView = NoDataView()
    let storeProvider = StoreManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint: disable line_length

        tableView.beginHeaderRefreshing()
        
        NotificationCenter.default
            .addObserver(
            self, selector: #selector(notificationData(notifcation:)), name: NSNotification.storeDatas, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationData(notifcation:)), name: NSNotification.userData, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func getStoreData() {
        
        self.storeDatas = []
        
        PBProgressHUD.addLoadingView(animated: true)
        
        storeProvider.getStoreDatas(completionHandler: { [weak self] (result) in
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
    
    @objc func notificationData(notifcation: NSNotification) {
        
//        if notifcation.name == NSNotification.storeDatas {
//
//            let filterData = setupFilterStoreData(storeData: FirebaseManger.shared.storeDatas)
//            self.storeDatas = filterData
//        }
//        if notifcation.name == NSNotification.userData {
//
//            self.storeDatas = setupFilterStoreData(storeData: FirebaseManger.shared.storeDatas)
//        }
    }
    
    private func setupFilterStoreData(storeData: [StoreData]) -> [StoreData] {
   
        if let name = FirebaseManger.shared.userData?.storeBlackList {
            
            return storeData.filter({!name.contains($0.name)})
        }
        
        return storeData
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {

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
        let storeData = storeDatas[indexPath.row]
        cell.setupCell(title: storeData.name, imageURL: storeData.photourl,
                       city: storeData.city, price: storeData.returnStorePriceLowToHigh())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextViewController = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreDetailViewController.self)
        ) as? StoreDetailViewController else {return}
        nextViewController.storeData = self.storeDatas[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
    }

}
