//
//  PasswordChangeViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/18.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    private enum TitleName: String {
        case title = "更改密碼"
    }
    
    @IBAction func changePasswordAction() {
        guard let password = self.password else {
            
             UIAlertController.alertMessageAnimation(
                title: FirebaseEnum.fail.rawValue,
                message: ProfileEnum.textFieldNoValue.rawValue,
                viewController: self,
                completionHanderInDismiss: nil)
            return
        }
        guard let confirm = self.passwordConfirm else {
            
            UIAlertController.alertMessageAnimation(
                title: FirebaseEnum.fail.rawValue,
                message: ProfileEnum.textFieldNoValue.rawValue,
                viewController: self,
                completionHanderInDismiss: nil)
            return
        }
        
        if password == confirm {
            firebase.changePassword(password: password) {[weak self] (result) in
                
                switch result {

                case .success(let data):
                    
                    UIAlertController.alertMessageAnimation(
                        title: data,
                        message: nil,
                        viewController: self,
                        completionHanderInDismiss: {
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        })
                case .failure(let error):
                    
                    UIAlertController.alertMessageAnimation(
                        
                        title: FirebaseEnum.fail.rawValue,
                        message: error.localizedDescription,
                        viewController: self,
                        completionHanderInDismiss: nil)
                }
            }
            
        } else {
            
            UIAlertController.alertMessageAnimation(title: FirebaseEnum.fail.rawValue, message: ProfileEnum.passwordNotSame.rawValue, viewController: self, completionHanderInDismiss: nil)
            
        }
    }

    private let firebase = FirebaseManger.shared
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            setupTableView()
        }
    }
    
    private var password: String? {
        
        guard let index = cellCategory.index(of: .password) else {return nil}
        let indexPath = IndexPath(row: index, section: 0)
        guard let text = (tableView.cellForRow(at: indexPath) as? EditTableViewCell)?.textField.text else {
            return nil
        }
        return text
    }
    
    private var passwordConfirm: String? {

        guard let index = cellCategory.index(of: .passwordConfirm) else {return nil}
        let indexPath = IndexPath(row: index, section: 0)
        guard let text = (tableView.cellForRow(at: indexPath) as? EditTableViewCell)?.textField.text else {
            return nil
        }
        return text
    }
    
    private let cellCategory: [ProfileContentCategory] = [.password, .passwordConfirm]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButton()
    }
    private func setupButton() {
        
        button.setupButtonModelPlayBand()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lv_registerCellWithNib(identifier: String(describing: EditTableViewCell.self), bundle: nil)
        tableView.lv_registerCellWithNib(identifier: String(describing: EditSectionHeaderTableViewCell.self), bundle: nil)
    }

}

extension PasswordChangeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: String(describing: EditSectionHeaderTableViewCell.self)) as? EditSectionHeaderTableViewCell else {
            return UIView()
        }
        header.setupCell(title: TitleName.title.rawValue)
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellCategory[indexPath.row].cellForIndexPathInEdit(indexPath, tableView: tableView)
    }
}
