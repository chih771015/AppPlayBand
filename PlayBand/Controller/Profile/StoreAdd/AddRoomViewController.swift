//
//  AddRoomViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/30.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class AddRoomViewController: EditPageViewController {
    
    @IBAction func addRooms(_ sender: Any) {
        
        if datas.count > 20 {
            
            return
        }
        
        datas.append(.room)
        dataString.append(StoreData.Room())
        let indexPath = IndexPath(row: (datas.count - 1), section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func buttonAction() {
        
        print("text")
    }
    
    var dataString: [StoreData.Room] = [StoreData.Room()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageName = "增加團室"
        datas = [.room]
        // Do any additional setup after loading the view.
    }
    override func setupTableView() {
        super.setupTableView()
        tableView.lv_registerCellWithNib(identifier: String(describing: StoreAddRoomTableViewCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForRoomEdit(indexPath, tableView: tableView, storeAddRoomCellDelegate: self, texts: dataString[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if datas.count == 1 {
            
            return
        }
        if editingStyle == .delete {
            
            dataString.remove(at: indexPath.row)
            datas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension AddRoomViewController: StoreAddRoomCellDelegate {
    
    func textFieldDidEnd(tableViewCell: UITableViewCell, firstTextField: String?, secondTextField: String?) {
        guard let index = tableView.indexPath(for: tableViewCell) else {return}
        if dataString.count > index.row {
            dataString[index.row].name = firstTextField ?? ""
            dataString[index.row].price = firstTextField ?? ""
        } else {
            return
        }
    }
}
