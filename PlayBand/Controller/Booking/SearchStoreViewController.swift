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
        getStoreData()
    }
    private func getStoreData() {
        
        FirebaseManger.shared.getStoreInfo { [weak self] result in
            
            switch result {
            case .success(let data):
                
                self?.storeDatas = data
                
            case .failure(let error):
                
                self?.noDataView.setupView(at: self?.tableView)
                self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription, completionHanderInDismiss: nil)
             
            }
        }
    }
    
    private func tableViewSetup() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.lv_registerCellWithNib(
            identifier: String(describing: SearchStoreTableViewCell.self),
            bundle: nil)
    }
    
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return storeDatas.count * 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: SearchStoreTableViewCell.self),
            for: indexPath) as? SearchStoreTableViewCell else {
                return UITableViewCell()
                
        }
        var price = ""
        for room in storeDatas[0].rooms {
            
            price += "$\(room.price)   "
        }
        cell.setupCell(title: storeDatas[0].name, imageURL: storeDatas[0].photourl,
                       city: storeDatas[0].city, price: price)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextViewController = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreDetailViewController.self)
        ) as? StoreDetailViewController else {return}
        nextViewController.storeData = self.storeDatas[0]
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
