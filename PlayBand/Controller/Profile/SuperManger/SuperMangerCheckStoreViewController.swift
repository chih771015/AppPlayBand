//
//  SuperMangerCheckStoreViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SuperMangerCheckStoreViewController: BaseStoresViewController {

    var datas: [StoreApplyData] = [] {
        didSet {
            
           setupStoreData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func getStoreData() {
        PBProgressHUD.addLoadingView(animated: true)
        
        FirebaseManger.shared.getStoreApplyDataWithSuperManger { [weak self] (result) in
            self?.tableView.endHeaderRefreshing()
            PBProgressHUD.dismissLoadingView(animated: true)
            
            switch result {
                
            case .success(let data):
                self?.datas = data
            case .failure(let error):
                self?.addErrorAlertMessage(
                    title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
            }
        }
    }
    
    private func setupStoreData() {
        
        var datas: [StoreData] = []
        for data in self.datas {
            
            datas.append(data.storeData)
        }
        self.storeDatas = datas
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(
            withIdentifier: String(
                describing: SuperMangerStoreConfirmViewController.self
        )) as? SuperMangerStoreConfirmViewController else {
            return
        }
        nextVC.applyDatas = datas[indexPath.row]
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
