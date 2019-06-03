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

    private let storeManger = StoreManager()
    private let cellType = StoreContentCategory.storeSearch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint: disable line_length

        tableView.beginHeaderRefreshing()
        setupNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SearchStoreViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SearchStoreViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SearchStoreViewWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SearchStoreViewDidDisappear")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotificationCenter() {
        
        addNotificationObserver(notificationName: NSNotification.userData)
        addNotificationObserver(notificationName: NSNotification.storeDatas)
    }
    
    private func addNotificationObserver(notificationName: NSNotification.Name) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationData(notifcation:)), name: notificationName, object: nil)
    }
    
    private func getStoreData() {
        
        self.storeDatas = []
        
        PBProgressHUD.addLoadingView(animated: true)
        
        storeManger.getStoreDatas(completionHandler: { [weak self] (result) in
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
        
        if notifcation.name == NSNotification.storeDatas {

            let filterData = setupFilterStoreData(storeData: FirebaseManager.shared.storeDatas)
            self.storeDatas = filterData
        }
        if notifcation.name == NSNotification.userData {

            self.storeDatas = setupFilterStoreData(storeData: FirebaseManager.shared.storeDatas)
        }
    }
    
    private func setupFilterStoreData(storeData: [StoreData]) -> [StoreData] {
   
        if let name = FirebaseManager.shared.userData?.storeBlackList {
            
            return storeData.filter({!name.contains($0.name)})
        } else {
            
            return storeData
        }
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return storeDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return cellType.cellForeSearch(indexPath, tableView: tableView, storeData: storeDatas[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextViewController = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreDetailViewController.self)
        ) as? StoreDetailViewController else {return}
        nextViewController.storeData = self.storeDatas[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
    }

}
