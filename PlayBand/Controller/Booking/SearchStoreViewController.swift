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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStoreData()
    }
    
    private func getStoreData() {
        
        if FirebaseManger.shared.storeDatas.count != 0 {
            self.storeDatas = FirebaseManger.shared.storeDatas
            return
        }
        
        FirebaseManger.shared.getStoreInfo { [weak self] result in
            
            switch result {
            case .success(let data):
                
                self?.storeDatas = data
                
            case .failure(let error):
                
                UIAlertController.alertMessageAnimation(
                    title: FirebaseEnum.fail.rawValue,
                    message: error.localizedDescription,
                    viewController: self,
                    completionHanderInDismiss: nil)
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

        return storeDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: SearchStoreTableViewCell.self
            ),
            for: indexPath
        ) as? SearchStoreTableViewCell else { return UITableViewCell()}
        cell.setupCell(title: storeDatas[indexPath.row].name,
                       imageURL: storeDatas[indexPath.row].photourl
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 175
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextViewController = self.storyboard?.instantiateViewController(
            withIdentifier: String(describing: StoreDetailViewController.self)
        ) as? StoreDetailViewController else {return}
        nextViewController.storeData = self.storeDatas[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
