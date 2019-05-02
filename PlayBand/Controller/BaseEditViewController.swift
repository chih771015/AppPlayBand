//
//  EditPageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/15.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class BaseEditViewController: UIViewController {
    
    @IBAction func buttonAction() {
        
    }
    
    var pageName = ""
    var descriptionText = ""
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var datas: [ProfileContentCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupButton() {
        view.layoutIfNeeded()
        button.setupButtonModelPlayBand()
    }
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: EditTableViewCell.self), bundle: nil)
        tableView.lv_registerHeaderWithNib(identifier: String(describing: EditTableHeaderFooterView.self), bundle: nil)
        
    }
}

extension BaseEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: EditTableHeaderFooterView.self)) as? EditTableHeaderFooterView else {
                    return UIView()
        }
        header.setupHeader(title: pageName, description: descriptionText)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPathInEdit(indexPath, tableView: tableView, textFieldDelegate: self)
    }
}

extension BaseEditViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
