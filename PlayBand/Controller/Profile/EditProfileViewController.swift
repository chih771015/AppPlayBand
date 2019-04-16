//
//  EditProfileViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/5.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBAction func editProfileAction() {
        
        guard let name = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let phone = (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let facebook = (tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let band = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        guard let email = (tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? EditTableViewCell)?.textField.text else {
            return
        }
        let userData = UserData(name: name, phone: phone, band: band, email: email, facebook: facebook)
        FirebaseSingle.shared.editProfileInfo(userData: userData) { [weak self] (error) in
            
            if error == nil {
                UIAlertController.alertMessageAnimation(title: "修改會員資料成功", message: nil, viewController: self, completionHanderInDismiss: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            } else {
                
                UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: error?.localizedDescription, viewController: self, completionHanderInDismiss: nil)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {

            tableView.delegate = self
            tableView.dataSource = self
            setupTableView()
        }
    }

    var datas: [ProfileContentCategory] = [.name, .band, .phone, .email, .facebook]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func setupTableView() {

        tableView.lv_registerCellWithNib(identifier: String(describing: EditTableViewCell.self), bundle: nil)
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return datas[indexPath.row].cellForIndexPathInEdit(indexPath, tableView: tableView)
    }
}
