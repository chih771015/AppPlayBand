//
//  EditStoreInfoViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditStoreInfoViewController: BaseEditViewController {
    
    var storeData: StoreData? {
        
        didSet {
            
            setupText()
        }
    }
    
    var getDataClosure: ((StoreData) -> Void)?
    
    var dataString: [ProfileContentCategory: String] = [
        .storePhone: "", .openTime: "", .closeTime: "", .information: ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageName = "申請店家"
        datas = [ .storePhone, .openTime, .closeTime, .information]
        // Do any additional setup after loading the view.
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        
        dataString[datas[textField.tag]] = textField.text
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPathInStore(
            indexPath, tableView: tableView, textFieldDelegate: self, text: dataString[datas[indexPath.row]])
    }
    
    private func setupText() {
        
        guard let storeData = self.storeData else {
            return
        }
        dataString[.storePhone] = storeData.phone
        dataString[.openTime] = storeData.openTime
        dataString[.closeTime] = storeData.closeTime
        dataString[.information] = storeData.information
    }
    
    override func buttonAction() {
        
        do {
            try CheckTextFieldText.checkText(dataString: dataString)
            
            guard let openTime = dataString[.openTime] else {
                return
            }
            guard let closeTime = dataString[.closeTime] else {
                return
            }
            guard let info = dataString[.information] else {
                return
            }
            guard let phone = dataString[.storePhone] else {
                return
            }
            try CheckTextFieldText.openTimeAndCloseTime(openTime: openTime, closeTime: closeTime)
            
            self.storeData?.openTime = openTime
            self.storeData?.closeTime = closeTime
            self.storeData?.information = info
            self.storeData?.phone = phone
            updataStoreData()
            
        } catch let error {
            
            guard let inputError = error as? InputError else {
                
                self.addErrorAlertMessage(
                    title: FirebaseEnum.fail.rawValue,
                    message: error.localizedDescription,
                    completionHanderInDismiss: nil)
                return
            }
            self.addErrorAlertMessage(
                title: FirebaseEnum.fail.rawValue,
                message: inputError.localizedDescription,
                completionHanderInDismiss: nil)
        }
    }
    
    private func updataStoreData() {
        
        guard let storeData = storeData else {return}
        PBProgressHUD.addLoadingView(animated: true)
        FirebaseManger.shared.updataStoreData(storeData: storeData) { [weak self] (result) in
            PBProgressHUD.dismissLoadingView(animated: true)
            
            switch result {
            case .failure(let error):
                
                self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
            case .success(let message):
                
                self?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    if let toStore = self?.getDataClosure {
                        
                        toStore(storeData)
                    }
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}
