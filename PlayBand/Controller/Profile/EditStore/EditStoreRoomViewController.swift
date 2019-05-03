//
//  EditStoreRoomViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/3.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditStoreRoomViewController: BaseEditViewController {

    @IBAction func addRooms(_ sender: Any) {
        
        if datas.count > 20 {
            
            return
        }
        
        dataRooms.append(StoreData.Room())
        let indexPath = IndexPath(row: (datas.count - 1), section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func buttonAction() {
        
        do {
            try storeData?.addRooms(rooms: dataRooms)
            
            guard let storeData = self.storeData else {
                
                return
            }
            PBProgressHUD.addLoadingView(animated: true)
            FirebaseManger.shared.updataStoreData(storeData: storeData) { [weak self] (result) in
                PBProgressHUD.dismissLoadingView(animated: true)
                switch result {
                    
                case .success(let message):
                    
                    self?.addSucessAlertMessage(
                        title: message, message: nil,
                        completionHanderInDismiss: { [weak self] in
                            
                            if let closure = self?.getDataClosure {
                                closure(storeData)
                            }
                            FirebaseManger.shared.replaceStoreData(storeData: storeData)
                            self?.navigationController?.popViewController(animated: true)
                        })
                    
                case .failure(let error):
                    
                    self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription)
                }
            }
            
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
    
    var getDataClosure: ((StoreData) -> Void)?
    var dataRooms: [StoreData.Room] = [] {
        didSet {
            
            setupDatas()
        }
    }
    
    var storeData: StoreData? {
        
        didSet {
            
            setupRooms()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pageName = "修改團室"
        descriptionText = "上限20間"
        // Do any additional setup after loading the view.
    }
    override func setupTableView() {
        super.setupTableView()
        tableView.lv_registerCellWithNib(identifier: String(describing: StoreAddRoomTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForRoomEdit(
            indexPath, tableView: tableView, storeAddRoomCellDelegate: self, texts: dataRooms[indexPath.row])
    }
    
    func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if datas.count == 1 {
            
            return
        }
        if editingStyle == .delete {
            
            dataRooms.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    private func setupDatas() {
        
        var datas: [ProfileContentCategory] = []
        
        for _ in dataRooms {
            
            datas.append(.room)
        }
        self.datas = datas
        
    }
    
    private func setupRooms() {
        
        guard let rooms = storeData?.rooms else {return}
        self.dataRooms = rooms
    }
}

extension EditStoreRoomViewController: StoreAddRoomCellDelegate {
    
    func textFieldDidEnd(tableViewCell: UITableViewCell, firstTextField: String?, secondTextField: String?) {
        guard let index = tableView.indexPath(for: tableViewCell) else {return}
        if dataRooms.count > index.row {
            dataRooms[index.row].name = firstTextField ?? ""
            dataRooms[index.row].price = secondTextField ?? ""
        } else {
            return
        }
    }
}
