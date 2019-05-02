//
//  SuperMangerStoreConfirmViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class SuperMangerStoreConfirmViewController: BaseStoreDetailViewController {

    @IBOutlet weak var refuseButton: UIButton!
    
    var applyDatas: StoreApplyData? {
        didSet {
            
            self.storeData = applyDatas?.storeData
        }
    }
    override func buttonAction() {
        
        guard let data = applyDatas else {
            
            return
        }
        PBProgressHUD.addLoadingView(animated: true)
        FirebaseManger.shared.applyStoreInSuperManger(pathID: data.pathID, storeData: data.storeData) { [weak self] (result) in
            PBProgressHUD.dismissLoadingView(animated: true)
            
            switch result {
                
            case .success(let message):
                self?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            case .failure(let error):
                
                self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
            }
        }
    }
    @IBAction func refuseButtonAction(_ sender: Any) {
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datas.append(.userName)
        datas.append(.userEmail)
        datas.append(.userPhone)
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForSuperManger(indexPath, tableView: tableView, data: storeData, userData: applyDatas?.user)
    }
}
