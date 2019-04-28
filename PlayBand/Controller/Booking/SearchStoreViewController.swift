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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.beginHeaderRefreshing()
    }
    private func getStoreData() {
        
        self.storeDatas = []
        
        PBProgressHUD.addLoadingView(animated: true)
        
        DispatchQueue.global().async {
            
            FirebaseManger.shared.getStoreInfo { [weak self] result in
                
                DispatchQueue.main.async {
                    
                    PBProgressHUD.dismissLoadingView(animated: true)
                    
                    self?.tableView.endHeaderRefreshing()
                    
                    switch result {
                        
                    case .success(let data):
                        
                        self?.storeDatas = data
                        
                    case .failure(let error):
                        
                        self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue,
                                                   message: error.localizedDescription, completionHanderInDismiss: nil)
                    }
                }
            }
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
        var price = ""
        let storeData = storeDatas[indexPath.row]
        for room in storeData.rooms {
            
            price += "$\(room.price)   "
        }
        cell.setupCell(title: storeData.name, imageURL: storeData.photourl,
                       city: storeData.city, price: price)
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
