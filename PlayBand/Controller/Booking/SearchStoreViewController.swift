//
//  SearchStoreViewController
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/6.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class ObserverBox<T> {
    
    var value: T {
        
        didSet {
            
            callBack?(value)
        }
    }
    
    var callBack: ((T) -> Void)?
    
    init(_ value: T) {
        
        self.value = value
    }
    
    func listening(callBack: @escaping (T) -> Void) {
        
        callBack(value)
        self.callBack = callBack
    }
    
    func observer(callBack: @escaping (T) -> Void) {
         
         self.callBack = callBack
     }
    
    func remove() {
        
        self.callBack = nil
    }
}

class SerachStoreViewModel {
    
    var storeDatas: [StoreData] = []
        
    let observerResult: ObserverBox<(Result<String>)> = .init(.success(""))
    
    private let storeManger = StoreManager()
    
    init() {
        
        setupNotificationCenter()
    }
    
    private func setupFilterStoreData(storeData: [StoreData]) -> [StoreData] {
         
        if let name = FirebaseManager.shared.userData?.storeBlackList {
                  
            return storeData.filter({!name.contains($0.name)})
        } else {
                  
            return storeData
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
    
    func getStoreData() {
        
        self.storeDatas = []
                
        storeManger.getStoreDatas(completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            
            case .success(let data):
                    
                let filterData = self.setupFilterStoreData(storeData: data)

                self.storeDatas = filterData
                
                self.observerResult.value = .success("")
            case .failure(let error):
                
                self.observerResult.value = .failure(error)
            }
                
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotificationCenter() {
        
        addNotificationObserver(notificationName: NSNotification.userData)
        addNotificationObserver(notificationName: NSNotification.storeDatas)
    }
    
    private func addNotificationObserver(notificationName: NSNotification.Name) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationData(notifcation:)),
                                               name: notificationName,
                                               object: nil)
    }
}

class SearchStoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {

            tableViewSetup()
        }
    }

    private let viewModel = SerachStoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint: disable line_length
    
        viewModel.observerResult.observer { [weak self] (result) in
            PBProgressHUD.dismissLoadingView()
            self?.tableView.endHeaderRefreshing()
            switch result {
                
            case .success:
                
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                self?.addErrorTypeAlertMessage(error: error)
            }
        }
        tableView.beginHeaderRefreshing()
    }
    
    private func tableViewSetup() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: SearchStoreTableViewCell.self),
            bundle: nil)
        tableView.addRefreshHeader { [weak self] in
            
            self?.viewModel.getStoreData()
            PBProgressHUD.addLoadingView(animated: true)
        }
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.storeDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SearchStoreTableViewCell.self), for: indexPath
            ) as? SearchStoreTableViewCell else {
            return UITableViewCell()
        }
        let storeData = viewModel.storeDatas[indexPath.row]
        cell.setupCell(title: storeData.name, imageURL: storeData.photourl,
                       city: storeData.city, price: storeData.returnStorePriceLowToHigh())
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextViewController = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreDetailViewController.self)
        ) as? StoreDetailViewController else {return}
        nextViewController.storeData = self.viewModel.storeDatas[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
