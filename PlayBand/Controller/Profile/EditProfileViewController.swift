//
//  EditProfileViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    enum PageName: String {
        
        case name = "修改用戶資料"
        case success = "修改會員資料成功"
    }
    
    @IBOutlet weak var button: UIButton!
    @IBAction func editProfileAction() {
        
        guard let name = (tableView.cellForRow(
            at: IndexPath(row: 0, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let phone = (tableView.cellForRow(
            at: IndexPath(row: 2, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let facebook = (tableView.cellForRow(
            at: IndexPath(row: 4, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let band = (tableView.cellForRow(
            at: IndexPath(row: 1, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let email = (tableView.cellForRow(
            at: IndexPath(row: 3, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        let userData = UserData(name: name, phone: phone, band: band, email: email, facebook: facebook)
        FirebaseManger.shared.editProfileInfo(userData: userData) { [weak self] (error) in
            
            if error == nil {
                
                self?.addSucessAlertMessage(title: PageName.success.rawValue, message: nil, completionHanderInDismiss: { [weak self] in
                    
                    self?.navigationController?.popViewController(animated: true)
                })

            } else {
                
                self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error?.localizedDescription, completionHanderInDismiss: nil)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            setupTableView()
        }
    }

    var datas: [ProfileContentCategory] = [.name, .band, .phone, .email, .facebook]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }

    private func setupNavigationBar() {
        
        guard let color = UIColor.playBandColorEnd else {return}
        
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupButton() {
        view.layoutIfNeeded()
        button.setupButtonModelPlayBand()
    }
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: EditTableViewCell.self), bundle: nil)
        tableView.lv_registerCellWithNib(identifier: String(describing: EditSectionHeaderTableViewCell.self), bundle: nil)
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableCell(withIdentifier: String(describing: EditSectionHeaderTableViewCell.self)) as? EditSectionHeaderTableViewCell else {
            return UIView()
        }
        header.setupCell(title: PageName.name.rawValue)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return datas[indexPath.row].cellForIndexPathInEdit(indexPath, tableView: tableView, textFieldDelegate: self)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
