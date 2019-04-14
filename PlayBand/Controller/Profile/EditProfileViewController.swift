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
        guard let uid = FirebaseSingle.shared.user().currentUser?.uid else {return}
        FirebaseSingle.shared.dataBase().collection("Users").document(uid).setData(
            ["name": name,
            "phone": phone,
            "facebook": facebook,
            "email": email,
            "band": band
        ]) { (error) in
            print(error)
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
