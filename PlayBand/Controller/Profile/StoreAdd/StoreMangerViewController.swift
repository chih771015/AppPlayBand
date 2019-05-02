//
//  StoreMangerViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/30.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class StoreMangerViewController: BaseEditViewController {
    
    var dataString: [ProfileContentCategory: String] = [
        .storeName: "", .storeCity: "", .storePhone: "", .address: "", .openTime: "", .closeTime: "", .information: ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageName = "申請店家"
        datas = [.storeName, .storeCity, .storePhone, .address, .openTime, .closeTime, .information]
        // Do any additional setup after loading the view.
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        
        dataString[datas[textField.tag]] = textField.text
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPathInStore(
            indexPath, tableView: tableView, textFieldDelegate: self, text: dataString[datas[indexPath.row]])
    }
    
    override func buttonAction() {
        
        var storeData = StoreData()
        
        do {
            try storeData.putDataInEnumDictionay(dataString: dataString)
            
            guard let nextVC = self.storyboard?.instantiateViewController(
                withIdentifier: String(describing: AddRoomViewController.self)) as? AddRoomViewController else {
                    return
            }
            
            nextVC.storeData = storeData
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
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
}
