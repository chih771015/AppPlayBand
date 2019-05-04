//
//  BlackListViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/5/4.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class BlackListViewController: UIViewController {

    private var names: [String] = []
    private var listStyle = BlackList.user
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: SettingTableViewCell.self), bundle: nil)
    }

    func setupController(listStyle: BlackList, name: [String]) {
        
        self.navigationItem.title = listStyle.rawValue
        self.listStyle = listStyle
        self.names = name
    }
}

extension BlackListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if names.count == 0 {
            
            return UIView.noDataView()
        } else {
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if names.count == 0 {
            
            return UITableView.automaticDimension
            
        } else {
            
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingTableViewCell.self), for: indexPath) as? SettingTableViewCell else {
            
            return UITableViewCell()
        }
        cell.setupWithBlackList(title: names[indexPath.row], image: "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.addAlert(title: "確定要將 \(names[indexPath.row]) 移除黑名單嗎", actionTitle: "確定", cancelTitle: "取消") { [weak self] (_) in
                self?.removeBlackList(indexPath: indexPath)
            }
        }
    }
    
    private func removeBlackList(indexPath: IndexPath) {
        
        let name = names[indexPath.row]
        
        FirebaseManger.shared.removeBlackList(listStyle: listStyle, name: name) { [weak self] (result) in
            
            switch result {
            
            case .success(let message):
                
                self?.addSucessAlertMessage(title: message, message: nil, completionHanderInDismiss: {
                    
                    self?.removeCell(indexPath: indexPath)
                })
            case .failure(let error):
                
                self?.addErrorTypeAlertMessage(error: error)
            }
        }
    }
    
    private func removeCell(indexPath: IndexPath) {
        
        self.names.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        if names.count == 0 {
            tableView.reloadData()
        }
    }
}
