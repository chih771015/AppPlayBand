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
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: ProfileEnum.textFieldNoValue.rawValue, completionHanderInDismiss: nil)
            return
        }
        guard let confirm = self.passwordConfirm else {
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: ProfileEnum.textFieldNoValue.rawValue, completionHanderInDismiss: nil)
            return
        }
        
        if password == confirm {
            firebase.changePassword(password: password) {[weak self] (result) in
                
                switch result {

                case .success(let data):
                    
                    self?.addSucessAlertMessage(title: data, message: nil, completionHanderInDismiss: { [weak self] in
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                    
                case .failure(let error):
                    
                    self?.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: error.localizedDescription, completionHanderInDismiss: nil)
                }
            }
            
        } else {
            
            self.addErrorAlertMessage(title: FirebaseEnum.fail.rawValue, message: ProfileEnum.passwordNotSame.rawValue, completionHanderInDismiss: nil)
            
        }
    }

    private let firebase = FirebaseManger.shared
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            setupTableView()
        }
    }
    
    private var password: String?
    
    private var passwordConfirm: String?
    
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
        tableView.lv_registerCellWithNib(
            identifier: String(describing: EditSectionHeaderTableViewCell.self), bundle: nil)
    }

}

extension PasswordChangeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditSectionHeaderTableViewCell.self)
            ) as? EditSectionHeaderTableViewCell else {
            return UIView()
        }
        header.setupCell(title: TitleName.title.rawValue)
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellCategory[indexPath.row].cellForIndexPathInEdit(
            indexPath, tableView: tableView, textFieldDelegate: self)
    }
}

extension PasswordChangeViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.placeholder {
        case ProfileContentCategory.password.rawValue:
            
            self.password = textField.text
        case ProfileContentCategory.passwordConfirm.rawValue:
            
            self.passwordConfirm = textField.text
            
        default:
            
            return
        }
    }
}
