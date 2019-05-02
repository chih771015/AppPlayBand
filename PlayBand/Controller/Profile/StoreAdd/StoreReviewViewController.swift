//
//  StoreReviewViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/1.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreReviewViewController: BaseStoreDetailViewController {
    
    var images: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupStoreData(storeData: StoreData?, images: [UIImage]) {
        
        self.images = images
        self.storeData = storeData
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: storeData, images: images)
    }
    override func buttonAction() {
        
        guard var data = storeData else {return}
        PBProgressHUD.addLoadingView(animated: true)
        
        FirebaseManger.shared.uploadImagesAndGetURL(images: images) { [weak self] (result) in
            
            switch result {
                
            case .success(var urls):
                data.photourl = urls[0]
                urls.removeFirst()
                data.images = urls
                self?.uploadStoreInformation(data: data)
                
            case .failure(let error):
                PBProgressHUD.dismissLoadingView(animated: true)
                guard let inputError = error as? InputError else {
                    self?.addErrorAlertMessage(
                        title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
                    return
                }
                self?.addErrorAlertMessage(
                    title: FirebaseEnum.fail.rawValue, message: inputError.localizedDescription)
            }
            
        }
    }
    
    private func uploadStoreInformation(data: StoreData) {
        
        FirebaseManger.shared.sendStoreApply(storeData: data) { [weak self] (result) in
            PBProgressHUD.dismissLoadingView(animated: true)
            
            switch result {
            case .success(let message):
                self?.addSucessAlertMessage(title: "完成", message: message, completionHanderInDismiss: { [weak self] in
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            case .failure(let error):
                
                guard let inputError = error as? InputError else {
                    self?.addErrorAlertMessage(
                        title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
                    return
                }
                self?.addErrorAlertMessage(
                    title: FirebaseEnum.fail.rawValue, message: inputError.localizedDescription)
            }
        }
    }
}
