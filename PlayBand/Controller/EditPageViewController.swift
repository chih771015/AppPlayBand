//
//  EditPageViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/15.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditPageViewController: UIViewController {
    
    @IBAction func buttonAction() {
        
    }
    
    var pageName = ""
    
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
        tableView.lv_registerCellWithNib(identifier: String(describing: EditSectionHeaderTableViewCell.self), bundle: nil)
    }
}

extension EditPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableCell(
            withIdentifier: String(
                describing: EditSectionHeaderTableViewCell.self)) as? EditSectionHeaderTableViewCell else {
                    return UIView()
        }
        header.setupCell(title: pageName)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPathInEdit(indexPath, tableView: tableView, textFieldDelegate: self)
    }
}

extension EditPageViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
